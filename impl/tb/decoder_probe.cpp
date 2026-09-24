// Эмпирическая карта декодера RISC5.
// Задача 1: доказать, что биты IR[15:4] для формата F0 действительно игнорируются
//           (а не «на вид не читаются») — перебором всех 4096 значений.
// Задача 2: снять таблицу «что реально декодируется» для всех 256 комбинаций
//           {IR[31:28] × op}, чтобы знать, какие кодировки заняты.
#include "VRISC5.h"
#include "VRISC5___024root.h"
#include "VRISC5_RISC5.h"
#include "VRISC5_Registers.h"
#include "soc_mem.h"
#include <cstdio>
#include <map>
#include <set>
#include <string>

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
            bool retiring = !stall();
            if (top->wr) mem.write(a, top->outbus, top->ben);
            top->clk = 1; top->eval();
            n++;
            if (retiring) return n;
            if (n > 300) return -1;
        }
    }
    // Итог исполнения одной инструкции: что изменилось.
    struct Res { uint32_t r5, flags; int cycles; };
    Res run_one(uint32_t insn) {
        mem.w.assign(Mem::WORDS, 0);
        const uint32_t prologue[] = {
            0x41001234,   // MOV R1, 0x1234
            0x42005678,   // MOV R2, 0x5678
            0x45000000,   // MOV R5, 0        (цель, обнуляем)
        };
        mem.load_words(ORG, prologue, 3);
        mem.load_words(ORG + 12, &insn, 1);
        reset();
        for (int i = 0; i < 3; i++) step();
        int c = step();
        auto* R = top->rootp->RISC5;
        uint32_t fl = (R->N << 3) | (R->Z << 2) | (R->C << 1) | R->OV;
        return { reg(5), fl, c };
    }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Probe p;

    // ── Задача 1: игнорируются ли IR[15:4] в формате F0? ───────────────────
    // Берём ADD R5, R1, R2 в формате F0: 0000 | a=5 | b=1 | op=8 | 0000...0000 | c=2
    printf("=== IR[15:4] в формате F0: игнорируются? ===\n");
    int bad = 0;
    uint32_t base = (0x0u << 28) | (5u << 24) | (1u << 20) | (8u << 16) | 2u;
    auto ref = p.run_one(base);
    printf("  эталон (IR[15:4]=0):  R5=%08X флаги=%X тактов=%d\n", ref.r5, ref.flags, ref.cycles);
    for (uint32_t bits = 1; bits < 4096; bits++) {
        auto r = p.run_one(base | (bits << 4));
        if (r.r5 != ref.r5 || r.flags != ref.flags || r.cycles != ref.cycles) {
            if (bad < 5) printf("  ❌ IR[15:4]=%03X даёт R5=%08X флаги=%X тактов=%d\n",
                                bits, r.r5, r.flags, r.cycles);
            bad++;
        }
    }
    printf("  перебрано 4095 ненулевых значений, расхождений: %d  %s\n\n",
           bad, bad ? "❌" : "✅ поле СВОБОДНО");

    // То же для формата F1 (q=1) — там imm ДОЛЖЕН влиять, это контроль метода
    printf("=== контроль: в формате F1 те же биты обязаны ВЛИЯТЬ ===\n");
    uint32_t base1 = (0x4u << 28) | (5u << 24) | (1u << 20) | (8u << 16);
    auto r1a = p.run_one(base1 | 0x0000);
    auto r1b = p.run_one(base1 | 0x0AB0);
    printf("  imm=0000 -> R5=%08X ; imm=0AB0 -> R5=%08X  %s\n\n",
           r1a.r5, r1b.r5, (r1a.r5 != r1b.r5) ? "✅ влияет, метод рабочий" : "❌ метод сломан");

    // ── Задача 2: карта 256 комбинаций {IR[31:28] × op} ────────────────────
    printf("=== карта декодера: что делает каждая комбинация ===\n");
    printf("    (a=5, b=1, c=2; R1=00001234, R2=00005678, R5 обнулён)\n\n");
    printf("     op:");
    for (int op = 0; op < 16; op++) printf(" %8d", op);
    printf("\n");
    for (int hi = 0; hi < 4; hi++) {            // только F0/F1: биты 31:30 = 00 и 01
        for (int sub = 0; sub < 4; sub++) {
            int nib = (hi << 2) | sub;
            if (nib >= 8) continue;              // F2/F3 — другие форматы, отдельно
            printf("  %04d:", nib);
            for (int op = 0; op < 16; op++) {
                uint32_t insn = ((uint32_t)nib << 28) | (5u << 24) | (1u << 20) | ((uint32_t)op << 16) | 2u;
                auto r = p.run_one(insn);
                printf(" %8X", r.r5);
            }
            printf("\n");
        }
    }
    printf("\n  строки — старший нибл IR[31:28] (в двоичном виде), столбцы — op\n");
    printf("  0000/0010 = F0 (u=0/1), 0001/0011 = F0 с БИТОМ 28 = 1\n");
    return bad ? 1 : 0;
}
