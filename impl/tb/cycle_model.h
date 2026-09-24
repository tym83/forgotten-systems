// Модель тактов RISC5, ВЫВЕДЕННАЯ ИЗ ИЗМЕРЕНИЙ на настоящем RTL.
//
// Латентности (tests/t1_latency.s, 17/17 на живом RTL):
//   1 такт   — MOV, сдвиги, логика, ADD/SUB, ветвления
//   2 такта  — LD/ST (фон-неймановское стойло: одна шина на код и данные)
//   4        — FAD/FSB
//   26       — FML
//   27       — FDV
//   34       — MUL/DIV
//
// Надбавка за подряд идущие операции ОДНОГО блока (tests/t1_fpb2b.s, 13/13):
// счётчик состояния не обнуляется, пока run высок, поэтому вторая подряд операция
// обязана докрутить счётчик до переполнения. Цена = ПЕРИОД СЧЁТЧИКА = 2^разрядность:
//   FPAdder      2 бита -> 4    (совпадает с длиной операции, надбавки нет)
//   FPMultiplier 5 бит  -> 32   (операция 26)
//   FPDivider    5 бит  -> 32   (операция 27)
//   Multiplier   6 бит  -> 64   (операция 34)
//   Divider      6 бит  -> 64   (операция 34)
// Блоки независимы: у каждого свой run, поэтому чередование сбрасывает счётчик.
#pragma once
#include <cstdint>

enum CycUnit { U_NONE = 0, U_MUL, U_DIV, U_FPADD, U_FPMUL, U_FPDIV };

struct CycleModel {
    CycUnit prev = U_NONE;

    // Возвращает число тактов инструкции insn и обновляет состояние.
    int cycles(uint32_t insn) {
        uint32_t p = (insn >> 31) & 1, q = (insn >> 30) & 1, u = (insn >> 29) & 1;
        CycUnit unit = U_NONE;
        int lat = 1, period = 1;

        if (!p) {                                   // F0/F1: регистровые операции
            uint32_t op = (insn >> 16) & 0xF;
            switch (op) {
                case 10: unit = U_MUL;   lat = 34; period = 64; break;   // MUL
                case 11: unit = U_DIV;   lat = 34; period = 64; break;   // DIV
                case 12: case 13: unit = U_FPADD; lat = 4;  period = 4;  break; // FAD/FSB
                case 14: unit = U_FPMUL; lat = 26; period = 32; break;   // FML
                case 15: unit = U_FPDIV; lat = 27; period = 32; break;   // FDV
                default: unit = U_NONE;  lat = 1;  period = 1;  break;
            }
        } else if (!q) {                            // F2: загрузка/сохранение
            lat = 2; period = 2; unit = U_NONE;
            (void)u;
        } else {                                    // F3: ветвления
            lat = 1; period = 1; unit = U_NONE;
        }
        int c = (unit != U_NONE && unit == prev) ? period : lat;
        prev = unit;
        return c;
    }
};
