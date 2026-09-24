// ЗАМЫКАНИЕ КРУГА: компилятор Оберона собирает сам себя на настоящем RTL.
//
// До сих пор самораскрутка проверялась на эмуляторе RISC5, написанном на C
// (ext/norebo/Runtime/risc-cpu.c, 484 строки). Здесь тот же компилятор работает
// на ядре `RISC5.v` Никлауса Вирта, прогоняемом Verilator'ом такт за тактом.
//
// Что остаётся на C и почему это законно: мост к файловой системе хоста
// (norebo.c). Оберон обращается к нему через четыре адреса ввода-вывода —
// номер запроса и три аргумента, — и это интерфейс к ОС, а не часть машины.
// В браузерной версии он не нужен вовсе: там файлы живут в образе диска.
//
// Собирается с объектными файлами самого Norebo, чтобы использовать ЕГО
// реализацию файловых операций без изменений — иначе сравнение было бы нечестным.
#include "VRISC5.h"
#include "VRISC5___024root.h"
#include "VRISC5_RISC5.h"
#include "VRISC5_Registers.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <string>

// ── интерфейс к мосту Norebo (реализация — в norebo_bridge.c) ───────────────
extern "C" {
    void     nb_init(int argc, char** argv);
    uint32_t nb_io_read(uint32_t adr);
    void     nb_io_write(uint32_t adr, uint32_t val);
    int      nb_halted(void);
    uint32_t nb_ram_size(void);
    uint32_t* nb_ram(void);
    uint32_t nb_stack_org(void);
}

// ⚠ Norebo адресует устройства ОТРИЦАТЕЛЬНЫМИ числами (-4, -8, -12, -16), то есть
// 0xFFFFFFFC и т.д. в 32 битах. Но шина RISC5 — 24 бита, и оттуда приходит 0xFFFFFC.
// Проверка `(int32_t)a < 0` на 24-битном адресе не срабатывает НИКОГДА — из-за этого
// первый прогон крутился вхолостую 4 млрд инструкций.
// Устройства занимают верхние 64 байта 24-битного пространства; переводим обратно
// в отрицательный вид, который ждёт код Norebo.
static const uint32_t IO_TOP = 0x00FFFFC0;
static inline bool is_io(uint32_t a) { return a >= IO_TOP; }
static inline uint32_t to_neg(uint32_t a) { return a | 0xFF000000u; }

struct Soc {
    VRISC5* top;
    uint64_t cycles = 0, insns = 0;
    Soc() { top = new VRISC5; }
    ~Soc() { top->final(); delete top; }
    bool stall() const { return top->rootp->RISC5->stall; }
    uint32_t pc() const { return top->rootp->RISC5->PC; }

    // InnerCore грузит сам мост (nb_init): формат блочный — пары «размер, адрес»,
    // и разбирает его код Norebo без изменений.
    uint32_t read_mem(uint32_t a) {
        // ПЗУ в режиме Norebo не используется: InnerCore уже слинкован и лежит в ОЗУ
        if (is_io(a)) return nb_io_read(to_neg(a));
        uint32_t i = (a >> 2);
        return i < nb_ram_size() / 4 ? nb_ram()[i] : 0;
    }
    void write_mem(uint32_t a, uint32_t v, bool ben) {
        if (is_io(a)) { nb_io_write(to_neg(a), v); return; }
        uint32_t i = (a >> 2);
        if (i >= nb_ram_size() / 4) return;
        if (!ben) { nb_ram()[i] = v; return; }
        uint32_t m = 0xFFu << ((a & 3) * 8);
        nb_ram()[i] = (nb_ram()[i] & ~m) | (v & m);
    }
    void reset_at_zero() {
        // Norebo стартует с адреса 0, а не с ПЗУ: InnerCore уже слинкован
        top->rst = 0; top->irq = 0; top->stallX = 0;
        for (int i = 0; i < 4; i++) {
            top->clk = 0; top->eval();
            top->codebus = read_mem(top->adr); top->inbus = read_mem(top->adr); top->eval();
            top->clk = 1; top->eval();
        }
        top->rst = 1; top->clk = 0; top->eval();
        // Стартовое состояние — как в norebo.c: PC=0, R12=0x20 (вектор ловушек),
        // R14 = StackOrg. Сброс RISC5 ставит PC в ПЗУ, поэтому переопределяем.
        //
        // ⚠ И вместе с PC обязательно задать РЕГИСТР КОМАНД. RISC5 — машина с
        // предвыборкой: в начале такта IR держит исполняемую инструкцию, а шина
        // уже показывает следующую. Если задать только PC, в IR останется мусор
        // от сброса, первая инструкция (переход из InnerCore) не выполнится,
        // и ядро пойдёт исполнять таблицу модулей как код. Именно это и было.
        top->rootp->RISC5->PC = 0;
        top->rootp->RISC5->IR = read_mem(0);
        top->rootp->RISC5->regs->R[12] = 0x20;
        top->rootp->RISC5->regs->R[14] = nb_stack_org();
        top->codebus = read_mem(0); top->inbus = read_mem(0); top->eval();
    }
    int step() {
        int n = 0;
        for (;;) {
            top->clk = 0; top->eval();
            uint32_t a = top->adr;
            uint32_t d = read_mem(a);
            top->codebus = d; top->inbus = d; top->eval();
            bool ret = !stall();
            if (top->wr) write_mem(a, top->outbus, top->ben);
            top->clk = 1; top->eval();
            cycles++; n++;
            if (ret) { insns++; return n; }
            if (n > 400) return -1;
        }
    }
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    if (argc < 2) {
        fprintf(stderr, "использование: norebo_tb ORP.Compile Файл.Mod/s ...\n");
        return 1;
    }
    nb_init(argc, argv);
    Soc s;
    s.reset_at_zero();
    printf("  ядро: RISC5.v Вирта на Verilator, старт с адреса 0\n\n");

    uint64_t guard = 400000000ull;
    int trace = getenv("NB_TRACE_PC") ? atoi(getenv("NB_TRACE_PC")) : 0;
    for (uint64_t k = 0; k < guard; k++) {
        if (nb_halted()) break;
        if (trace && (int)k < trace) {
            auto* R = s.top->rootp->RISC5;
            printf("  [%4llu] PC=%06X IR=%08X R14=%08X R12=%08X\n",
                   (unsigned long long)k, R->PC * 4, s.read_mem(R->PC * 4),
                   R->regs->R[14], R->regs->R[12]);
        }
        int n = s.step();
        if (n < 0) { printf("\n  ЗАВИС на PC=%06X\n", s.pc() * 4); return 2; }
    }
    printf("\n  выполнено на RTL: %llu инструкций, %llu тактов\n",
           (unsigned long long)s.insns, (unsigned long long)s.cycles);
    return 0;
}
