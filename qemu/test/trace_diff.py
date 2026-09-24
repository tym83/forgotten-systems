#!/usr/bin/env python3
"""Пошаговая сверка qemu-system-risc5 с эталонным эмулятором.

Эталон — тот же, что сверялся с настоящим RTL на 15 млн инструкций, так что
совпадение здесь означает совпадение с железом, а не с нами самими.

Две тонкости, каждая однажды дала ложный результат:

1. У эталона ПЗУ лежит по другому адресу (0xFFFFF800 против нашего 0xFFE000) —
   это записано находкой 14. Сравнивать надо смещения от начала ПЗУ.

2. QEMU по умолчанию пишет состояние перед входом в БЛОК трансляции, а блок
   бывает длиннее одной команды: в плотном на переходы коде ПЗУ блоки были по
   одной команде и всё сходилось, а в коде системы трасса начала «пропускать»
   команды. Нужен режим one-insn-per-tb=on.
"""
import re, pathlib, sys

Q_ROM, R_ROM = 0xFFE000, 0xFFFFF800


def norm(pc, rom_base):
    return ('ПЗУ', pc - rom_base) if pc >= rom_base else ('ОЗУ', pc)


def main(qemu_trace, ref_trace):
    q = [norm(int(l, 16), Q_ROM)
         for l in pathlib.Path(qemu_trace).read_text().split()]
    r = [norm(int(m.group(1), 16), R_ROM) for m in
         (re.search(r'PC=([0-9A-F]+)', l)
          for l in pathlib.Path(ref_trace).read_text().splitlines()) if m]

    n = min(len(q), len(r))
    if n == 0:
        print('❌ одна из трасс пуста'); return 1

    for i in range(n):
        if q[i] != r[i]:
            print(f'❌ расхождение на команде {i}')
            for j in range(max(0, i - 4), min(n, i + 2)):
                mark = '  <<<' if j == i else ''
                print(f'  {j:7}  эталон {r[j][0]}+{r[j][1]:05X}'
                      f'   QEMU {q[j][0]}+{q[j][1]:05X}{mark}')
            return 1

    ram = sum(1 for x in q[:n] if x[0] == 'ОЗУ')
    print(f'✅ совпали на всех {n} командах')
    print(f'   из них в ОЗУ (код системы, а не загрузчика): {ram}')
    print(f'   разных адресов пройдено: {len(set(q[:n]))}')
    return 0


if __name__ == '__main__':
    sys.exit(main(*sys.argv[1:3]))
