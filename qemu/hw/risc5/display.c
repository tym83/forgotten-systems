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
#include "ui/vgafont.h"
#include "qemu/timer.h"
#include "system/address-spaces.h"
#include "oberon-io.h"

#define FB_WIDTH   1024
#define FB_HEIGHT   768
#define FB_WORDS_PER_LINE (FB_WIDTH / 32)

/*
 * Подсказка про кнопки мыши.
 *
 * Оберону нужны три кнопки, а на ноутбуке средней нет. Машина умеет аккорды,
 * но узнать о них человеку неоткуда: он видит экран по VNC, где никакой
 * документации рядом нет. Поэтому подсказка рисуется НА САМОМ ЭКРАНЕ —
 * в единственном месте, куда он точно смотрит.
 *
 * Полоса живёт полминуты и гаснет раньше, если аккордом уже воспользовались:
 * значит поняли. Кадровый буфер она не трогает — рисуется поверх готовой
 * картинки, поэтому побайтовая сверка с железом остаётся честной.
 *
 * Текст английский: его читает тот, кто пришёл со стороны.
 */
#define HINT_MS      30000
#define HINT_LINES   2
#define HINT_H       (HINT_LINES * 16 + 8)

static const char *const HINT[HINT_LINES] = {
    "Oberon needs three mouse buttons. On a laptop, hold a key and click:",
    "  Alt = middle (runs commands)   Ctrl = right   Shift = both (interclick)",
};

/* Одна буква шрифтом 8x16 поверх готовой картинки. */
static void draw_char(uint32_t *dst, int x, int y, unsigned char c,
                      uint32_t fg, uint32_t bg)
{
    const uint8_t *g = vgafont16 + (unsigned)c * 16;
    int r, b;

    for (r = 0; r < 16; r++) {
        uint32_t *out = dst + (size_t)(y + r) * FB_WIDTH + x;
        for (b = 0; b < 8; b++) {
            out[b] = (g[r] >> (7 - b)) & 1 ? fg : bg;
        }
    }
}

static void draw_hint(OberonDisplay *d, uint32_t *dst)
{
    int64_t now = qemu_clock_get_ms(QEMU_CLOCK_VIRTUAL);
    int line, i, y0;

    if (d->hint_done || now > HINT_MS) {
        return;
    }

    y0 = FB_HEIGHT - HINT_H;
    /* Подложка во всю ширину, чтобы буквы читались на любом фоне. */
    for (i = 0; i < HINT_H * FB_WIDTH; i++) {
        dst[(size_t)y0 * FB_WIDTH + i] = 0xFF101010u;
    }
    for (line = 0; line < HINT_LINES; line++) {
        const char *s = HINT[line];
        for (i = 0; s[i] && i < FB_WIDTH / 8; i++) {
            draw_char(dst, i * 8, y0 + 4 + line * 16,
                      (unsigned char)s[i], 0xFFFFFFFFu, 0xFF101010u);
        }
    }
}

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

    draw_hint(d, dst);
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
