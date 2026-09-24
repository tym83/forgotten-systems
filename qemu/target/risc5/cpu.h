/*
 * Машина RISC5 Никлауса Вирта для QEMU.
 *
 * Всё состояние ниже снято с RISC5.v, а не с описаний:
 *   :13  reg [21:0] PC          счётчик команд, 22 бита, В СЛОВАХ
 *   :15  reg N, Z, C, OV        флаги условий
 *   :16  reg [31:0] H           вспомогательный регистр
 *   :36  reg irq1, intEnb, intPnd, intMd    состояние прерываний
 *   :37  reg [25:0] SPC         сохранённые флаги и счётчик при прерывании
 *   :11  localparam StartAdr = 22'h3FF800   вектор сброса
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
#ifndef QEMU_RISC5_CPU_H
#define QEMU_RISC5_CPU_H

#include "cpu-qom.h"
#include "exec/cpu-common.h"
#include "exec/cpu-interrupt.h"
#include "system/memory.h"

#define CPU_RESOLVING_TYPE TYPE_RISC5_CPU

#define RISC5_NUM_REGS 16

/*
 * Соглашения об именах регистров. Это ИМЕННО СОГЛАШЕНИЯ компилятора Оберона,
 * а не свойство железа: для процессора все шестнадцать равноправны.
 */
#define RISC5_REG_MT  12   /* точка входа ловушки */
#define RISC5_REG_SB  13   /* база статических данных */
#define RISC5_REG_SP  14   /* вершина стека */
#define RISC5_REG_LNK 15   /* адрес возврата */

/* RISC5.v:11 — сброс уводит счётчик в ПЗУ. Значение в СЛОВАХ. */
#define RISC5_RESET_PC_W 0x3FF800

#define EXCP_RESET 1
#define EXCP_IRQ   2

typedef struct CPUArchState {
    /*
     * Счётчик команд хранится в словах, как в железе: там nxpc = PC + 1
     * (RISC5.v:182). Байтовый адрес получается умножением на четыре, и это
     * не деталь реализации — на этом стоит вся адресация кода.
     */
    uint32_t pc_w;

    uint32_t r[RISC5_NUM_REGS];

    /*
     * Флаги держим по одному в слове: так их дешевле вычислять в TCG, чем
     * распаковывать из общего регистра. В железе это четыре отдельных
     * триггера, так что расхождения с ним нет.
     */
    uint32_t sr_n;
    uint32_t sr_z;
    uint32_t sr_c;
    uint32_t sr_v;

    /* Старшая половина произведения либо остаток от деления (RISC5.v:221). */
    uint32_t h;

    /*
     * Прерывания. intEnb разрешает, intPnd помнит поступившее, intMd
     * показывает, что обработчик уже внутри. SPC хранит флаги вместе с
     * адресом возврата: {N, Z, C, V, PC[21:0]} — 26 бит (RISC5.v:227).
     */
    uint32_t spc;
    bool int_enb;
    bool int_pnd;
    bool int_md;
} CPURISC5State;

struct ArchCPU {
    CPUState parent_obj;
    CPURISC5State env;
};

/*
 * Чтение флагов командой MOV a, NZCV даёт не просто четыре бита:
 * RISC5.v:156 возвращает {N, Z, C, OV, 20'b0, 8'h53}. Младший байт — 0x53,
 * подпись версии ядра. Воспроизводим ровно, иначе система её не узнает.
 */
#define RISC5_NZCV_TAG 0x53

static inline uint32_t risc5_read_nzcv(const CPURISC5State *env)
{
    return ((env->sr_n & 1) << 31) | ((env->sr_z & 1) << 30) |
           ((env->sr_c & 1) << 29) | ((env->sr_v & 1) << 28) |
           RISC5_NZCV_TAG;
}


bool risc5_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                        MMUAccessType access_type, int mmu_idx,
                        bool probe, uintptr_t retaddr);
void risc5_cpu_do_interrupt(CPUState *cs);
bool risc5_cpu_exec_interrupt(CPUState *cs, int interrupt_request);
hwaddr risc5_cpu_get_phys_addr_debug(CPUState *cs, vaddr addr);
void risc5_cpu_tcg_init(void);
void risc5_cpu_translate_code(CPUState *cs, TranslationBlock *tb,
                              int *max_insns, vaddr pc, void *host_pc);

#endif
