/* SPDX-License-Identifier: GPL-2.0-or-later */
#ifndef HW_RISC5_OBERON_IO_H
#define HW_RISC5_OBERON_IO_H

#include "system/memory.h"
#include "system/block-backend-global-state.h"

/* Порты занимают шестнадцать слов начиная с 0xFFFFC0 (RISC5Top.v:86). */
#define OBERON_IO_BASE 0xFFFFC0
#define OBERON_IO_SIZE 0x40

/* Диск по SPI: состояние разбора команд карты SD. */
typedef struct OberonDisk {
    BlockBackend *blk;
    int      state;
    uint32_t offset;          /* смещение секторов для образа без разделов */
    uint32_t write_sector;

    uint32_t rx_buf[130];
    int      rx_idx;
    uint32_t tx_buf[130];
    int      tx_cnt, tx_idx;
    bool     first_read_seen;
} OberonDisk;

void     oberon_disk_init(OberonDisk *d, BlockBackend *blk);
void     oberon_disk_write(OberonDisk *d, uint32_t value);
uint32_t oberon_disk_read(OberonDisk *d);

typedef struct OberonIOState {
    MemoryRegion mr;
    int64_t  start_ms;      /* отсчёт миллисекунд от включения */
    uint32_t spi_tx, spi_rx, spi_ctrl;
    uint32_t mouse;
    uint32_t kbd_data;
    bool     kbd_ready;
    uint32_t gpio_ctrl;
    OberonDisk disk;
} OberonIOState;

void oberon_io_init(OberonIOState *s, MemoryRegion *sys, hwaddr base,
                    BlockBackend *blk);

#endif
