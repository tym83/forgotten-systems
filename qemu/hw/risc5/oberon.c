/*
 * Плата машины Оберона.
 *
 * Карта памяти снята с RISC5Top.v:
 *   :84  codebus = (adr[23:14] == 10'h3FF) ? romout : inbus0
 *        — выборка кода из ПЗУ начиная с 0xFFC000
 *   :86  ioenb   = (adr[23:6] == 18'h3FFFF)
 *        — регистры ввода-вывода с 0xFFFFC0, шестнадцать слов
 *   RISC5.v:11  вектор сброса 22'h3FF800, то есть байтовый 0xFFE000
 *
 * Устройств пока нет: это самая узкая плата, на которой цель собирается и
 * можно гонять отдельные команды против нашего же RTL. Диск по SPI, мышь,
 * клавиатура и кадровый буфер — следующим шагом.
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
#include "qemu/osdep.h"
#include "qapi/error.h"
#include "hw/core/boards.h"
#include "hw/core/loader.h"
#include "qemu/error-report.h"
#include "hw/core/qdev-properties.h"
#include "system/address-spaces.h"
#include "system/system.h"
#include "cpu.h"
#include "oberon-io.h"
#include "system/blockdev.h"
#include "hw/core/qdev-properties-system.h"

/*
 * ПЗУ в железе — 512 слов: PROM.v берёт только adr[10:2]. Выборка кода
 * уходит в него начиная с 0xFFC000 (RISC5Top.v:84), то есть двухкилобайтный
 * блок повторяется четырежды; сброс попадает в 0xFFE000, это его начало.
 * Заводим ровно 2 КБ по адресу сброса — так же, как есть в схеме.
 */
#define OBERON_RAM_BASE  0x000000
#define OBERON_RAM_SIZE  0xFFE000
#define OBERON_ROM_BASE  0xFFE000
#define OBERON_ROM_SIZE  0x000800

static void oberon_init(MachineState *machine)
{
    MemoryRegion *sys = get_system_memory();
    MemoryRegion *ram = g_new(MemoryRegion, 1);
    MemoryRegion *rom = g_new(MemoryRegion, 1);
    RISC5CPU *cpu;

    cpu = RISC5_CPU(cpu_create(machine->cpu_type));

    memory_region_init_ram(ram, NULL, "oberon.ram", OBERON_RAM_SIZE,
                           &error_fatal);
    memory_region_add_subregion(sys, OBERON_RAM_BASE, ram);

    /*
     * ПЗУ доступно только на чтение: в железе это отдельный блок PROM,
     * писать туда нечем.
     */
    memory_region_init_rom(rom, NULL, "oberon.rom", OBERON_ROM_SIZE,
                           &error_fatal);
    memory_region_add_subregion(sys, OBERON_ROM_BASE, rom);

    /*
     * Содержимое ПЗУ подаётся через -bios. Это же и есть способ гонять
     * отдельные программы для сверки с настоящим RTL: наш ассемблер
     * собирает кусок кода, он кладётся по адресу сброса, и дальше можно
     * сравнивать состояние регистров команда за командой.
     */
    /*
     * Порты. Без счётчика миллисекунд система не доходит даже до экрана:
     * на нём держится всё, что связано со временем.
     */
    {
        /*
         * Образ системы подаётся приводом без шины:
         *   -drive if=none,id=sd0,file=oberon.dsk,format=raw
         *
         * Именно без шины: QEMU считает осиротевшим любой привод с шиной,
         * который никто не забрал устройством, и отказывается запускаться.
         * Карта SD у нас не устройство qdev, а часть портов, поэтому берём
         * её по имени.
         */
        BlockBackend *blk = blk_by_name("sd0");

        if (!blk) {
            DriveInfo *dinfo = drive_get(IF_NONE, 0, 0);
            blk = dinfo ? blk_by_legacy_dinfo(dinfo) : NULL;
        }

        if (!blk) {
            warn_report("образ диска не задан: добавьте -drive if=none,id=sd0,file=<образ>,format=raw");
        }
        oberon_io_init(g_new0(OberonIOState, 1), sys, OBERON_IO_BASE, blk);
    }

    if (machine->firmware) {
        ssize_t n = load_image_mr(machine->firmware, rom);
        if (n < 0) {
            error_report("не удалось прочитать образ ПЗУ '%s'", machine->firmware);
            exit(1);
        }
    }

    (void)cpu;
}

static void oberon_machine_init(MachineClass *mc)
{
    mc->desc = "Oberon RISC5 (Wirth)";
    mc->init = oberon_init;
    mc->default_cpu_type = TYPE_RISC5_CPU;
    mc->default_ram_size = OBERON_RAM_SIZE;
    mc->no_parallel = 1;
    mc->no_floppy = 1;
    mc->no_cdrom = 1;
}

DEFINE_MACHINE("oberon", oberon_machine_init)
