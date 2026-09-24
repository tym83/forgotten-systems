#!/usr/bin/env python3
"""Систематический перебор пространства кодирования.

Замкнутый круг на настоящем выводе компилятора (tools/roundtrip.py) проверяет
только те формы, которые компилятор действительно излучает, и слаб там, где
реальный код однообразен: например перестановку полей a и b он ловит плохо,
потому что в накопительном стиле a и b часто совпадают.

Здесь перебор идёт по структуре, а не по встреченному:
Перебор идёт СО СТОРОНЫ АССЕМБЛЕРА: систематически порождается текст (все
мнемоники x все регистры x граничные непосредственные и смещения), он
собирается в слово, слово дизассемблируется и собирается снова. Требуется
побитовое совпадение с первым словом.

Почему именно так. Если перебирать слова, то в них попадают безразличные биты:
например при op=0 (MOV) железо не читает поле b вовсе — `aluRes` в этой ветке
не обращается к B. Слово с непустым b исполняется как слово с нулевым, но
буквально не воспроизводится, и перебор тонет в ложных срабатываниях. Со
стороны ассемблера кодировка каноническая, и любое расхождение дизассемблера
с ассемблером — настоящее.

Отдельно печатается, какая доля структурно осмысленного пространства слов
вообще получает мнемонику: это честный размер неназванной части.
"""
import sys
sys.path.insert(0, "tools")
import asm
from disasm import disasm

IMM_EDGE  = [0, 1, -1, 0x7FFF, 0x8000, 0xFFFF, -0x8000, -0x8001, -0xFFFF, -0x10000]
OFF_EDGE  = [0, 1, -1, 0x7FFFF, -0x80000, 0x55555]
DISP_EDGE = [0, 1, -1, (1 << 21) - 1, -(1 << 21), 0x155555]
EDGE16 = [0, 1, 2, 0x7FFF, 0x8000, 0xFFFE, 0xFFFF, 0x5555, 0xAAAA]
EDGE20 = [0, 1, 0x7FFFF, 0x80000, 0xFFFFF, 0x55555, 0xAAAAA]
EDGE24 = [0, 1, 0x7FFFFF, 0x800000, 0xFFFFFF, 0x555555, 0xAAAAAA]
REGS = range(16)


def sources():
    """Систематический текст: все формы, все регистры, граничные значения."""
    for op in sorted(asm.OPS):
        if op == 'MOV':        # у MOV своя форма, перебирается ниже
            continue
        for a in REGS:
            for b in REGS:
                for c in REGS:
                    yield f'{op} R{a}, R{b}, R{c}'
                for n in IMM_EDGE:
                    yield f'{op} R{a}, R{b}, {n}'
    for op in sorted(asm.ALIAS):
        for a in REGS:
            for b in REGS:
                for c in REGS:
                    yield f'{op} R{a}, R{b}, R{c}'
    # формы с битами u/v без отдельного имени
    for op in sorted(asm.OPS):
        if op == 'MOV':
            continue
        for suf in ('.u', '.v', '.uv'):
            for a in REGS:
                for b in REGS:
                    for c in REGS:
                        yield f'{op}{suf} R{a}, R{b}, R{c}'
                    # бит v задан суффиксом, поэтому знак непосредственного
                    # обязан ему соответствовать
                    for n in (IMM_EDGE if suf == '.u' else
                              [x for x in IMM_EDGE if x < 0]):
                        if suf == '.u' and n < 0:
                            continue
                        yield f'{op}{suf} R{a}, R{b}, {n}'
    for a in REGS:
        for c in REGS:
            yield f'MOV R{a}, R{c}'
        for n in IMM_EDGE:
            yield f'MOV R{a}, {n}'
        for n in (0, 1, 0x7FFF, 0x8000, 0xFFFF, 0x5555):
            yield f'MHI R{a}, 0x{n:04X}'
        yield f'MOV R{a}, H'
        yield f'MOV R{a}, NZCV'
        for mn in ('LD', 'LDB', 'ST', 'STB'):
            for b in REGS:
                for off in OFF_EDGE:
                    yield f'{mn} R{a}, R{b}, {off}'
    for cond in sorted(asm.COND):
        for link in ('', 'L'):
            mn = 'B' + link + cond
            for c in REGS:
                yield f'{mn} R{c}'
                # нечётная нагрузка без связи декодируется как RTI — такие
                # формы ассемблер отвергает, перебирать их здесь нечего
                pays = (1, 0x7FFFF, 0xFFFFF, 0x55555) if link else \
                       (2, 0x7FFFE, 0xFFFFE, 0x55554)
                for pay in pays:
                    yield f'{mn} R{c}, 0x{pay:05X}'
            for off in DISP_EDGE:
                yield f'{mn} {off}'


def words():
    for u in (0, 1):
        for v in (0, 1):
            for op in range(16):
                for a in REGS:
                    for b in REGS:
                        for c in REGS:               # F0
                            yield ((u << 1 | v) << 28) | (a << 24) | (b << 20) | (op << 16) | c
                    for n in EDGE16:                 # F1
                        yield (0b0100 | u << 1 | v) << 28 | (a << 24) | (a << 20) | (op << 16) | n
    for u in (0, 1):                                 # F2
        for v in (0, 1):
            for a in REGS:
                for off in EDGE20:
                    yield (0b1000 | u << 1 | v) << 28 | (a << 24) | (a << 20) | off
    for u in (0, 1):                                 # F3
        for v in (0, 1):
            for cond in range(16):
                if u == 0:
                    for c in REGS:
                        for pay in EDGE20:
                            yield 0b1100 << 28 | (u << 29) | (v << 28) | (cond << 24) | (pay << 4) | c
                else:
                    for off in EDGE24:
                        yield 0b1100 << 28 | (u << 29) | (v << 28) | (cond << 24) | off


def main():
    n_src = 0
    fails = []
    for src in sources():
        n_src += 1
        w = asm.assemble("        " + src + "\n", raw=True)[0][0]
        txt = disasm(w)
        if txt is None:
            fails.append((w, src, "дизассемблер не даёт мнемоники")); continue
        try:
            back = asm.assemble("        " + txt + "\n", raw=True)[0][0]
        except Exception as e:
            fails.append((w, f"{src} -> {txt}", f"не собралось: {e}")); continue
        if back != w:
            fails.append((w, f"{src} -> {txt}", f"-> {back:08X}"))

    total = named = 0
    for w in words():
        total += 1
        named += disasm(w & 0xFFFFFFFF) is not None
    print(f"  форм от ассемблера: {n_src}, круг замкнулся на "
          f"{n_src - len(fails)}")
    print(f"  покрытие слов:      {named} из {total} структурных слов "
          f"получают мнемонику ({100.0*named/total:.1f}%)")
    if fails:
        print(f"\n❌ круг не замкнулся на {len(fails)} формах")
        for w, txt, why in fails[:10]:
            print(f"    {w:08X}  {txt}  {why}")
        if len(fails) > 10:
            print(f"    ... и ещё {len(fails)-10}")
        return 1
    print(f"\n✅ все {n_src} форм проходят круг ассемблер→дизассемблер→ассемблер")
    return 0


if __name__ == "__main__":
    sys.exit(main())
