/*
 * Клавиатура и мышь машины Оберона.
 *
 * Клавиатура в железе — приёмник PS/2 с очередью на 16 байт (PS2.v).
 * Признак «байт есть» отдаётся битом 28 порта 6, сам байт читается из порта 7,
 * и чтение снимает его с очереди (RISC5Top.v:131 — doneKbd = rd & ioenb &
 * iowadr == 7).
 *
 * Коды не выдумываются: QEMU умеет переводить свои обозначения клавиш в набор
 * 2 PS/2 таблицами qcode → linux → atset2, и это ровно то, что понимает
 * Input.Mod. Свою таблицу писать нельзя — она разошлась бы с системой на
 * редких клавишах, и обнаружилось бы это нескоро.
 *
 * Мышь отдаётся одним словом (MousePM.v:36):
 *   out = {run, btns, 2'b0, y, 2'b0, x}
 * то есть x в битах 9:0, y в 21:12, кнопки в 26:24. Начало координат внизу
 * слева, поэтому экранный y переворачивается.
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
#include "qemu/osdep.h"
#include "ui/console.h"
#include "ui/input.h"
#include "oberon-io.h"

#define FB_WIDTH  1024
#define FB_HEIGHT  768

static void kbd_push(OberonIOState *s, uint8_t code)
{
    int next = (s->kbd_head + 1) % OBERON_KBD_FIFO;

    if (next == s->kbd_tail) {
        return;                     /* очередь переполнена — как в железе */
    }
    s->kbd_fifo[s->kbd_head] = code;
    s->kbd_head = next;
}

static void oberon_key_event(DeviceState *dev, QemuConsole *src,
                             QemuInputEvent *evt)
{
    OberonIOState *s = (OberonIOState *)dev;
    uint16_t set2;

    /*
     * evt->key.key — уже код linux, перевод нужен ровно один: в набор 2 PS/2.
     * Так же поступает ps2.c (строка 506), и таблица берётся та же самая.
     */
    if (evt->key.key >= qemu_input_map_linux_to_atset2_len) {
        return;
    }
    set2 = qemu_input_map_linux_to_atset2[evt->key.key];
    if (set2 == 0) {
        return;
    }

    /*
     * Расширенные коды идут с приставкой 0xE0, отпускание — с 0xF0 перед
     * самим кодом. Порядок важен: приставка расширения раньше признака
     * отпускания, иначе Input.Mod разберёт не ту клавишу.
     */
    if (set2 & 0xFF00) {
        kbd_push(s, set2 >> 8);
    }
    if (!evt->key.down) {
        kbd_push(s, 0xF0);
    }
    kbd_push(s, set2 & 0xFF);
}

static void oberon_mouse_event(DeviceState *dev, QemuConsole *src,
                               QemuInputEvent *evt)
{
    OberonIOState *s = (OberonIOState *)dev;

    switch (evt->type) {
    case INPUT_EVENT_KIND_ABS: {
        int v = qemu_input_scale_axis(evt->abs.value, INPUT_EVENT_ABS_MIN,
                                      INPUT_EVENT_ABS_MAX, 0,
                                      evt->abs.axis == INPUT_AXIS_X
                                      ? FB_WIDTH : FB_HEIGHT);
        if (evt->abs.axis == INPUT_AXIS_X) {
            s->mouse_x = v;
        } else {
            /* Начало координат у машины внизу слева. */
            s->mouse_y = FB_HEIGHT - 1 - v;
        }
        break;
    }
    case INPUT_EVENT_KIND_BTN: {
        int bit;

        /*
         * Оберону кнопки нужны ОДНОВРЕМЕННО: его межкнопочные щелчки —
         * это нажать одну, не отпуская добавить другую. Поэтому держим
         * набор, а не последнее событие.
         */
        switch (evt->btn.button) {
        case INPUT_BUTTON_LEFT:   bit = 4; break;
        case INPUT_BUTTON_MIDDLE: bit = 2; break;
        case INPUT_BUTTON_RIGHT:  bit = 1; break;
        default: return;
        }
        if (evt->btn.down) {
            s->mouse_btn |= bit;
        } else {
            s->mouse_btn &= ~bit;
        }
        break;
    }
    default:
        return;
    }

    s->mouse = (s->mouse_btn & 7) << 24 |
               (s->mouse_y & 0xFFF) << 12 |
               (s->mouse_x & 0xFFF);
}

static const QemuInputHandler oberon_kbd_handler = {
    .name  = "Oberon keyboard",
    .mask  = INPUT_EVENT_MASK_KEY,
    .event = oberon_key_event,
};

static const QemuInputHandler oberon_mouse_handler = {
    .name  = "Oberon mouse",
    .mask  = INPUT_EVENT_MASK_BTN | INPUT_EVENT_MASK_ABS,
    .event = oberon_mouse_event,
};

void oberon_input_init(OberonIOState *s)
{
    s->kbd_head = s->kbd_tail = 0;
    s->mouse_x = FB_WIDTH / 2;
    s->mouse_y = FB_HEIGHT / 2;
    s->mouse_btn = 0;
    s->mouse = (s->mouse_y & 0xFFF) << 12 | (s->mouse_x & 0xFFF);

    /* Возвращаемые состояния держим: без этого сборка считает их потерей. */
    s->kbd_handler = qemu_input_handler_register((DeviceState *)s,
                                                 &oberon_kbd_handler);
    s->mouse_handler = qemu_input_handler_register((DeviceState *)s,
                                                   &oberon_mouse_handler);
}
