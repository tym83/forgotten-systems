/* SPDX-License-Identifier: GPL-2.0-or-later */
#ifndef HW_RISC5_OBERON_IO_H
#define HW_RISC5_OBERON_IO_H

#include "system/memory.h"

/* Порты занимают шестнадцать слов начиная с 0xFFFFC0 (RISC5Top.v:86). */
#define OBERON_IO_BASE 0xFFFFC0
#define OBERON_IO_SIZE 0x40

typedef struct OberonIOState {
    MemoryRegion mr;
    int64_t  start_ms;      /* отсчёт миллисекунд от включения */
    uint32_t spi_tx, spi_rx, spi_ctrl;
    uint32_t mouse;
    uint32_t kbd_data;
    bool     kbd_ready;
    uint32_t gpio_ctrl;
} OberonIOState;

void oberon_io_init(OberonIOState *s, MemoryRegion *sys, hwaddr base);

#endif
