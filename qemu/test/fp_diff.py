#!/usr/bin/env python3
"""Сверка плавающей точки с эталоном.

Блок Вирта — не IEEE 754: округление прибавлением единицы, обращение в ноль
вместо подпороговых, бесконечность только от деления на ноль. Проверять его
«здравым смыслом» нельзя, только сличением с тем, что делает схема.

Эталон — ext/refemu/risc-fp.c, уже сверенный с настоящим описанием схемы.

  fp_diff.py <вывод машины> <эталонные значения>

Набор покрывает нули обоих знаков, единицу, степени двойки, наибольшее
конечное, наименьшее нормальное, подпороговое, бесконечность и мусор.
"""
import struct, sys, pathlib

VALS = [0x00000000, 0x80000000, 0x3F800000, 0xBF800000, 0x40000000, 0x40490FDB,
        0x7F7FFFFF, 0x00800000, 0x00000001, 0x41200000, 0xC1200000, 0x3DCCCCCD,
        0x4B000000, 0x33D6BF95, 0x7F800000, 0x00000002]


def main(out_path, exp_path):
    raw = pathlib.Path(out_path).read_bytes()
    got = list(struct.unpack('<%dI' % (len(raw) // 4), raw))

    exp = {}
    for line in pathlib.Path(exp_path).read_text().splitlines():
        x, y, op, r = line.split()
        exp[(x, y, op)] = r

    ok = bad = 0
    shown = []
    k = 0

    def check(key, label):
        nonlocal ok, bad, k
        want = exp[key]
        have = f'{got[k]:08X}'
        k += 1
        if want == have:
            ok += 1
        else:
            bad += 1
            if len(shown) < 5:
                shown.append(f'  {label}: ждали {want}, вышло {have}')

    for i in VALS:
        for j in VALS:
            for op in ('ADD', 'SUB', 'MUL', 'DIV'):
                check((f'{i:08X}', f'{j:08X}', op), f'{i:08X} {op} {j:08X}')
    # ⚠ У переводов второй операнд — НОЛЬ, а не то же число. Первая проверка
    # подавала одно и то же дважды и дала 24 ложных расхождения.
    for i in VALS:
        for op in ('FLT', 'FLR'):
            check((f'{i:08X}', '00000000', op), f'{i:08X} {op}')

    print(f'сверено случаев: {ok + bad}')
    if bad:
        print(f'❌ расхождений: {bad}')
        print('\n'.join(shown))
        return 1
    print('✅ все совпали с эталоном')
    return 0


if __name__ == '__main__':
    sys.exit(main(*sys.argv[1:3]))
