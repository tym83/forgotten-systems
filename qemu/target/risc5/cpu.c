/*
 * Процессор RISC5 Никлауса Вирта для QEMU — объект и его жизненный цикл.
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
#include "qemu/osdep.h"
#include "qapi/error.h"
#include "qemu/qemu-print.h"
#include "exec/target_page.h"
#include "exec/translation-block.h"
#include "exec/cputlb.h"
#include "exec/page-protection.h"
#include "tcg/debug-assert.h"
#include "accel/tcg/cpu-ops.h"
#include "hw/core/qdev-properties.h"
#include "hw/core/sysemu-cpu-ops.h"
#include "migration/vmstate.h"
#include "cpu.h"

/*
 * Счётчик команд внутри держится в СЛОВАХ, как в железе: RISC5.v:182 делает
 * nxpc = PC + 1 на инструкцию. Снаружи QEMU оперирует байтовыми адресами,
 * поэтому на границе умножаем и делим на четыре. Точно так же поступает цель
 * avr, у которой слово шестнадцатибитное.
 */
static void risc5_cpu_set_pc(CPUState *cs, vaddr value)
{
    cpu_env(cs)->pc_w = value / 4;
}

static vaddr risc5_cpu_get_pc(CPUState *cs)
{
    return cpu_env(cs)->pc_w * 4;
}

static bool risc5_cpu_has_work(CPUState *cs)
{
    return cpu_test_interrupt(cs, CPU_INTERRUPT_HARD) &&
           cpu_env(cs)->int_enb;
}

/*
 * Блока управления памятью нет, разделения кода и данных тоже: любое слово
 * доступно любому коду. Поэтому индекс один на всё.
 */
static int risc5_cpu_mmu_index(CPUState *cs, bool ifetch)
{
    return 0;
}

static TCGTBCPUState risc5_get_tb_cpu_state(CPUState *cs)
{
    return (TCGTBCPUState){ .pc = cpu_env(cs)->pc_w * 4, .flags = 0 };
}

static void risc5_cpu_synchronize_from_tb(CPUState *cs,
                                          const TranslationBlock *tb)
{
    tcg_debug_assert(!tcg_cflags_has(cs, CF_PCREL));
    cpu_env(cs)->pc_w = tb->pc / 4;
}

static void risc5_restore_state_to_opc(CPUState *cs,
                                       const TranslationBlock *tb,
                                       const uint64_t *data)
{
    cpu_env(cs)->pc_w = data[0];
}

static void risc5_cpu_reset_hold(Object *obj, ResetType type)
{
    CPUState *cs = CPU(obj);
    RISC5CPUClass *mcc = RISC5_CPU_GET_CLASS(obj);
    CPURISC5State *env = cpu_env(cs);

    if (mcc->parent_phases.hold) {
        mcc->parent_phases.hold(obj, type);
    }

    memset(env->r, 0, sizeof(env->r));
    env->sr_n = env->sr_z = env->sr_c = env->sr_v = 0;
    env->h = 0;
    env->spc = 0;
    env->int_enb = env->int_pnd = env->int_md = false;

    /*
     * RISC5.v:11,195 — сброс уводит счётчик в ПЗУ, а не в ноль. Там лежит
     * загрузчик, который поднимает систему с диска по SPI.
     */
    env->pc_w = RISC5_RESET_PC_W;
}


/*
 * Трансляции адресов нет: физический равен виртуальному. Отображение
 * заводим один раз на всю страницу и всегда успешно — промахнуться здесь
 * нечем, защиты не существует.
 */
bool risc5_cpu_tlb_fill(CPUState *cs, vaddr address, int size,
                        MMUAccessType access_type, int mmu_idx,
                        bool probe, uintptr_t retaddr)
{
    tlb_set_page(cs, address & TARGET_PAGE_MASK, address & TARGET_PAGE_MASK,
                 PAGE_READ | PAGE_WRITE | PAGE_EXEC, mmu_idx, TARGET_PAGE_SIZE);
    return true;
}

hwaddr risc5_cpu_get_phys_addr_debug(CPUState *cs, vaddr addr)
{
    return addr;
}

/*
 * Приём прерывания (RISC5.v:193-196, 227). Флаги и адрес возврата
 * складываются в SPC одним словом — {N, Z, C, V, PC[21:0]}, — а счётчик
 * уходит в СЛОВО 1, а не в ноль: нулевое слово занято загрузчиком.
 */
void risc5_cpu_do_interrupt(CPUState *cs)
{
    CPURISC5State *env = cpu_env(cs);

    env->spc = ((env->sr_n & 1) << 25) | ((env->sr_z & 1) << 24) |
               ((env->sr_c & 1) << 23) | ((env->sr_v & 1) << 22) |
               (env->pc_w & 0x3FFFFF);
    env->int_md = true;
    env->pc_w = 1;
    cs->exception_index = -1;
}

bool risc5_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
{
    CPURISC5State *env = cpu_env(cs);

    /* intAck = intPnd & intEnb & ~intMd (RISC5.v:193) */
    if (!(interrupt_request & CPU_INTERRUPT_HARD)) {
        return false;
    }
    if (!env->int_enb || env->int_md) {
        return false;
    }
    cs->exception_index = EXCP_IRQ;
    risc5_cpu_do_interrupt(cs);
    return true;
}

static void risc5_cpu_dump_state(CPUState *cs, FILE *f, int flags)
{
    CPURISC5State *env = cpu_env(cs);
    int i;

    qemu_fprintf(f, "PC   %08x (слово %06x)\n", env->pc_w * 4, env->pc_w);
    qemu_fprintf(f, "H    %08x   N%u Z%u C%u V%u\n", env->h,
                 env->sr_n & 1, env->sr_z & 1, env->sr_c & 1, env->sr_v & 1);

    for (i = 0; i < RISC5_NUM_REGS; i++) {
        qemu_fprintf(f, "R%-2d  %08x%s", i, env->r[i],
                     (i % 4) == 3 ? "\n" : "   ");
    }
}

/*
 * ⚠ Без этого процессор создаётся, но НЕ ИСПОЛНЯЕТ: поток исполнения
 * заводится здесь. Признак был обманчив — машина запускалась, состояние
 * говорило «running», а query-cpus-fast отдавал пустой список, и ни один
 * блок трансляции не выполнялся.
 */
static void risc5_cpu_realizefn(DeviceState *dev, Error **errp)
{
    CPUState *cs = CPU(dev);
    RISC5CPUClass *mcc = RISC5_CPU_GET_CLASS(dev);
    Error *local_err = NULL;

    cpu_common_realize(cs, &local_err);
    if (local_err != NULL) {
        error_propagate(errp, local_err);
        return;
    }
    qemu_init_vcpu(cs);
    cpu_reset(cs);

    mcc->parent_realize(dev, errp);
}

static void risc5_cpu_initfn(Object *obj)
{
    /*
     * Ни свойств, ни вариантов ядра: машина одна, и она не
     * параметризуется. Список признаков, который есть у больших целей,
     * здесь был бы пустым.
     */
}

static const VMStateDescription vms_risc5_cpu = { .name = "cpu", .unmigratable = 1 };

static const TCGCPUOps risc5_tcg_ops = {
    .guest_default_memory_order = 0,
    .mttcg_supported = false,
    .initialize = risc5_cpu_tcg_init,
    .translate_code = risc5_cpu_translate_code,
    .get_tb_cpu_state = risc5_get_tb_cpu_state,
    .synchronize_from_tb = risc5_cpu_synchronize_from_tb,
    .restore_state_to_opc = risc5_restore_state_to_opc,
    .mmu_index = risc5_cpu_mmu_index,
    .cpu_exec_interrupt = risc5_cpu_exec_interrupt,
    .cpu_exec_halt = risc5_cpu_has_work,
    .cpu_exec_reset = cpu_reset,
    .tlb_fill = risc5_cpu_tlb_fill,
    .do_interrupt = risc5_cpu_do_interrupt,
    .pointer_wrap = cpu_pointer_wrap_uint32,
};

static const struct SysemuCPUOps risc5_sysemu_ops = {
    .has_work = risc5_cpu_has_work,
    .get_phys_addr_debug = risc5_cpu_get_phys_addr_debug,
};

static void risc5_cpu_class_init(ObjectClass *oc, const void *data)
{
    DeviceClass *dc = DEVICE_CLASS(oc);
    CPUClass *cc = CPU_CLASS(oc);
    RISC5CPUClass *mcc = RISC5_CPU_CLASS(oc);
    ResettableClass *rc = RESETTABLE_CLASS(oc);

    device_class_set_parent_realize(dc, risc5_cpu_realizefn, &mcc->parent_realize);
    resettable_class_set_parent_phases(rc, NULL, risc5_cpu_reset_hold, NULL,
                                       &mcc->parent_phases);

    cc->dump_state = risc5_cpu_dump_state;
    cc->set_pc = risc5_cpu_set_pc;
    cc->get_pc = risc5_cpu_get_pc;
    cc->sysemu_ops = &risc5_sysemu_ops;
    cc->tcg_ops = &risc5_tcg_ops;
    dc->vmsd = &vms_risc5_cpu;
}

static const TypeInfo risc5_cpu_type_info[] = {
    {
        .name = TYPE_RISC5_CPU,
        .parent = TYPE_CPU,
        .instance_size = sizeof(RISC5CPU),
        .instance_init = risc5_cpu_initfn,
        .class_size = sizeof(RISC5CPUClass),
        .class_init = risc5_cpu_class_init,
    },
};

DEFINE_TYPES(risc5_cpu_type_info)
