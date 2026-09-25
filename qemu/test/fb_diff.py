#!/usr/bin/env python3
"""Сверка кадрового буфера QEMU с эталонной машиной на настоящем RTL.

Смотреть на картинку глазами — слабая проверка: глаз не заметит сдвига на
строку или перевёрнутого бита в редко используемом шрифте. Поэтому сравниваем
байты: 98 304 байта кадрового буфера после загрузки системы должны совпасть
с точностью до бита.

  fb_diff.py <снимок из QEMU> <снимок с RTL>
"""
import sys, pathlib


def main(qemu_fb, rtl_fb):
    q = pathlib.Path(qemu_fb).read_bytes()
    r = pathlib.Path(rtl_fb).read_bytes()

    if len(q) != len(r):
        print(f'❌ размеры не совпали: QEMU {len(q)}, RTL {len(r)}')
        return 1
    if q == r:
        ink = sum(bin(b).count('1') for b in q)
        print(f'✅ кадровые буферы совпали побайтово ({len(q)} байт)')
        print(f'   чёрных точек на экране: {ink}')
        return 0

    diff = sum(1 for a, b in zip(q, r) if a != b)
    first = next(i for i, (a, b) in enumerate(zip(q, r)) if a != b)
    print(f'❌ различий {diff} байт из {len(q)}, первое по смещению 0x{first:X}')
    return 1


if __name__ == '__main__':
    sys.exit(main(*sys.argv[1:3]))
