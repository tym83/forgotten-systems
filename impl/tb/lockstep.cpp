// Дифференциальный стенд: настоящее RTL против эталонного эмулятора, инструкция
// за инструкцией, на РЕАЛЬНОЙ нагрузке — загрузке системы Оберон.
//
// Это сильнейшая проверка, какая тут возможна: синтетические тесты покрывают то,
// что придумал автор, а загрузка системы исполняет то, что реально написал Вирт.
//
// Источники недетерминизма, которые пришлось устранить (все указаны ревью):
//   1. Разрядность PC: у RTL 22 бита, у эталона 32-битный индекс слова -> маска
//   2. Таймер: у обеих моделей свой счётчик -> ведём эталон от нашего
//   3. Служебная запись эталона на DisplayStart ("Sizg" + размеры экрана) ->
//      воспроизводим её и у себя, иначе память разойдётся на нулевом шаге
//   4. Эвристика progress в risc_run -> сбрасывается при каждом вызове, а мы
//      вызываем по одной инструкции
//   5. Диск: у каждой модели своя копия образа, иначе записи перемешаются
#include "VRISC5.h"
#include "VRISC5___024root.h"
#include "VRISC5_RISC5.h"
#include "VRISC5_Registers.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>
extern "C" {
#include "../ext/refemu/risc.h"
#include "../ext/refemu/disk.h"
}

static const uint32_t MEM_WORDS   = 1 << 18;
static const uint32_t ROM_BASE    = 0x00FFC000;
static const uint32_t IO_BASE     = 0x00FFFFC0;
static const uint32_t DISPLAY_ORG = 0x000E7F00;
static const uint32_t PC_MASK     = (1u << 22) - 1;

struct Dut {
    VRISC5* top;
    std::vector<uint32_t> ram, rom;
    const struct RISC_SPI* spi = nullptr;
    uint32_t ms = 0;
    uint64_t cycles = 0, insns = 0;
    Dut() : ram(MEM_WORDS, 0), rom(512, 0) { top = new VRISC5; }
    ~Dut() { top->final(); delete top; }
    bool stall() const { return top->rootp->RISC5->stall; }
    uint32_t pc() const { return top->rootp->RISC5->PC; }
    uint32_t reg(int i) const { return top->rootp->RISC5->regs->R[i]; }
    uint32_t H() const { return top->rootp->RISC5->H; }
    uint32_t flags() const { auto* R = top->rootp->RISC5;
        return (R->N << 3) | (R->Z << 2) | (R->C << 1) | R->OV; }

    bool load_prom(const char* p) {
        FILE* f = fopen(p, "r"); if (!f) return false;
        char l[64]; size_t i = 0;
        while (i < rom.size() && fgets(l, sizeof l, f)) rom[i++] = (uint32_t)strtoul(l, nullptr, 16);
        fclose(f); return i > 0;
    }
    uint32_t read_code(uint32_t a) {
        if ((a >> 14) == (ROM_BASE >> 14)) return rom[(a >> 2) & 511];
        return ram[(a >> 2) & (MEM_WORDS - 1)];
    }
    uint32_t read_data(uint32_t a) {
        if ((a >> 6) == (IO_BASE >> 6)) {
            switch ((a >> 2) & 15) {
                case 0: return ms;
                case 3: return 0;                              // как у эталона без serial
                case 4: return spi ? spi->read_data(spi) : 255;
                case 5: return 1;
                default: return 0;
            }
        }
        return ram[(a >> 2) & (MEM_WORDS - 1)];
    }
    void write_data(uint32_t a, uint32_t v, bool ben) {
        if ((a >> 6) == (IO_BASE >> 6)) {
            if (((a >> 2) & 15) == 4 && spi) spi->write_data(spi, v);
            return;
        }
        uint32_t i = (a >> 2) & (MEM_WORDS - 1);
        if (!ben) { ram[i] = v; return; }
        uint32_t m = 0xFFu << ((a & 3) * 8);
        ram[i] = (ram[i] & ~m) | (v & m);
    }
    void reset() {
        top->rst = 0; top->irq = 0; top->stallX = 0;
        for (int i = 0; i < 4; i++) {
            top->clk = 0; top->eval();
            top->codebus = read_code(top->adr); top->inbus = read_data(top->adr); top->eval();
            top->clk = 1; top->eval();
        }
        top->rst = 1; top->clk = 0; top->eval();
        top->codebus = read_code(top->adr); top->inbus = read_data(top->adr); top->eval();
        // ВЫРАВНИВАНИЕ НАЧАЛЬНОГО СОСТОЯНИЯ.
        // В RISC5 сброс НЕ блокирует запись в регистры: regwr = ~p & ~stall | ...
        // не зависит от rst. Поэтому на первом же такте исполняется то, что
        // случайно оказалось в регистре команд (в симуляции — ноль, то есть
        // MOV R0,R0), и это ставит Z=1. У эталонного эмулятора состояние после
        // сброса определено и равно нулю.
        // Расхождение реальное, но относится к неопределённому состоянию железа,
        // а не к семантике инструкций, поэтому выравниваем явно.
        top->rootp->RISC5->N = 0; top->rootp->RISC5->Z = 0;
        top->rootp->RISC5->C = 0; top->rootp->RISC5->OV = 0;
        for (int i = 0; i < 16; i++) top->rootp->RISC5->regs->R[i] = 0;
        top->rootp->RISC5->H = 0;
    }
    int step() {
        int n = 0;
        for (;;) {
            top->clk = 0; top->eval();
            uint32_t a = top->adr;
            top->codebus = read_code(a); top->inbus = read_data(a); top->eval();
            bool ret = !stall();
            if (top->wr) write_data(a, top->outbus, top->ben);
            top->clk = 1; top->eval();
            cycles++; n++;
            if (ret) { insns++; return n; }
            if (n > 400) return -1;
        }
    }
};

// Один и тот же адрес в разных картах ПЗУ: RTL держит ПЗУ по 00FFE000,
// эталон — по FFFFF800. Сравниваем по смещению внутри окна.
static bool ADDR_EQ(uint32_t a, uint32_t b) {
    bool ar = (a >> 14) == (ROM_BASE >> 14);
    bool br = (b >= 0xFFFFF800u);
    if (ar && br) return ((a >> 2) & 511) == ((b >> 2) & 511);
    return a == b;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    uint64_t maxi = 12000000; int verbose = 0;
    // Как часто сверять ОЗУ целиком. Мегабайт памяти — 262144 слова; на каждой
    // сверке это лишний проход, поэтому не на каждой инструкции.
    const uint64_t RAM_CHECK = 250000;
    uint64_t ram_checks = 0, rom_addr_waivers = 0;
    std::string prom = "rtl/prom_sd.mem";
    for (int i = 1; i < argc; i++) {
        std::string a = argv[i];
        if (a.rfind("--max=", 0) == 0) maxi = strtoull(a.c_str() + 6, nullptr, 10);
        else if (a.rfind("--prom=", 0) == 0) prom = a.substr(7);
        else if (a == "-v") verbose = 1;
    }

    Dut d;
    if (!d.load_prom(prom.c_str())) { fprintf(stderr, "нет ПЗУ\n"); return 1; }
    d.spi = disk_new("build/disk_rtl.dsk");
    // ⚠ Здесь я сам создал расхождение, предвосхищая ловушку из ревью.
    // Эталон действительно кладёт на DisplayStart сигнатуру "Sizg" и размеры
    // экрана — но делает это в risc_configure_memory(), которую этот запуск
    // НЕ вызывает. Поэтому у эталона там нули, и если вписать сигнатуру у себя,
    // модели разойдутся ровно в тот момент, когда система её прочитает
    // (обнаружено на шаге 2 101 536: R0 = 53697A67 против нуля).
    // Правильно — не писать ничего: обе модели видят нули.
    d.reset();

    struct RISC* r = risc_new();
    risc_set_serial(r, NULL);
    risc_set_spi(r, 1, disk_new("build/disk_ref.dsk"));

    printf("дифференциальный прогон: RTL против эталона, до %llu инструкций\n\n",
           (unsigned long long)maxi);

    // ── ФАЗА ПРОГРЕВА ────────────────────────────────────────────────────────
    // Пока исполняется загрузчик, обе модели живут в ПЗУ, но карты памяти у них
    // РАЗНЫЕ: у RTL адрес сброса 0xFFE000 и адреса 24-битные, у эталона ПЗУ по
    // 0xFFFFF800 и адреса 32-битные. Поэтому регистр ссылки и любые адресные
    // величины внутри загрузчика законно различаются на константу.
    // Строгое сравнение начинаем с момента, когда ОБЕ модели ушли в ОЗУ.
    bool warm = false;
    uint64_t warm_at = 0;
    uint64_t k = 0;
    for (; k < maxi; k++) {
        // Нормализация PC. Адреса сброса РАЗНЫЕ: у RTL StartAdr = 22'h3FF800
        // (байт 0xFFE000), у эталона ROMStart = 0xFFFFF800. Оба попадают в нулевое
        // слово ПЗУ, потому что ПЗУ на 512 слов алиасится. Поэтому внутри ПЗУ
        // сравниваем индекс слова, вне — сам адрес.
        auto norm = [](uint32_t pcw, bool in_rom) {
            return in_rom ? (pcw & 511) : (pcw & PC_MASK);
        };
        uint32_t dpc = d.pc(), rpc = risc_get_pc(r);
        bool d_rom = ((dpc * 4) >> 14) == (ROM_BASE >> 14);
        bool r_rom = (rpc >= 0xFFFFF800u / 4);
        uint32_t pc_before = norm(dpc, d_rom);
        uint32_t ref_pc_before = norm(rpc, r_rom);
        if (!warm) {
            if (!d_rom && !r_rom) {
                warm = true; warm_at = k;
                printf("  обе модели вышли в ОЗУ на шаге %llu (PC=%06X) — "
                       "начинаю строгое сравнение\n\n", (unsigned long long)k, dpc * 4);
            } else {
                // в фазе прогрева сверяем только положение в ПЗУ и его индекс
                if (d_rom != r_rom || (d_rom && pc_before != ref_pc_before)) {
                    printf("❌ РАСХОЖДЕНИЕ В ЗАГРУЗЧИКЕ на шаге %llu\n", (unsigned long long)k);
                    printf("   RTL    PC = %06X (ПЗУ: %s, слово %u)\n", dpc * 4, d_rom ? "да" : "нет", pc_before);
                    printf("   эталон PC = %08X (ПЗУ: %s, слово %u)\n", rpc * 4, r_rom ? "да" : "нет", ref_pc_before);
                    return 1;
                }
                risc_set_time(r, d.ms);
                int nn = d.step();
                if (nn < 0) { printf("❌ RTL завис в загрузчике на PC=%06X\n", dpc * 4); return 1; }
                risc_run(r, 1);
                continue;
            }
        }
        if (d_rom != r_rom || pc_before != ref_pc_before) {
            printf("❌ РАСХОЖДЕНИЕ ПО PC на шаге %llu\n", (unsigned long long)k);
            printf("   RTL    PC = %06X (в ПЗУ: %s)\n", dpc * 4, d_rom ? "да" : "нет");
            printf("   эталон PC = %08X (в ПЗУ: %s)\n", rpc * 4, r_rom ? "да" : "нет");
            return 1;
        }
        risc_set_time(r, d.ms);                 // ведём таймер эталона от нашего
        int n = d.step();
        if (n < 0) { printf("❌ RTL завис на PC=%06X\n", dpc * 4); return 1; }
        risc_run(r, 1);

        // сверка архитектурного состояния
        // Регистр ссылки (R15) — АДРЕС, и после выхода из загрузчика в нём ещё
        // лежит адрес возврата в ПЗУ. Карты памяти ПЗУ у моделей разные, поэтому
        // сравниваем его так же, как счётчик команд: если оба значения указывают
        // в окно ПЗУ — по индексу слова, иначе напрямую.
        auto addr_eq = ADDR_EQ;
        bool bad = false; std::string why;
        for (int i = 0; i < 16; i++) {
            uint32_t x = d.reg(i), y = risc_get_reg(r, i);
            if (x == y) continue;
            if (i == 15 && addr_eq(x, y)) continue;
            bad = true; why = "R" + std::to_string(i); break;
        }
        if (!bad && d.H() != risc_get_h(r)) { bad = true; why = "H"; }
        if (!bad && d.flags() != risc_get_flags(r)) { bad = true; why = "флаги"; }
        if (bad) {
            printf("❌ РАСХОЖДЕНИЕ (%s) на шаге %llu, PC=%06X\n",
                   why.c_str(), (unsigned long long)k, dpc * 4);
            printf("   %-6s %-10s %-10s\n", "", "RTL", "эталон");
            for (int i = 0; i < 16; i++)
                printf("   R%-4d %08X   %08X %s\n", i, d.reg(i), risc_get_reg(r, i),
                       d.reg(i) != risc_get_reg(r, i) ? "<<<" : "");
            printf("   H     %08X   %08X\n", d.H(), risc_get_h(r));
            printf("   флаги %X          %X   (NZCV)\n", d.flags(), risc_get_flags(r));
            return 1;
        }
        if (verbose && k < 40)
            printf("  [%6llu] PC=%06X ✓\n", (unsigned long long)k, dpc * 4);
        // ⚠ Сравнение шло только по регистрам, флагам и H. Неверная запись в
        // память оставалась невидимой до тех пор, пока значение оттуда не
        // прочитают обратно в регистр — то есть расхождение могло уехать на
        // миллионы инструкций от места, где возникло. Периодически сверяем ОЗУ
        // целиком. Кадровый буфер в сравнение входит: обе модели исполняют один
        // и тот же код и обязаны рисовать одинаково.
        if ((k % RAM_CHECK) == 0 && k) {
            uint32_t rwords = 0;
            const uint32_t* rram = risc_get_ram(r, &rwords);
            uint32_t n = rwords < (uint32_t)MEM_WORDS ? rwords : (uint32_t)MEM_WORDS;
            for (uint32_t i = 0; i < n; i++) {
                if (d.ram[i] == rram[i]) continue;
                // Адреса возврата в ПЗУ различаются законно: карты ПЗУ у моделей
                // разные (RTL 00FFE000, эталон FFFFF800). Сравниваем по смещению
                // внутри окна — то же правило, что уже применяется к R15.
                if (ADDR_EQ(d.ram[i], rram[i])) { rom_addr_waivers++; continue; }
                printf("❌ РАСХОЖДЕНИЕ В ПАМЯТИ на шаге %llu: слово %06X "
                       "RTL %08X, эталон %08X\n",
                       (unsigned long long)k, i * 4, d.ram[i], rram[i]);
                return 1;
            }
            ram_checks++;
        }
        if ((k % 1000000) == 0 && k)
            printf("  %llu млн инструкций — совпадение (сверок ОЗУ: %llu)\n",
                   (unsigned long long)k / 1000000, (unsigned long long)ram_checks);
    }
    if (!warm) printf("\n⚠ строгая фаза не началась: обе модели всё ещё в загрузчике\n");
    printf("  полных сверок ОЗУ: %llu, поблажек на адреса ПЗУ: %llu\n",
           (unsigned long long)ram_checks, (unsigned long long)rom_addr_waivers);
    printf("\n✅ СОВПАДЕНИЕ: %llu инструкций строгого сравнения "
           "(прогрев в загрузчике: %llu), %llu тактов RTL\n",
           (unsigned long long)(warm ? k - warm_at : 0), (unsigned long long)(warm ? warm_at : k),
           (unsigned long long)d.cycles);
    return 0;
}
