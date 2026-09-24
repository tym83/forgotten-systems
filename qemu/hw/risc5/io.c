/*
 * Порты машины Оберона.
 *
 * Карта снята с RISC5Top.v:85-97 (чтение) и :124-131 (запись). Шестнадцать
 * слов начиная с 0xFFFFC0; номер слова — это adr[5:2].
 *
 *   0  счётчик миллисекунд          чтение
 *   1  кнопки и переключатели       чтение
 *   2  приём RS232 / запись — передача
 *   3  готовность RS232             чтение
 *   4  приём SPI / запись — начать обмен
 *   5  готовность SPI / запись — управление выбором устройства
 *   6  мышь и признак клавиатуры    чтение
 *   7  код клавиши                  чтение
 *   8  вход GPIO                    чтение
 *   9  управление GPIO
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
#include "qemu/osdep.h"
#include "qemu/timer.h"
#include "system/address-spaces.h"
#include "oberon-io.h"

static uint64_t io_read(void *opaque, hwaddr addr, unsigned size)
{
    OberonIOState *s = opaque;

    switch (addr >> 2) {
    case 0:
        /*
         * Счётчик миллисекунд от включения. Система крутит на нём всё, что
         * связано со временем, — без него не доходит даже до экрана.
         */
        return qemu_clock_get_ms(QEMU_CLOCK_VIRTUAL) - s->start_ms;
    case 1:
        return 0;                       /* кнопок и переключателей нет */
    case 2:
        return 0;                       /* приём RS232 пока не подключён */
    case 3:
        return 2;                       /* передатчик готов, приёмник пуст */
    case 4:
        return s->spi_rx;
    case 5:
        return 1;                       /* обмен по SPI всегда завершён */
    case 6:
        /* Три старших бита — кнопки мыши, бит 28 — есть ли код клавиши. */
        return s->mouse | (s->kbd_ready ? (1u << 28) : 0);
    case 7:
        s->kbd_ready = false;           /* чтение забирает код */
        return s->kbd_data;
    case 8:
        return 0;
    case 9:
        return s->gpio_ctrl;
    default:
        return 0;
    }
}

static void io_write(void *opaque, hwaddr addr, uint64_t val, unsigned size)
{
    OberonIOState *s = opaque;

    switch (addr >> 2) {
    case 2:
        /* Передача в RS232: пока просто в никуда. */
        break;
    case 4:
        /*
         * Запись начинает обмен по SPI. Пока отвечаем 0xFF — так ведёт себя
         * шина, когда устройство не выбрано. Диск будет здесь.
         */
        s->spi_tx = val;
        s->spi_rx = 0xFFFFFFFF;
        break;
    case 5:
        s->spi_ctrl = val & 0xF;        /* выбор устройства, скорость */
        break;
    case 9:
        s->gpio_ctrl = val;
        break;
    default:
        break;
    }
}

static const MemoryRegionOps io_ops = {
    .read = io_read,
    .write = io_write,
    /*
     * Порты читаются и пишутся только словами: адресуются они adr[5:2],
     * младшие два бита в декодировании не участвуют.
     */
    .valid = { .min_access_size = 4, .max_access_size = 4 },
    .endianness = DEVICE_LITTLE_ENDIAN,
};

void oberon_io_init(OberonIOState *s, MemoryRegion *sys, hwaddr base)
{
    s->start_ms = qemu_clock_get_ms(QEMU_CLOCK_VIRTUAL);
    s->spi_rx = 0xFFFFFFFF;
    s->kbd_ready = false;

    memory_region_init_io(&s->mr, NULL, &io_ops, s, "oberon.io", 0x40);
    memory_region_add_subregion(sys, base, &s->mr);
}
