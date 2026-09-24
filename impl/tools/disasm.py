#!/usr/bin/env python3
"""Дизассемблер RISC5, снятый с RISC5.v.

Поля и признаки форматов взяты из самого декодера в железе:
  p=IR[31] q=IR[30] u=IR[29] v=IR[28]
  a=IR[27:24] b=IR[23:20] op=IR[19:16] c=IR[3:0]
  imm=IR[15:0] (F1)  off=IR[19:0] (F2)  disp=IR[21:0] (F3, см. ниже)
  C1 = q ? {{16{v}}, imm} : C0        — v задаёт заполнение старшей половины
  LDR = p&~q&~u   STR = p&~q&u   BR = p&q

Пишет текст в том синтаксисе, который принимает tools/asm.py, — чтобы
дизассемблирование и обратная сборка образовывали замкнутый круг.

Смещение перехода печатается как 24 бита со знаком: столько излучает
ORG.Mod (`off MOD 1000000H`). Железо читает только 22 — см. находку 24.
"""
import sys

MNEMO = ['MOV', 'LSL', 'ASR', 'ROR', 'AND', 'ANN', 'IOR', 'XOR',
         'ADD', 'SUB', 'MUL', 'DIV', 'FAD', 'FSB', 'FML', 'FDV']
U_FORM = {8: 'ADC', 9: 'SBC', 10: 'UMUL', 11: 'UDIV'}
# Суффиксы для форм, у которых u/v не имеют отдельного имени. Для большинства
# операций эти биты железо не читает (tests/t1_dontcare.s), кодировку сохраняем
# ради точного воспроизведения.
SUF = {(1, 0): '.u', (0, 1): '.v', (1, 1): '.uv'}
COND = ['MI', 'EQ', 'CS', 'VS', 'LS', 'LT', 'LE', '',
        'PL', 'NE', 'CC', 'VC', 'HI', 'GE', 'GT', 'NV']


def sx(v, bits):
    return v - (1 << bits) if v & (1 << (bits - 1)) else v


def disasm(w):
    w &= 0xFFFFFFFF
    p, q, u, v = (w >> 31) & 1, (w >> 30) & 1, (w >> 29) & 1, (w >> 28) & 1
    a, b, op, c = (w >> 24) & 0xF, (w >> 20) & 0xF, (w >> 16) & 0xF, w & 0xF
    imm = w & 0xFFFF

    if p == 0:                                   # F0 / F1 — регистровый класс
        if op == 0:                              # MOV во всех видах
            if q == 0:
                if u == 0:   return f'MOV R{a}, R{c}'
                return f'MOV R{a}, H' if v == 0 else f'MOV R{a}, NZCV'
            if u == 1:       return f'MHI R{a}, 0x{imm:04X}'
            return f'MOV R{a}, {imm if v == 0 else imm - 0x10000}'

        # Короткое имя даётся только там, где бит действительно значим и форма
        # названа: ADC/SBC/UMUL/UDIV при u=1,v=0 и FLT/FLOOR у сумматора.
        # Всё остальное получает суффикс, иначе бит v терялся бы при разборе.
        if u == 1 and v == 0 and op in U_FORM:   name = U_FORM[op]
        elif op == 12 and (u, v) == (1, 0):      name = 'FLT'
        elif op == 12 and (u, v) == (0, 1):      name = 'FLOOR'
        elif (u, v) != (0, 0):                   name = MNEMO[op] + SUF[(u, v)]
        else:                                    name = MNEMO[op]

        if q == 0:
            return f'{name} R{a}, R{b}, R{c}'
        n = imm if v == 0 else imm - 0x10000
        return f'{name} R{a}, R{b}, {n}'

    if q == 0:                                   # F2 — обращение к памяти
        mn = ('ST' if u else 'LD') + ('B' if v else '')
        return f'{mn} R{a}, R{b}, {sx(w & 0xFFFFF, 20)}'

    # F3 — переходы
    if u == 0 and v == 0 and (w >> 4) & 1:       # BR & ~u & ~v & IR[4]
        return 'RTI'
    mn = 'B' + ('L' if v else '') + COND[a]
    if u == 1:
        return f'{mn} {sx(w & 0xFFFFFF, 24)}'
    pay = (w >> 4) & 0xFFFFF          # нагрузка ловушки: позиция и номер
    return f'{mn} R{c}' if pay == 0 else f'{mn} R{c}, 0x{pay:05X}'


if __name__ == '__main__':
    for arg in sys.argv[1:]:
        w = int(arg, 16)
        print(f'{w:08X}  {disasm(w) or "(без мнемоники)"}')
