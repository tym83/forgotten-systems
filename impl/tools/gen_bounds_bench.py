#!/usr/bin/env python3
"""Нагрузка для центрального номера: индексация массива с проверкой границ.

Две сборки ОДНОГО И ТОГО ЖЕ тела цикла:

    B (сток)    SUB RH, i, lim ; BCC trap   — то, что эмитит ORG.Index сегодня
    E (железо)  CHKS i, lim                 — то же самое одной инструкцией

Всё остальное — вычисление адреса, чтение элемента, накопление — побайтово
одинаково. Разница в тактах и есть цена проверки границ, и ничего кроме неё.

⚠ Оба файла порождаются одним шаблоном. Две копии цикла разошлись бы при первой
же правке, и число стало бы сравнением двух разных программ — в этом
репозитории так уже было.

Программа кладётся в ПЗУ (ORG = 0x00FFE000), как все направленные тесты: машина
исполняет её прямо со сброса. Цикл заведомо длиннее бюджета замера: обе программы гоняются РОВНО одинаковое
число инструкций, а сделанные итерации читаются из счётчика R5. Так не нужно
ловить момент окончания — иначе в числа попадает холостой хвост, и разница
получается вдесятеро больше настоящей (проверено: так и вышло).
"""
import pathlib, sys

ORG      = 0x00FFE000
HANDLER  = ORG + 4          # обработчик стоит сразу за первой командой перехода
LIM      = 64               # размер массива; степень двойки — индекс заворачивается маской
ITER     = 1000000          # итераций цикла — заведомо больше бюджета замера
DONE     = 0x100            # адрес слова-сигнала
MAGIC    = 0xB0DE

HEAD = """; ПОРОЖДЁННЫЙ ФАЙЛ — правится tools/gen_bounds_bench.py, не руками.
;
; Индексация массива в цикле, {iter} итераций, предел {lim}.
; Конфигурация {cfg}: {what}
        B    start
handler:                       ; ловушка: сюда не должны попасть ни разу
        MOV  R7, 0x0BAD
        ST   R7, R0, {done_bad}
spin:   B    spin
start:
        MOV  R0, 0
        MOV  R1, 0             ; индекс
        MOV  R2, 0x1000        ; база массива
        MOV  R4, 0             ; накопитель
        MOV  R5, 0             ; счётчик итераций
        MHI  R5, 0x{iterhi:04X}
        IOR  R5, R5, 0x{iterlo:04X}
        MOV  R12, 0            ; MT — адрес обработчика ловушек
        MHI  R12, 0x{hi:04X}
        IOR  R12, R12, 0x{lo:04X}
loop:
"""

CHECK = {
    'B': "        SUB  R11, R1, {lim}    ; Cmp: индекс - предел, только ради флагов\n"
         "        BCC  handler           ; беззнаковое i >= lim -> ловушка\n",
    'E': "        CHKS R1, {lim}         ; то же самое одной командой\n",
}

TAIL = """        LSL  R10, R1, 2        ; адрес элемента
        ADD  R10, R2, R10
        LD   R3, R10, 0
        ADD  R4, R4, R3        ; полезная работа
        ADD  R1, R1, 1         ; следующий индекс, с заворотом
        AND  R1, R1, {mask}
        SUB  R5, R5, 1
        BNE  loop
        MOV  R6, 0x{magic:04X}
        ST   R6, R0, {done}
done:   B    done
"""

WHAT = {'B': 'проверка границ программная (SUB + BCC)',
        'E': 'проверка границ аппаратная (CHKS)'}


def emit(cfg):
    body = HEAD.format(iter=ITER, lim=LIM, cfg=cfg, what=WHAT[cfg],
                       done_bad=DONE + 4, hi=HANDLER >> 16, lo=HANDLER & 0xFFFF,
                       iterhi=ITER >> 16, iterlo=ITER & 0xFFFF)
    body += CHECK[cfg].format(lim=LIM)
    body += TAIL.format(mask=LIM - 1, magic=MAGIC, done=DONE)
    return body


def main():
    out = pathlib.Path(__file__).resolve().parent.parent / 'tests'
    for cfg, name in (('B', 'bench_bounds_b'), ('E', 'bench_bounds_e')):
        (out / f'{name}.s').write_text(emit(cfg), encoding='utf-8')
        print(f'  {name}.s — конфигурация {cfg}')
    # Параметры нужны и странице: держим их в одном месте, а не в двух.
    (out / 'bench_bounds.json').write_text(
        '{"org": %d, "iterations": %d, "limit": %d, "done": %d, "magic": %d,'
        ' "counter": 5, "budget": 2000000}\n'
        % (ORG, ITER, LIM, DONE, MAGIC), encoding='utf-8')
    print(f'  bench_bounds.json — {ITER} итераций, предел {LIM}')


if __name__ == '__main__':
    main()
