// SoC-стенд: настоящее ядро RISC5 на RTL плюс память, ПЗУ и устройства из C++.
//
// Почему так, а не полная схема из RISC5Top.v: у RTL проводные интерфейсы
// (пиксельный поток VGA, битовый PS/2, битовый SPI с автоматом SD-карты), и их
// эмуляция — несколько дней работы с осциллограммами, которые ничего не добавляют
// к предмету исследования. Ядро — вот оно, настоящее; периферия подменена
// заглушками с ТЕМ ЖЕ регистровым интерфейсом к шине (адреса те же).
// Логика SD-карты взята из эталонного эмулятора (tb/disk/disk.c) — она словная,
// а не битовая, и ложится на регистры напрямую.
#include "VRISC5.h"
#include "VRISC5___024root.h"
#include "VRISC5_RISC5.h"
#include "VRISC5_Registers.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <string>
// disk.c собирается Verilator'ом как C++, поэтому extern "C" не нужен —
// иначе объявления и определения разойдутся по манглингу.
#include "disk/risc-io.h"
#include "disk/disk.h"
#include "memdisk.h"
#include "scenario.h"
#include "cycle_model.h"

static const uint32_t MEM_WORDS   = 1 << 18;        // 1 МБ
static const uint32_t ROM_BASE    = 0x00FFC000;     // окно ПЗУ на шине КОДА
static const uint32_t IO_BASE     = 0x00FFFFC0;     // верхние 64 байта
static const uint32_t DISPLAY_ORG = 0x000E7F00;     // кадровый буфер

struct SoC {
    VRISC5* top;
    std::vector<uint32_t> ram;
    std::vector<uint32_t> rom;
    const struct RISC_SPI* spi = nullptr;
    MemDisk* mdisk = nullptr;          // альтернативный диск в памяти
    uint32_t spi_selected = 0;
    uint64_t cycles = 0, insns = 0;
    uint64_t model_cycles = 0, model_fails = 0;   // сверка модели тактов с RTL
    CycleModel model;
    uint32_t ms = 0;                // миллисекундный счётчик
    uint32_t leds = 0;
    // ── ввод ────────────────────────────────────────────────────────────
    // Формат регистра мыши берётся из Input.Mod:
    //   keys = w DIV 1000000H MOD 8   -> биты 24..26
    //   x = w MOD 1000H, y = (w DIV 1000H) MOD 1000H
    // В множестве keys: элемент 2 (бит 26) — левая, 1 (бит 25) — средняя,
    // 0 (бит 24) — правая. Готовность клавиатуры — бит 28 того же слова.
    uint32_t mouse_reg = 0;
    uint8_t  kbd[1024]; int kbd_head = 0, kbd_tail = 0;   // длинные командные строки

    void set_mouse(int x, int y, int keys) {
        if (x < 0) x = 0; if (x > 1023) x = 1023;
        if (y < 0) y = 0; if (y > 767) y = 767;
        mouse_reg = ((uint32_t)keys & 7) << 24
                  | ((uint32_t)y & 0xFFF) << 12 | ((uint32_t)x & 0xFFF);
    }
    void push_key(uint8_t code) {
        int n = (kbd_head + 1) & 1023;
        if (n != kbd_tail) { kbd[kbd_head] = code; kbd_head = n; }
    }

    SoC() : ram(MEM_WORDS, 0), rom(512, 0) { top = new VRISC5; }
    ~SoC() { top->final(); delete top; }

    bool     stall() const { return top->rootp->RISC5->stall; }
    uint32_t pc()    const { return top->rootp->RISC5->PC; }
    uint32_t ir()    const { return top->rootp->RISC5->IR; }
    uint32_t reg(int i) const { return top->rootp->RISC5->regs->R[i]; }

    bool load_prom(const char* path) {
        FILE* f = fopen(path, "r");
        if (!f) return false;
        char line[64]; size_t i = 0;
        while (i < rom.size() && fgets(line, sizeof line, f))
            rom[i++] = (uint32_t)strtoul(line, nullptr, 16);
        fclose(f);
        printf("  ПЗУ: %zu слов из %s\n", i, path);
        return i > 0;
    }

    // Шина КОДА: окно ПЗУ или ОЗУ (RISC5Top.v:84)
    uint32_t read_code(uint32_t a) {
        if ((a >> 14) == (ROM_BASE >> 14)) return rom[(a >> 2) & 511];
        return ram[(a >> 2) & (MEM_WORDS - 1)];
    }
    // Шина ДАННЫХ: ОЗУ или регистры устройств. ПЗУ на шине данных НЕДОСТУПНО.
    uint32_t read_data(uint32_t a) {
        if ((a & 0xFFFFC0u) == (IO_BASE & 0xFFFFC0u) && (a >> 6) == (IO_BASE >> 6))
            return read_io((a >> 2) & 15);
        return ram[(a >> 2) & (MEM_WORDS - 1)];
    }
    void write_data(uint32_t a, uint32_t v, bool ben) {
        if ((a >> 6) == (IO_BASE >> 6)) { write_io((a >> 2) & 15, v); return; }
        uint32_t i = (a >> 2) & (MEM_WORDS - 1);
        if (!ben) { ram[i] = v; return; }
        uint32_t mask = 0xFFu << ((a & 3) * 8);
        ram[i] = (ram[i] & ~mask) | (v & mask);
    }
    uint32_t read_io(uint32_t w) {
        switch (w) {
            case 0: return ms;                       // миллисекунды
            case 1: return 0;                        // кнопки и переключатели
            case 2: return 0;                        // RS-232 данные
            case 3: return 2;                        // RS-232: передатчик готов
            case 4: return mdisk ? mdisk->read() : (spi ? spi->read_data(spi) : 0xFFFFFFFFu);
            case 5: return 1;                        // SPI готов всегда
            case 6: return mouse_reg | (kbd_head != kbd_tail ? 0x10000000u : 0u);
            case 7: {
                if (kbd_head == kbd_tail) return 0;
                uint8_t c = kbd[kbd_tail]; kbd_tail = (kbd_tail + 1) & 1023; return c;
            }
            default: return 0;
        }
    }
    void write_io(uint32_t w, uint32_t v) {
        switch (w) {
            case 1: leds = v & 0xFF; break;
            case 4: if (mdisk) mdisk->write(v); else if (spi) spi->write_data(spi, v); break;
            case 5: spi_selected = v & 3; break;
            default: break;
        }
    }
    void reset() {
        // Во время сброса шину тоже надо обслуживать из памяти: регистр команд
        // защёлкивается каждый такт (RISC5.v:173 IR <= stall ? IR : codebus),
        // и если подавать нули, первая же инструкция выполнится как MOV R0,R0
        // вместо перехода из загрузчика. Ровно на этом я и споткнулся.
        top->rst = 0; top->irq = 0; top->stallX = 0;
        for (int i = 0; i < 4; i++) {
            top->clk = 0; top->eval();
            top->codebus = read_code(top->adr); top->inbus = read_data(top->adr);
            top->eval();
            top->clk = 1; top->eval();
        }
        top->rst = 1;
        top->clk = 0; top->eval();
        top->codebus = read_code(top->adr); top->inbus = read_data(top->adr);
        top->eval();
    }
    // Шаг до завершения инструкции. Возвращает число тактов.
    int step() {
        int n = 0;
        // Модель тактов (tb/cycle_model.h) раньше сверялась только на 61 инструкции
        // синтетических тестов. Здесь она сверяется с RTL на РЕАЛЬНОЙ нагрузке —
        // загрузке системы, то есть на коде, который писал Вирт.
        // ⚠ Читать по top->adr ЗДЕСЬ нельзя: шина установится только после
        // clk=0 + eval(). До этого там адрес прошлого такта. Берём PC напрямую,
        // как это делает tb/run_tests.cpp, где модель сходилась с нулём расхождений.
        uint32_t insn_for_model = read_code(top->rootp->RISC5->PC * 4);
        int predicted = model.cycles(insn_for_model);
        for (;;) {
            top->clk = 0; top->eval();
            uint32_t a = top->adr;
            // Одна шина адреса: во время stallL0 это данные, иначе следующий PC.
            top->codebus = read_code(a);
            top->inbus   = read_data(a);
            top->eval();
            bool ret = !stall();
            if (top->wr) write_data(a, top->outbus, top->ben);
            top->clk = 1; top->eval();
            cycles++; n++;
            if ((cycles % 25000) == 0) ms++;          // 25 МГц -> 1 кГц
            if (ret) {
                insns++;
                model_cycles += predicted;
                if (predicted != n) model_fails++;
                return n;
            }
            if (n > 400) return -1;
        }
    }
    // Контрольная сумма кадрового буфера — признак, что система рисует
    uint32_t fb_crc() const {
        uint32_t c = 0;
        for (uint32_t i = 0; i < 1024 * 768 / 32; i++)
            c = c * 31 + ram[(DISPLAY_ORG >> 2) + i];
        return c;
    }
};

// Сценарий ввода: строки вида «<инструкция> <действие> <аргументы>».
//   M x y keys   — поставить мышь (keys: 4 левая, 2 средняя, 1 правая, 0 отпущено)
//   K code       — послать скан-код PS/2
//   S file       — выгрузить экран в файл
// Экран этой машины для переносимого каркаса (tb/scenario.h).
// Единственное, что здесь специфично: где лежит кадровый буфер, какого он
// размера и то, что строки хранятся СНИЗУ ВВЕРХ (VID.v: vidadr = Org +
// {3'b0, ~vcnt, hword}) — наивная выкладка даёт перевёрнутый экран.
static harness::Screen soc_screen(SoC& s) {
    return { &s.ram[DISPLAY_ORG >> 2], 1024, 768, /*bottom_up=*/true };
}

static void dump_screen(SoC& s, const char* path) {
    if (harness::dump_pbm(soc_screen(s), path))
        printf("  экран выгружен: %s\n", path);
}

// Адаптер машины: три действия, больше переносимому каркасу ничего не нужно.
struct SoCHost : harness::Host {
    SoC& s;
    explicit SoCHost(SoC& m) : s(m) {}
    void set_mouse(int x, int y, int keys) override { s.set_mouse(x, y, keys); }
    void push_key(uint8_t code) override { s.push_key(code); }
    harness::Screen screen() override { return soc_screen(s); }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    SoC s;
    std::string prom = "rtl/prom.mem", dsk = "ext/disk/Oberon-2016-08-02.dsk";
    uint64_t maxi = 50000000; int trace = 0;
    uint32_t expect_crc = 0;      // если задана — сверяем и возвращаем код ошибки
    std::string script_path;
    // ⚠ Найдено при работе над самораскруткой: эмулятор диска открывает образ
    // как "rb+" и пишет в него настоящие сектора. Раньше стенд по умолчанию
    // брал ЭТАЛОННЫЙ образ из ext/ — то есть каждая загрузка системы молча
    // правила источник истины. Теперь по умолчанию работаем на копии в build/,
    // а писать в указанный файл разрешает только явный --persist.
    bool persist = false;
    for (int i = 1; i < argc; i++) {
        std::string a = argv[i];
        if (a.rfind("--prom=", 0) == 0) prom = a.substr(7);
        else if (a.rfind("--disk=", 0) == 0) dsk = a.substr(7);
        else if (a.rfind("--max=", 0) == 0) maxi = strtoull(a.c_str() + 6, nullptr, 10);
        else if (a.rfind("--trace=", 0) == 0) trace = atoi(a.c_str() + 8);
        else if (a.rfind("--expect-crc=", 0) == 0)
            expect_crc = (uint32_t)strtoul(a.c_str() + 13, nullptr, 16);
        else if (a.rfind("--script=", 0) == 0) script_path = a.substr(9);
        else if (a == "--persist") persist = true;
        else if (a == "--memdisk") { /* см. ниже */ }
    }
    if (!s.load_prom(prom.c_str())) { fprintf(stderr, "нет ПЗУ %s\n", prom.c_str()); return 1; }
    bool use_mem = false;
    for (int i = 1; i < argc; i++) if (std::string(argv[i]) == "--memdisk") use_mem = true;
    if (use_mem) {
        FILE* f = fopen(dsk.c_str(), "rb");
        if (!f) { fprintf(stderr, "нет образа %s\n", dsk.c_str()); return 1; }
        fseek(f, 0, SEEK_END); long n = ftell(f); fseek(f, 0, SEEK_SET);
        std::vector<uint8_t> buf(n); fread(buf.data(), 1, n, f); fclose(f);
        s.mdisk = new MemDisk(); s.mdisk->init(buf.data(), buf.size());
        printf("  диск в памяти: %ld байт\n", n);
    } else {
        if (!persist) {
            std::string base = dsk.substr(dsk.find_last_of('/') + 1);
            std::string work = "build/" + base + ".work";
            FILE* in = fopen(dsk.c_str(), "rb");
            if (!in) { fprintf(stderr, "нет образа %s\n", dsk.c_str()); return 1; }
            FILE* out = fopen(work.c_str(), "wb");
            if (!out) { fprintf(stderr, "не создать %s\n", work.c_str()); return 1; }
            char buf[65536]; size_t n;
            while ((n = fread(buf, 1, sizeof buf, in)) > 0) fwrite(buf, 1, n, out);
            fclose(in); fclose(out);
            dsk = work;
        }
        s.spi = disk_new(dsk.c_str());
        if (!s.spi) { fprintf(stderr, "нет образа диска %s\n", dsk.c_str()); return 1; }
    }
    printf("  диск: %s\n", dsk.c_str());

    s.reset();
    printf("  PC после сброса: %06X (ожидается FFE000)\n\n", s.pc() * 4);

    harness::Player player;
    SoCHost host(s);
    player.load(script_path);

    uint32_t last_crc = 0; uint64_t first_draw = 0;
    for (uint64_t k = 0; k < maxi; k++) {
        player.advance(k, host);
        uint32_t before = s.pc();
        if (trace && (int)k < trace)
            printf("    [%6llu] PC=%06X IR=%08X\n", (unsigned long long)k, before * 4, s.read_code(before * 4));
        int n = s.step();
        if (n < 0) { printf("  ЗАВИС на PC=%06X IR=%08X\n", before * 4, s.ir()); break; }
        if (!first_draw && (k & 0xFFFF) == 0) {
            uint32_t c = s.fb_crc();
            if (c != last_crc && k > 0) { first_draw = k; }
            last_crc = c;
        }
        if (s.pc() == before && n == 1) { printf("  ОСТАНОВ (переход на себя) на PC=%06X\n", before * 4); break; }
    }
    printf("\n  инструкций %llu, тактов %llu\n",
           (unsigned long long)s.insns, (unsigned long long)s.cycles);
    printf("  модель тактов: предсказано %llu, расхождений %llu (%.4f%%)  %s\n",
           (unsigned long long)s.model_cycles, (unsigned long long)s.model_fails,
           s.insns ? 100.0 * s.model_fails / s.insns : 0.0,
           s.model_fails ? "❌" : "✅");
    if (s.model_cycles != s.cycles)
        printf("  ⚠ суммарно модель %llu против RTL %llu: расхождение %+lld тактов (%+.4f%%)\n",
               (unsigned long long)s.model_cycles, (unsigned long long)s.cycles,
               (long long)s.model_cycles - (long long)s.cycles,
               100.0 * ((double)s.model_cycles - (double)s.cycles) / (double)s.cycles);
    printf("  PC=%06X  контрольная сумма кадрового буфера %08X\n", s.pc() * 4, s.fb_crc());
    // Выгрузка кадрового буфера в PBM. ВАЖНО: строки хранятся СНИЗУ ВВЕРХ
    // (VID.v: vidadr = Org + {3'b0, ~vcnt, hword}), наивная выкладка даёт
    // перевёрнутый экран.
    dump_screen(s, "build/screen.pbm");
    if (first_draw) printf("  первая запись в кадровый буфер около инструкции %llu\n",
                           (unsigned long long)first_draw);

    // ⚠ Найдено аудитом: раньше контрольная сумма печаталась и ни с чем не
    // сравнивалась, а программа всегда возвращала 0. Машина, застрявшая в ПЗУ
    // с пустым экраном, рапортовала успех.
    if (expect_crc) {
        uint32_t got = s.fb_crc();
        if (got != expect_crc) {
            printf("\n  ❌ ЭКРАН НЕ СОВПАЛ: %08X, ожидалось %08X\n", got, expect_crc);
            return 1;
        }
        printf("  ✅ экран совпал с эталоном (%08X)\n", got);
        if (s.model_fails) { printf("  ❌ модель тактов разошлась\n"); return 1; }
    }
    return 0;
}
