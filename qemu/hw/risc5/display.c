/*
 * Экран машины Оберона: 1024x768, один бит на точку.
 *
 * Кадровый буфер лежит прямо в оперативной памяти — отдельной видеопамяти у
 * машины нет. Адрес и раскладка сняты с VID.v:
 *
 *   localparam Org = 18'b1101_1111_1111_0000_00;
 *   assign vidadr = Org + {3'b0, ~vcnt, hword};
 *
 * Адрес там СЛОВНЫЙ, отсюда байтовое начало 0xE7F00. Ключевое — `~vcnt`:
 * строки хранятся СНИЗУ ВВЕРХ, нулевая строка экрана лежит по старшему
 * адресу. Забыть про это — значит получить перевёрнутую картинку.
 *
 * Внутри слова младший бит — самая левая точка (VID.v сдвигает pixbuf вправо).
 * Единица — чёрное: assign vid = pixbuf[0] ^ inv, и дальше RGB = {vid,vid,vid}
 * на белом фоне даёт чёрные буквы.
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
#include "qemu/osdep.h"
#include "ui/console.h"
#include "system/address-spaces.h"
#include "oberon-io.h"

#define FB_WIDTH   1024
#define FB_HEIGHT   768
#define FB_WORDS_PER_LINE (FB_WIDTH / 32)

static void oberon_display_update(void *opaque)
{
    OberonDisplay *d = opaque;
    DisplaySurface *surface = qemu_console_surface(d->con);
    uint32_t *dst;
    const uint32_t *fb;
    int y, w, bit;

    if (!surface || surface_bits_per_pixel(surface) != 32) {
        return;
    }

    fb = (const uint32_t *)memory_region_get_ram_ptr(d->ram) +
         (OBERON_FB_BASE / 4);
    dst = (uint32_t *)surface_data(surface);

    for (y = 0; y < FB_HEIGHT; y++) {
        /* Строки снизу вверх: экранной строке y отвечает строка буфера 767-y. */
        const uint32_t *src = fb + (size_t)(FB_HEIGHT - 1 - y) * FB_WORDS_PER_LINE;
        uint32_t *out = dst + (size_t)y * FB_WIDTH;

        for (w = 0; w < FB_WORDS_PER_LINE; w++) {
            uint32_t v = src[w];
            for (bit = 0; bit < 32; bit++) {
                /* Младший бит — левая точка; единица — чёрное. */
                out[w * 32 + bit] = (v >> bit) & 1 ? 0xFF000000u : 0xFFFFFFFFu;
            }
        }
    }

    qemu_console_update(d->con, 0, 0, FB_WIDTH, FB_HEIGHT);
}

static bool oberon_display_gfx_update(void *opaque)
{
    oberon_display_update(opaque);
    return true;
}

static void oberon_display_invalidate(void *opaque)
{
    oberon_display_update(opaque);
}

static const GraphicHwOps oberon_display_ops = {
    .gfx_update  = oberon_display_gfx_update,
    .invalidate  = oberon_display_invalidate,
};

void oberon_display_init(OberonDisplay *d, MemoryRegion *ram)
{
    d->ram = ram;
    d->con = qemu_graphic_console_create(NULL, 0, &oberon_display_ops, d);
    qemu_console_resize(d->con, FB_WIDTH, FB_HEIGHT);
}
