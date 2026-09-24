// Точка входа для браузера: ядро RISC5 на настоящем RTL, скомпилированное
// Verilator -> C++ -> Emscripten -> WASM. Периферия — регистровые заглушки,
// диск в памяти (образ приходит из JS).
#include "VRISC5.h"
#include "VRISC5___024root.h"
#include "VRISC5_RISC5.h"
#include "VRISC5_Registers.h"
#include "memdisk.h"
#include <emscripten.h>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <vector>

static const uint32_t MEM_WORDS   = 1 << 18;
static const uint32_t ROM_BASE    = 0x00FFC000;
static const uint32_t IO_BASE     = 0x00FFFFC0;
static const uint32_t DISPLAY_ORG = 0x000E7F00;
static const uint32_t FB_WORDS    = 1024 * 768 / 32;

static VRISC5* top = nullptr;
static std::vector<uint32_t> ram;
static uint32_t rom[512];
static MemDisk disk;
static uint32_t ms = 0;
static uint64_t g_cycles = 0, g_insns = 0;
// Ввод
static uint32_t mouse_reg = 0;            // X | Y<<12 | кнопки в 26/25/24
static uint8_t  kbd_buf[64]; static int kbd_head = 0, kbd_tail = 0;

static inline uint32_t read_code(uint32_t a) {
    if ((a >> 14) == (ROM_BASE >> 14)) return rom[(a >> 2) & 511];
    return ram[(a >> 2) & (MEM_WORDS - 1)];
}
static inline uint32_t read_data(uint32_t a) {
    if ((a >> 6) == (IO_BASE >> 6)) {
        switch ((a >> 2) & 15) {
            case 0: return ms;
            case 3: return 0;
            case 4: return disk.read();
            case 5: return 1;
            case 6: return mouse_reg | (kbd_head != kbd_tail ? 0x10000000u : 0u);
            case 7: {
                if (kbd_head == kbd_tail) return 0;
                uint8_t c = kbd_buf[kbd_tail]; kbd_tail = (kbd_tail + 1) & 63; return c;
            }
            default: return 0;
        }
    }
    return ram[(a >> 2) & (MEM_WORDS - 1)];
}
static inline void write_data(uint32_t a, uint32_t v, bool ben) {
    if ((a >> 6) == (IO_BASE >> 6)) { if (((a >> 2) & 15) == 4) disk.write(v); return; }
    uint32_t i = (a >> 2) & (MEM_WORDS - 1);
    if (!ben) { ram[i] = v; return; }
    uint32_t m = 0xFFu << ((a & 3) * 8);
    ram[i] = (ram[i] & ~m) | (v & m);
}

extern "C" {

EMSCRIPTEN_KEEPALIVE
void soc_init(const uint8_t* prom_words, int prom_n, const uint8_t* img, int img_len) {
    if (!top) top = new VRISC5;
    ram.assign(MEM_WORDS, 0);
    memset(rom, 0, sizeof rom);
    const uint32_t* pw = (const uint32_t*)prom_words;
    for (int i = 0; i < prom_n && i < 512; i++) rom[i] = pw[i];
    disk.init(img, (size_t)img_len);
    ms = 0; g_cycles = g_insns = 0;
    kbd_head = kbd_tail = 0; mouse_reg = 0;

    // ⚠ Прямое следствие находки 19: в RISC5.v НЕТ сброса у регистрового файла,
    // флагов, H и IR. При первом создании модели Verilator обнуляет их сам, а при
    // повторном пуске (кнопка «Откатить» в лабораторной) там остаётся грязь от
    // прошлого прогона, и система не загружается — экран остаётся пустым.
    // Здесь состояние обнуляется явно. На настоящей ПЛИС этого сброса не будет.
    {
        auto* R = top->rootp->RISC5;
        for (int i = 0; i < 16; i++) R->regs->R[i] = 0;
        R->N = R->Z = R->C = R->OV = 0;
        R->H = 0; R->IR = 0; R->SPC = 0;
        R->intEnb = 0; R->intMd = 0;
    }
    top->rst = 0; top->irq = 0; top->stallX = 0;
    for (int i = 0; i < 4; i++) {
        top->clk = 0; top->eval();
        top->codebus = read_code(top->adr); top->inbus = read_data(top->adr); top->eval();
        top->clk = 1; top->eval();
    }
    top->rst = 1; top->clk = 0; top->eval();
    top->codebus = read_code(top->adr); top->inbus = read_data(top->adr); top->eval();
}

// Отработать не более n инструкций. Возвращает, сколько выполнено.
EMSCRIPTEN_KEEPALIVE
int soc_run(int n) {
    int done = 0;
    for (int k = 0; k < n; k++) {
        int guard = 0;
        for (;;) {
            top->clk = 0; top->eval();
            uint32_t a = top->adr;
            top->codebus = read_code(a); top->inbus = read_data(a); top->eval();
            bool ret = !top->rootp->RISC5->stall;
            if (top->wr) write_data(a, top->outbus, top->ben);
            top->clk = 1; top->eval();
            g_cycles++;
            if ((g_cycles % 25000) == 0) ms++;
            if (ret) { g_insns++; done++; break; }
            if (++guard > 400) return done;
        }
    }
    return done;
}

EMSCRIPTEN_KEEPALIVE uint32_t* soc_framebuffer() { return &ram[DISPLAY_ORG >> 2]; }
EMSCRIPTEN_KEEPALIVE int soc_fb_words() { return (int)FB_WORDS; }
EMSCRIPTEN_KEEPALIVE double soc_cycles() { return (double)g_cycles; }
EMSCRIPTEN_KEEPALIVE double soc_insns()  { return (double)g_insns; }
EMSCRIPTEN_KEEPALIVE uint32_t soc_pc()   { return top->rootp->RISC5->PC * 4; }

/* ── доступ к состоянию машины для лабораторных ──────────────────────────────
   Лаборатория без проверки — это демонстрация, а не задание. Чтобы проверка
   была настоящей, ей нужно видеть то же, что видит отладчик: регистры, флаги,
   память и содержимое диска. Всё только на чтение. */
EMSCRIPTEN_KEEPALIVE uint32_t soc_reg(int i) {
    return top->rootp->RISC5->regs->R[i & 15];
}
EMSCRIPTEN_KEEPALIVE uint32_t soc_flags() {
    auto* R = top->rootp->RISC5;
    return ((uint32_t)R->N << 3) | ((uint32_t)R->Z << 2)
         | ((uint32_t)R->C << 1) | (uint32_t)R->OV;
}
EMSCRIPTEN_KEEPALIVE uint32_t soc_h() { return top->rootp->RISC5->H; }

EMSCRIPTEN_KEEPALIVE uint32_t soc_ram(uint32_t adr) {
    return ram[(adr >> 2) & (MEM_WORDS - 1)];
}

/* Контрольная сумма кадрового буфера: тот же полином, что в нативном стенде,
   чтобы числа в лабораторной и в make boot совпадали. */
EMSCRIPTEN_KEEPALIVE uint32_t soc_fb_crc() {
    uint32_t c = 0;
    for (uint32_t i = 0; i < FB_WORDS; i++) c = c * 31 + ram[(DISPLAY_ORG >> 2) + i];
    return c;
}

/* Диск лежит в памяти (memdisk), поэтому лаборатория может проверить, что
   файл на образе действительно изменился, — а не верить надписи на экране. */
EMSCRIPTEN_KEEPALIVE uint32_t soc_disk_word(uint32_t byteoff) {
    return disk.word(byteoff);
}
EMSCRIPTEN_KEEPALIVE uint32_t soc_disk_size() { return disk.size(); }

/* Запись в ОЗУ снаружи. Нужна уровню «ломать»: в этой машине нет ни защиты
   памяти, ни разделения привилегий, и самый честный способ это показать —
   дать испортить любое слово и посмотреть, что станет с системой. */
EMSCRIPTEN_KEEPALIVE void soc_poke(uint32_t adr, uint32_t val) {
    ram[(adr >> 2) & (MEM_WORDS - 1)] = val;
}

EMSCRIPTEN_KEEPALIVE void soc_key(int scancode) {
    int n = (kbd_head + 1) & 63;
    if (n != kbd_tail) { kbd_buf[kbd_head] = (uint8_t)scancode; kbd_head = n; }
}
// Кнопки мыши -- биты 26/25/24 (левая/средняя/правая), координаты в младших полях
EMSCRIPTEN_KEEPALIVE void soc_mouse(int x, int y, int buttons) {
    if (x < 0) x = 0; if (x > 1023) x = 1023;
    if (y < 0) y = 0; if (y > 767) y = 767;
    mouse_reg = ((uint32_t)buttons & 7) << 24 | ((uint32_t)y & 0xFFF) << 12 | ((uint32_t)x & 0xFFF);
}

}  // extern "C"
