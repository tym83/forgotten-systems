#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "risc-cpu.h"

enum {
  MOV, LSL, ASR, ROR,
  AND, ANN, IOR, XOR,
  ADD, SUB, MUL, DIV,
  FAD, FSB, FML, FDV,
};

static void risc_single_step(const struct RISC_IO *risc_io, struct RISC *risc);
static void risc_set_register(struct RISC *risc, int reg, uint32_t value);
static uint32_t fp_add(uint32_t x, uint32_t y, bool u, bool v);
static uint32_t fp_mul(uint32_t x, uint32_t y);
static uint32_t fp_div(uint32_t x, uint32_t y);
static struct idiv { uint32_t quot, rem; } idiv(uint32_t x, uint32_t y, bool signed_div);

/* ─── Счётчик тактов ────────────────────────────────────────────────────────
   Модель латентностей ВЫВЕДЕНА ИЗ ИЗМЕРЕНИЙ на настоящем RTL Вирта под Verilator
   и проверена против него потактово на 61 инструкции (расхождений 0).
   См. impl/tb/cycle_model.h и docs/FINDING-01-counter-period.md.

   Латентности: 1 такт обычные; 2 — LD/ST (одна шина на код и данные);
   4 — FAD/FSB; 26 — FML; 27 — FDV; 34 — MUL/DIV.
   Подряд идущая операция ТОГО ЖЕ блока стоит период счётчика (2^разрядность):
   FPAdder 4, FPMultiplier 32, FPDivider 32, Multiplier 64, Divider 64.        */
uint64_t risc_cycles = 0;
uint64_t risc_insns  = 0;

/* ─── Динамический профиль проверок границ ───────────────────────────────────
   Зачем: решение о кодировании CHK принималось по распределению МЕСТ проверки
   (медиана предела 32), и это оказалось плохим предиктором — горячие циклы
   гоняют крупные массивы. См. docs/FINDING-09. Здесь считается, сколько РАЗ
   исполняется проверка каждого класса длин, а не сколько их в коде.
   Работает на конфигурации B (программные проверки): пара
   SUB RH, idx, #lim  +  BLR CC, ...MT  -- ловим по второму слову.            */
#define PROF_BUCKETS 8
uint64_t risc_chk_hits[PROF_BUCKETS];      /* исполнений по классам предела */
uint64_t risc_chk_dyn_total;
static const uint32_t prof_hi[PROF_BUCKETS] = {15,63,127,255,1023,4095,65535,0xFFFFFFFFu};
static uint32_t prof_prev_insn;            /* предыдущая инструкция */

static void profile_check(uint32_t ir, uint32_t prev) {
  /* ловушка индекса массива: BLR (нибл 1101), cond=10, номер 1, c = MT = 12 */
  if ((ir >> 28) != 0xD || (ir & 0xF) != 12 || ((ir >> 4) & 0xF) != 1) return;
  /* предшествующее слово: F1 SUB с непосредственным пределом */
  if ((prev >> 28) != 0x4 || ((prev >> 16) & 0xF) != 9) return;
  uint32_t lim = prev & 0xFFFF;
  for (int i = 0; i < PROF_BUCKETS; i++)
    if (lim <= prof_hi[i]) { risc_chk_hits[i]++; break; }
  risc_chk_dyn_total++;
}
enum { CU_NONE = 0, CU_MUL, CU_DIV, CU_FPADD, CU_FPMUL, CU_FPDIV };
static int cu_prev = CU_NONE;

static void count_cycles(uint32_t ir) {
  int unit = CU_NONE, lat = 1, period = 1;
  if ((ir & 0x80000000u) == 0) {
    switch ((ir & 0x000F0000u) >> 16) {
      case 10: unit = CU_MUL;   lat = 34; period = 64; break;
      case 11: unit = CU_DIV;   lat = 34; period = 64; break;
      case 12: case 13: unit = CU_FPADD; lat = 4; period = 4; break;
      case 14: unit = CU_FPMUL; lat = 26; period = 32; break;
      case 15: unit = CU_FPDIV; lat = 27; period = 32; break;
      default: break;
    }
  } else if ((ir & 0x40000000u) == 0) {
    lat = 2; period = 2;                 /* LD/ST */
  }
  risc_cycles += (unit != CU_NONE && unit == cu_prev) ? period : lat;
  cu_prev = unit;
  risc_insns++;
  profile_check(ir, prof_prev_insn);
  prof_prev_insn = ir;
}


void risc_run(const struct RISC_IO *io, struct RISC *risc) {
  for (;;) {
    risc_single_step(io, risc);
  }
}

static void risc_single_step(const struct RISC_IO *io, struct RISC *risc) {
  uint32_t ir = io->read_program(risc, risc->PC);
  count_cycles(ir);
  risc->PC++;

  const uint32_t pbit = 0x80000000;
  const uint32_t qbit = 0x40000000;
  const uint32_t ubit = 0x20000000;
  const uint32_t vbit = 0x10000000;

  if ((ir & pbit) == 0) {
    // Register instructions
    uint32_t a  = (ir & 0x0F000000) >> 24;
    uint32_t b  = (ir & 0x00F00000) >> 20;
    uint32_t op = (ir & 0x000F0000) >> 16;
    uint32_t im =  ir & 0x0000FFFF;
    uint32_t c  =  ir & 0x0000000F;

    /* ─── CHK: аппаратная проверка границ массива ────────────────────────
       Кодировка: F0 (p=0, q=0), v=1, op=1 -- алиас LSL, который компилятор
       никогда не эмитит (доказано зондом декодера: impl/tb/decoder_probe.cpp).
       Индекс в поле b, предел в IR[15:4] (12 бит), регистр c = 12 (MT).
       При срабатывании делает то же, что BLR: R15 := адрес следующей команды,
       PC := R[12]. Иначе -- ничего: ни записи регистра, ни флагов.
       Семантика совпадает с RTL (impl/tests/t2_chk.s, 5/5).                */
    /* Бит u проверяется явно: иначе CHK заняла бы и кодировку 0011. */
    if ((ir & qbit) == 0 && (ir & ubit) == 0 && (ir & vbit) != 0 && op == LSL) {
      /* Предел -- IR[15:8], 8 бит. Биты IR[7:4] СОХРАНЕНЫ под номером ловушки,
         который Kernel.Trap читает по R15-4 (Kernel.Mod:256), а IR[23:16] под
         позицию в исходнике. Решение принято по данным: медианный массив в системе
         32 элемента, 8 бит покрывают 70-85% проверок, а 12 бит ломают диагностику
         полностью (измерено: "unknown trap 8"). См. docs/FINDING-08. */
      /* Кодировка предела выбирается переменной окружения NOREBO_CHK.
         Раньше здесь было жёстко зашито только SPLIT, из-за чего конфигурация C
         (предел 12 бит в IR[15:4]) не запускалась вовсе: декодер читал предел
         как lim DIV 16, проверка срабатывала на законных индексах и компилятор
         падал через ~1.7 млн тактов. Найдено аудитом.

           NOREBO_CHK=split  (по умолчанию) — ПРИНЯТЫЙ вариант E:
               предел из двух кусков {IR[27:24], IR[15:8]}, 12 бит,
               номер ловушки цел в IR[7:4]
           NOREBO_CHK=wide   — отвергнутый вариант C: предел IR[15:4], 12 бит,
               перекрывает номер ловушки и позицию
           NOREBO_CHK=narrow — отвергнутый вариант D: предел IR[15:8], 8 бит  */
      uint32_t lim;
      {
        static int mode = -1;
        if (mode < 0) {
          const char *m = getenv("NOREBO_CHK");
          mode = (m && !strcmp(m, "wide")) ? 1 : (m && !strcmp(m, "narrow")) ? 2 : 0;
        }
        if (mode == 1)      lim = (ir >> 4) & 0xFFF;
        else if (mode == 2) lim = (ir >> 8) & 0xFF;
        else                lim = (((ir >> 24) & 0xF) << 8) | ((ir >> 8) & 0xFF);
      }
      if (risc->R[b] >= lim) {
        risc_set_register(risc, 15, risc->PC * 4);   /* PC уже инкрементирован */
        risc->PC = risc->R[c] / 4;
      }
      return;
    }

    uint32_t a_val, b_val, c_val;
    b_val = risc->R[b];
    if ((ir & qbit) == 0) {
      c_val = risc->R[c];
    } else if ((ir & vbit) == 0) {
      c_val = im;
    } else {
      c_val = 0xFFFF0000 | im;
    }

    switch (op) {
      case MOV: {
        if ((ir & ubit) == 0) {
          a_val = c_val;
        } else if ((ir & qbit) != 0) {
          a_val = c_val << 16;
        } else if ((ir & vbit) != 0) {
          a_val = 0xD0 |   // ???
            (risc->N * 0x80000000U) |
            (risc->Z * 0x40000000U) |
            (risc->C * 0x20000000U) |
            (risc->V * 0x10000000U);
        } else {
          a_val = risc->H;
        }
        break;
      }
      case LSL: {
        a_val = b_val << (c_val & 31);
        break;
      }
      case ASR: {
        a_val = ((int32_t)b_val) >> (c_val & 31);
        break;
      }
      case ROR: {
        a_val = (b_val >> (c_val & 31)) | (b_val << (-c_val & 31));
        break;
      }
      case AND: {
        a_val = b_val & c_val;
        break;
      }
      case ANN: {
        a_val = b_val & ~c_val;
        break;
      }
      case IOR: {
        a_val = b_val | c_val;
        break;
      }
      case XOR: {
        a_val = b_val ^ c_val;
        break;
      }
      case ADD: {
        a_val = b_val + c_val;
        if ((ir & ubit) != 0) {
          a_val += risc->C;
        }
        risc->C = a_val < b_val;
        risc->V = ((a_val ^ c_val) & (a_val ^ b_val)) >> 31;
        break;
      }
      case SUB: {
        a_val = b_val - c_val;
        if ((ir & ubit) != 0) {
          a_val -= risc->C;
        }
        risc->C = a_val > b_val;
        risc->V = ((b_val ^ c_val) & (a_val ^ b_val)) >> 31;
        break;
      }
      case MUL: {
        uint64_t tmp;
        if ((ir & ubit) == 0) {
          tmp = (int64_t)(int32_t)b_val * (int64_t)(int32_t)c_val;
        } else {
          tmp = (uint64_t)b_val * (uint64_t)c_val;
        }
        a_val = (uint32_t)tmp;
        risc->H = (uint32_t)(tmp >> 32);
        break;
      }
      case DIV: {
        if ((int32_t)c_val > 0) {
          if ((ir & ubit) == 0) {
            a_val = (int32_t)b_val / (int32_t)c_val;
            risc->H = (int32_t)b_val % (int32_t)c_val;
            if ((int32_t)risc->H < 0) {
              a_val--;
              risc->H += c_val;
            }
          } else {
            a_val = b_val / c_val;
            risc->H = b_val % c_val;
          }
        } else {
          struct idiv q = idiv(b_val, c_val, ir & ubit);
          a_val = q.quot;
          risc->H = q.rem;
        }
        break;
      }
      case FAD: {
        a_val = fp_add(b_val, c_val, ir & ubit, ir & vbit);
        break;
      }
      case FSB: {
        a_val = fp_add(b_val, c_val ^ 0x80000000, ir & ubit, ir & vbit);
        break;
      }
      case FML: {
        a_val = fp_mul(b_val, c_val);
        break;
      }
      case FDV: {
        a_val = fp_div(b_val, c_val);
        break;
      }
      default: {
        abort();  // unreachable
      }
    }
    risc_set_register(risc, a, a_val);
  }
  else if ((ir & qbit) == 0) {
    // Memory instructions
    uint32_t a = (ir & 0x0F000000) >> 24;
    uint32_t b = (ir & 0x00F00000) >> 20;
    int32_t off = ir & 0x000FFFFF;
    off = (off ^ 0x00080000) - 0x00080000;  // sign-extend

    uint32_t address = risc->R[b] + off;
    if ((ir & ubit) == 0) {
      uint32_t a_val;
      if ((ir & vbit) == 0) {
        a_val = io->read_word(risc, address);
      } else {
        a_val = io->read_byte(risc, address);
      }
      risc_set_register(risc, a, a_val);
    } else {
      if ((ir & vbit) == 0) {
        io->write_word(risc, address, risc->R[a]);
      } else {
        io->write_byte(risc, address, (uint8_t)risc->R[a]);
      }
    }
  }
  else {
    // Branch instructions
    bool t = (ir >> 27) & 1;
    switch ((ir >> 24) & 7) {
      case 0: t ^= risc->N; break;
      case 1: t ^= risc->Z; break;
      case 2: t ^= risc->C; break;
      case 3: t ^= risc->V; break;
      case 4: t ^= risc->C | risc->Z; break;
      case 5: t ^= risc->N ^ risc->V; break;
      case 6: t ^= (risc->N ^ risc->V) | risc->Z; break;
      case 7: t ^= true; break;
      default: abort();  // unreachable
    }
    if (t) {
      if ((ir & vbit) != 0) {
        risc_set_register(risc, 15, risc->PC * 4);
      }
      if ((ir & ubit) == 0) {
        uint32_t c = ir & 0x0000000F;
        risc->PC = risc->R[c] / 4;
      } else {
        int32_t off = ir & 0x00FFFFFF;
        off = (off ^ 0x00800000) - 0x00800000;  // sign-extend
        risc->PC = risc->PC + off;
      }
    }
  }
}

static void risc_set_register(struct RISC *risc, int reg, uint32_t value) {
  risc->R[reg] = value;
  risc->Z = value == 0;
  risc->N = (int32_t)value < 0;
}


static uint32_t fp_add(uint32_t x, uint32_t y, bool u, bool v) {
  bool xs = (x & 0x80000000) != 0;
  uint32_t xe;
  int32_t x0;
  if (!u) {
    xe = (x >> 23) & 0xFF;
    uint32_t xm = ((x & 0x7FFFFF) << 1) | 0x1000000;
    x0 = (int32_t)(xs ? -xm : xm);
  } else {
    xe = 150;
    x0 = (int32_t)(x & 0x00FFFFFF) << 8 >> 7;
  }

  bool ys = (y & 0x80000000) != 0;
  uint32_t ye = (y >> 23) & 0xFF;
  uint32_t ym = ((y & 0x7FFFFF) << 1);
  if (!u && !v) ym |= 0x1000000;
  int32_t y0 = (int32_t)(ys ? -ym : ym);

  uint32_t e0;
  int32_t x3, y3;
  if (ye > xe) {
    uint32_t shift = ye - xe;
    e0 = ye;
    x3 = shift > 31 ? x0 >> 31 : x0 >> shift;
    y3 = y0;
  } else {
    uint32_t shift = xe - ye;
    e0 = xe;
    x3 = x0;
    y3 = shift > 31 ? y0 >> 31 : y0 >> shift;
  }

  uint32_t sum = ((xs << 26) | (xs << 25) | (x3 & 0x01FFFFFF))
    + ((ys << 26) | (ys << 25) | (y3 & 0x01FFFFFF));

  uint32_t s = (((sum & (1 << 26)) ? -sum : sum) + 1) & 0x07FFFFFF;

  uint32_t e1 = e0 + 1;
  uint32_t t3 = s >> 1;
  if ((s & 0x3FFFFFC) != 0) {
    while ((t3 & (1<<24)) == 0) {
      t3 <<= 1;
      e1--;
    }
  } else {
    t3 <<= 24;
    e1 -= 24;
  }

  if (v) {
    return (int32_t)(sum << 5) >> 6;
  } else if ((x & 0x7FFFFFFF) == 0) {
    return !u ? y : 0;
  } else if ((y & 0x7FFFFFFF) == 0) {
    return x;
  } else if ((t3 & 0x01FFFFFF) == 0 || (e1 & 0x100) != 0) {
    return 0;
  } else {
    return ((sum & 0x04000000) << 5) | (e1 << 23) | ((t3 >> 1) & 0x7FFFFF);
  }
}

static uint32_t fp_mul(uint32_t x, uint32_t y) {
  uint32_t sign = (x ^ y) & 0x80000000;
  uint32_t xe = (x >> 23) & 0xFF;
  uint32_t ye = (y >> 23) & 0xFF;

  uint32_t xm = (x & 0x7FFFFF) | 0x800000;
  uint32_t ym = (y & 0x7FFFFF) | 0x800000;
  uint64_t m = (uint64_t)xm * ym;

  uint32_t e1 = (xe + ye) - 127;
  uint32_t z0;
  if ((m & (1ULL << 47)) != 0) {
    e1++;
    z0 = ((m >> 23) + 1) & 0xFFFFFF;
  } else {
    z0 = ((m >> 22) + 1) & 0xFFFFFF;
  }

  if (xe == 0 || ye == 0) {
    return 0;
  } else if ((e1 & 0x100) == 0) {
    return sign | ((e1 & 0xFF) << 23) | (z0 >> 1);
  } else if ((e1 & 0x80) == 0) {
    return sign | (0xFF << 23) | (z0 >> 1);
  } else {
    return 0;
  }
}

static uint32_t fp_div(uint32_t x, uint32_t y) {
  uint32_t sign = (x ^ y) & 0x80000000;
  uint32_t xe = (x >> 23) & 0xFF;
  uint32_t ye = (y >> 23) & 0xFF;

  uint32_t xm = (x & 0x7FFFFF) | 0x800000;
  uint32_t ym = (y & 0x7FFFFF) | 0x800000;
  uint32_t q1 = (uint32_t)(xm * (1ULL << 25) / ym);

  uint32_t e1 = (xe - ye) + 126;
  uint32_t q2;
  if ((q1 & (1 << 25)) != 0) {
    e1++;
    q2 = (q1 >> 1) & 0xFFFFFF;
  } else {
    q2 = q1 & 0xFFFFFF;
  }
  uint32_t q3 = q2 + 1;

  if (xe == 0) {
    return 0;
  } else if (ye == 0) {
    return sign | (0xFF << 23);
  } else if ((e1 & 0x100) == 0) {
    return sign | ((e1 & 0xFF) << 23) | (q3 >> 1);
  } else if ((e1 & 0x80) == 0) {
    return sign | (0xFF << 23) | (q2 >> 1);
  } else {
    return 0;
  }
}

static struct idiv idiv(uint32_t x, uint32_t y, bool signed_div) {
  bool sign = ((int32_t)x < 0) & signed_div;
  uint32_t x0 = sign ? -x : x;

  uint64_t RQ = x0;
  for (int S = 0; S < 32; ++S) {
    uint32_t w0 = (uint32_t)(RQ >> 31);
    uint32_t w1 = w0 - y;
    if ((int32_t)w1 < 0) {
      RQ = ((uint64_t)w0 << 32) | ((RQ & 0x7FFFFFFFU) << 1);
    } else {
      RQ = ((uint64_t)w1 << 32) | ((RQ & 0x7FFFFFFFU) << 1) | 1;
    }
  }

  struct idiv d = { (uint32_t)RQ, (uint32_t)(RQ >> 32) };
  if (sign) {
    d.quot = -d.quot;
    if (d.rem) {
      d.quot -= 1;
      d.rem = y - d.rem;
    }
  }
  return d;
}
