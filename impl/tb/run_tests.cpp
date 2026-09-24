// Универсальный прогонщик направленных тестов ISA.
// Читает FILE.bin (машинный код) и FILE.chk (проверки от asm.py), исполняет на RTL
// с детектором ретайра и сверяет ожидания после каждой инструкции.
#include "VRISC5.h"
#include "VRISC5___024root.h"
#include "VRISC5_RISC5.h"
#include "VRISC5_Registers.h"
#include "soc_mem.h"
#include "cycle_model.h"
#include <cstdio>
#include <cstring>
#include <string>
#include <vector>

static const uint32_t ORG = 0x00FFE000;   // StartAdr = 22'h3FF800 (словный)

struct Core {
    VRISC5* top; Mem mem;
    uint64_t cycles = 0, insns = 0;
    // Запрос прерывания: тест пишет в служебный адрес, стенд поднимает irq
    // на один такт. Настоящий SoC поднимает его миллисекундным таймером;
    // здесь нужен детерминизм, поэтому источник задаёт сам тест.
    static constexpr uint32_t IRQ_REQ = 0x00FFFFC0;
    int irq_pending = 0;
    Core() { top = new VRISC5; }
    ~Core() { top->final(); delete top; }
    bool     stall() const { return top->rootp->RISC5->stall; }
    uint32_t pc()    const { return top->rootp->RISC5->PC; }
    uint32_t ir()    const { return top->rootp->RISC5->IR; }
    uint32_t reg(int i) const { return top->rootp->RISC5->regs->R[i]; }
    void reset() {
        // ⚠ Шину надо обслуживать из памяти и ВО ВРЕМЯ сброса: регистр команд
        // защёлкивается каждый такт (RISC5.v: IR <= stall ? IR : codebus), а на
        // шине адреса во время сброса уже стоит StartAdr. Если подавать нули,
        // после сброса в IR остаётся ноль, первый такт исполняет MOV R0,R0, и
        // первое слово программы машина не читает вовсе — оно теряется.
        //
        // Эта же ошибка была найдена и исправлена в tb/soc_tb.cpp, но сюда не
        // перенесена: регрессионного теста на неё не было. Прятаться она могла
        // потому, что все 264 проверки начинались с безразличной инструкции.
        // Нашлась зондом делителя: `MOV R1, 100` терялся, и деление давало ноль.
        // Стережёт теперь tests/t1_prime.s.
        top->rst = 0; top->irq = 0; top->stallX = 0;
        for (int i = 0; i < 4; i++) {
            top->clk = 0; top->eval();
            uint32_t a = top->adr; uint32_t d = mem.read(a);
            top->inbus = d; top->codebus = d; top->eval();
            top->clk = 1; top->eval();
        }
        top->rst = 1; top->clk = 0; top->eval();
    }
    int step() {
        int n = 0;
        for (;;) {
            top->clk = 0; top->eval();
            uint32_t a = top->adr, d = mem.read(a);
            top->inbus = d; top->codebus = d; top->eval();
            bool retiring = !stall();
            if (top->wr) {
                if ((a & ~3u) == IRQ_REQ) irq_pending = (int)top->outbus;  // запрос
                else mem.write(a, top->outbus, top->ben);
            }
            top->irq = (irq_pending > 0) ? 1 : 0;
            if (irq_pending > 0) irq_pending--;
            top->clk = 1; top->eval();
            cycles++; n++;
            if (retiring) { insns++; return n; }
            if (n > 500) { printf("  ЗАВИС на PC=%06X IR=%08X\n", pc()*4, ir()); return -1; }
        }
    }
    uint32_t value(const std::string& name) const {
        auto* R = top->rootp->RISC5;
        if (name[0] == 'R' && name.size() > 1 && isdigit(name[1])) return reg(atoi(name.c_str()+1));
        if (name == "N") return R->N;   if (name == "Z") return R->Z;
        if (name == "C") return R->C;   if (name == "V") return R->OV;
        if (name == "H") return R->H;   if (name == "PC") return R->PC * 4;
        if (name == "SPC") return R->SPC;
        if (name == "IE") return R->intEnb;
        if (name == "IMD") return R->intMd;
        printf("  ⚠ неизвестное имя в проверке: %s\n", name.c_str());
        return 0xDEADBEEF;
    }
};

struct Expect { int at; std::string name; uint32_t val; bool fired = false; };

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    if (argc < 2) { fprintf(stderr, "использование: run_tests БАЗА (без расширения)\n"); return 1; }
    std::string base = argv[1];
    int trace = 0;
    for (int i = 2; i < argc; i++)
        if (std::string(argv[i]).rfind("--trace=", 0) == 0) trace = atoi(argv[i] + 8);

    // .bin
    FILE* f = fopen((base + ".bin").c_str(), "rb");
    if (!f) { fprintf(stderr, "нет %s.bin\n", base.c_str()); return 1; }
    std::vector<uint32_t> prog; uint32_t w;
    while (fread(&w, 4, 1, f) == 1) prog.push_back(w);
    fclose(f);

    // .chk
    std::vector<Expect> exps;
    f = fopen((base + ".chk").c_str(), "r");
    if (f) {
        char line[256];
        while (fgets(line, sizeof line, f)) {
            if (line[0] == '#') continue;
            int at; char nm[64]; long long v;
            if (sscanf(line, "%d %63s %lld", &at, nm, &v) == 3)
                exps.push_back({at, nm, (uint32_t)v});
        }
        fclose(f);
    }

    Core c;
    // ⚠ Счётчик команд 22-битный (RISC5.v: wire [21:0] PC), а программа лежит по
    // ORG. Значит от ORG до края адресного пространства помещается ровно
    // 0x400000 - (ORG>>2) слов. Программа длиннее молча уходила по кругу на
    // нулевой адрес: инструкции продолжали исполняться, но `here` больше никогда
    // не совпадал с индексом слова, и все проверки за краем просто не срабатывали.
    // Поймано правилом «несработавшее ожидание — провал» на дифференциале АЛУ.
    const size_t ROOM = 0x400000 - (ORG >> 2);
    if (prog.size() > ROOM) {
        printf("  ❌ программа %zu слов не помещается: от ORG доступно %zu "
               "(22-битный PC)\n", prog.size(), ROOM);
        return 1;
    }
    c.mem.load_words(ORG, prog.data(), prog.size());
    c.reset();

    printf("=== %s: %zu инструкций, %zu проверок ===\n", base.c_str(), prog.size(), exps.size());
    int fails = 0, done = 0;
    size_t guard = prog.size() * 4 + 64;
    uint32_t last_cycles = 0;
    CycleModel model; int model_fails = 0;
    for (size_t k = 0; k < guard; k++) {
        uint32_t before_pc = c.pc();
        uint32_t insn_word = c.mem.read(before_pc * 4);
        if (trace && (int)k < trace)
            printf("    [%3zu] PC=%06X IR=%08X  N=%d Z=%d IE=%d IMD=%d\n",
                   k, before_pc * 4, insn_word,
                   c.top->rootp->RISC5->N, c.top->rootp->RISC5->Z,
                   c.top->rootp->RISC5->intEnb, c.top->rootp->RISC5->intMd);
        int predicted = model.cycles(insn_word);
        int n = c.step();
        if (n < 0) { fails++; break; }
        last_cycles = n;
        if (predicted != n) {
            if (model_fails < 6)
                printf("  ⚠ модель: PC=%06X insn=%08X предсказано %d, реально %d\n",
                       before_pc*4, insn_word, predicted, n);
            model_fails++;
        }
        // Проверки привязаны к АДРЕСУ (номеру слова), а не к числу выполненных
        // инструкций: при переходах эти величины расходятся. Проверка срабатывает,
        // когда машина подошла к инструкции с этим индексом.
        uint32_t here = c.pc() - (ORG >> 2);
        for (auto& e : exps) {
            if (e.fired || (uint32_t)e.at != here) continue;
            e.fired = true;
            uint32_t got = (e.name == "CYCLES") ? last_cycles : c.value(e.name);
            done++;
            if (got != e.val) {
                printf("  ❌ после инстр. #%d (PC=%06X): %s = %u, ожидалось %u\n",
                       e.at, before_pc*4, e.name.c_str(), got, e.val);
                fails++;
            }
        }
        if (c.pc() == before_pc) break;          // HALT = B . (переход на себя)
    }
    // 🔴 Найдено мутационным тестированием: ожидание, которое НЕ СРАБОТАЛО (машина
    // не дошла до его адреса), раньше просто не считалось — и тест оставался зелёным.
    // Мутация `B > chkLim` вместо `>=` убирала две проверки из пяти и проходила.
    // Непроверенное ожидание — это провал, а не отсутствие результата.
    if (done != (int)exps.size()) {
        printf("  ❌ сработало %d ожиданий из %zu — остальные НЕ ПРОВЕРЕНЫ:\n",
               done, exps.size());
        for (auto& e : exps)
            if (!e.fired) printf("     слово %d: %s = %u\n", e.at, e.name.c_str(), e.val);
        fails += (int)exps.size() - done;
    }
    printf("  модель тактов: расхождений %d  %s\n", model_fails, model_fails ? "❌" : "✅");
    if (model_fails) fails += model_fails;
    printf("  тактов %llu, инструкций %llu | проверено %d/%zu | провалов %d  %s\n",
           (unsigned long long)c.cycles, (unsigned long long)c.insns,
           done, exps.size(), fails, fails ? "❌" : "✅");
    return fails ? 1 : 0;
}
