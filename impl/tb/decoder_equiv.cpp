// Проверка эквивалентности декодера: базовое ядро против ядра с расширением ISA.
//
// Требование ревью: для ВСЕХ комбинаций {IR[31:28] × op} со случайными операндами
// старое и новое ядро обязаны совпадать побитово, кроме новых кодировок.
// Это ловит целый класс ошибок: в RISC5 НЕТ ловушки на неизвестную инструкцию,
// поэтому занятие чужой кодировки проявилось бы не диагностикой, а молчаливым
// изменением поведения существующего кода.
//
// Программа выводит машиночитаемую таблицу; сравнение делает tools/cmp_decoder.py.
#include "VRISC5.h"
#include "VRISC5___024root.h"
#include "VRISC5_RISC5.h"
#include "VRISC5_Registers.h"
#include "soc_mem.h"
#include <cstdio>
#include <cstdint>

static const uint32_t ORG = 0x00FFE000;

struct Probe {
    VRISC5* top; Mem mem;
    Probe() { top = new VRISC5; }
    ~Probe() { top->final(); delete top; }
    bool stall() const { return top->rootp->RISC5->stall; }
    uint32_t reg(int i) const { return top->rootp->RISC5->regs->R[i]; }
    void reset() {
        top->rst = 0; top->irq = 0; top->stallX = 0; top->inbus = 0; top->codebus = 0;
        for (int i = 0; i < 4; i++) { top->clk = 0; top->eval(); top->clk = 1; top->eval(); }
        top->rst = 1; top->clk = 0; top->eval();
    }
    int step() {
        int n = 0;
        for (;;) {
            top->clk = 0; top->eval();
            uint32_t a = top->adr, d = mem.read(a);
            top->inbus = d; top->codebus = d; top->eval();
            bool ret = !stall();
            if (top->wr) mem.write(a, top->outbus, top->ben);
            top->clk = 1; top->eval();
            n++;
            if (ret) return n;
            if (n > 200) return -1;
        }
    }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    // Несколько наборов операндов: нули, единицы, знаковые, «плавающие» образцы
    const uint32_t opnd[][2] = {
        {0x00000000, 0x00000000}, {0x00001234, 0x00005678},
        {0xFFFFFFFF, 0x00000001}, {0x80000000, 0x7FFFFFFF},
        {0x3F800000, 0x40000000},                      // 1.0 и 2.0 в плавающем
    };
    // ⚠ Прежняя подпись состояла из R5, R6, флагов, тактов и памяти, а поле a
    // было намертво равно 5. Отсюда две дыры: порча BL не видна (ни R15, ни PC
    // в подписи не было), и из 16 условий перехода проверялось ровно одно —
    // поле a у формата F3 и есть условие. Теперь подпись покрывает ВСЕ
    // регистры, флаги, PC и H, а поле a перебирается целиком.
    printf("# nib op a.set  regcrc flags pc H cycles memcrc\n");
    for (int nib = 0; nib < 16; nib++)
      for (int op = 0; op < 16; op++)
       for (int af = 0; af < 16; af++)
        for (int si = 0; si < 5; si++) {
            Probe p;
            p.mem.w.assign(Mem::WORDS, 0);
            // пролог: R1, R2 = операнды; R5, R6 = 0 (цели)
            uint32_t prog[8];
            int k = 0;
            // MHI = F1 с u=1 (нибл 0110) и ЗАМЕЩАЕТ регистр значением imm<<16,
            // поэтому младшая половина доставляется отдельным IOR — как делает
            // сам компилятор Оберона (ORG.Put1a).
            prog[k++] = 0x61000000 | ((opnd[si][0] >> 16) & 0xFFFF);   // MHI R1, high
            prog[k++] = 0x41160000 | (opnd[si][0] & 0xFFFF);           // IOR R1, R1, low
            prog[k++] = 0x62000000 | ((opnd[si][1] >> 16) & 0xFFFF);   // MHI R2, high
            prog[k++] = 0x42260000 | (opnd[si][1] & 0xFFFF);           // IOR R2, R2, low
            prog[k++] = 0x45000000;                                     // MOV R5, 0
            prog[k++] = 0x46000000;                                     // MOV R6, 0
            p.mem.load_words(ORG, prog, k);
            // испытуемая инструкция: a=5, b=1, c=2
            uint32_t insn = ((uint32_t)nib << 28) | ((uint32_t)af << 24) | (1u << 20)
                          | ((uint32_t)op << 16) | 2u;
            p.mem.load_words(ORG + k * 4, &insn, 1);
            p.reset();
            for (int i = 0; i < k; i++) p.step();
            int cyc = p.step();
            auto* R = p.top->rootp->RISC5;
            uint32_t fl = (R->N << 3) | (R->Z << 2) | (R->C << 1) | R->OV;
            // все 16 регистров, включая R15: BL пишет туда адрес возврата
            uint32_t rcrc = 0;
            for (int r = 0; r < 16; r++) rcrc = rcrc * 31 + p.reg(r);
            // контрольная сумма изменённой памяти (ловит сохранения)
            uint32_t crc = 0;
            for (uint32_t i = 0; i < 4096; i++) crc = crc * 31 + p.mem.w[i];
            printf("%X %X %X.%d  %08X %X %06X %08X %d %08X\n",
                   nib, op, af, si, rcrc, fl, R->PC * 4, R->H, cyc, crc);
        }
    return 0;
}
