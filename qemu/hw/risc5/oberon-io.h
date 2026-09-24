/* SPDX-License-Identifier: GPL-2.0-or-later */
#ifndef HW_RISC5_OBERON_IO_H
#define HW_RISC5_OBERON_IO_H

#include "system/memory.h"
#include "ui/console.h"
#include "ui/input.h"
#include "system/block-backend-global-state.h"

/* Порты занимают шестнадцать слов начиная с 0xFFFFC0 (RISC5Top.v:86). */
#define OBERON_IO_BASE 0xFFFFC0
#define OBERON_IO_SIZE 0x40

/* Диск по SPI: состояние разбора команд карты SD. */
/*
 * Кадровый буфер. Адрес снят с VID.v: Org = 18'b1101_1111_1111_0000_00 —
 * адрес СЛОВНЫЙ, отсюда байтовое начало 0xE7F00. Размер 1024*768/8 байт.
 */
#define OBERON_FB_BASE 0xE7F00
#define OBERON_FB_SIZE (1024 * 768 / 8)

typedef struct OberonDisplay {
    QemuConsole  *con;
    MemoryRegion *ram;
} OberonDisplay;

void oberon_display_init(OberonDisplay *d, MemoryRegion *ram);

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

/* Очередь клавиатуры — 16 байт, как fifo[15:0] в PS2.v. */
#define OBERON_KBD_FIFO 16

typedef struct OberonIOState {
    MemoryRegion mr;
    int64_t  start_ms;      /* отсчёт миллисекунд от включения */
    uint32_t spi_tx, spi_rx, spi_ctrl;
    uint32_t mouse;
    int      mouse_x, mouse_y, mouse_btn;

    uint8_t  kbd_fifo[OBERON_KBD_FIFO];
    int      kbd_head, kbd_tail;

    QemuInputHandlerState *kbd_handler, *mouse_handler;
    uint32_t gpio_ctrl;
    OberonDisk disk;
} OberonIOState;

void oberon_io_init(OberonIOState *s, MemoryRegion *sys, hwaddr base,
                    BlockBackend *blk);
void oberon_input_init(OberonIOState *s);

#endif
