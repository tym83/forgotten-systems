#!/usr/bin/env python3
"""Сборка сценария ввода для soc_tb из простых команд.

Язык описания (по строке на шаг):
  at <N>            установить текущий момент (номер инструкции)
  wait <N>          сдвинуть текущий момент на N инструкций вперёд
  click <x> <y> <b> щелчок: подвести, нажать, отпустить (b: L, M, R)
  move <x> <y>      просто подвести указатель
  type <текст>      набрать текст на клавиатуре
  enter             нажать Return
  shot <файл>       снять экран
Координата y задаётся как на картинке (сверху вниз) и переводится в систему
Оберона (снизу вверх) здесь же — чтобы в сценариях писать то, что видно глазом.
"""
import sys
from keymap import keys

BTN = {"L": 4, "M": 2, "R": 1}          # элементы множества keys из Input.Mod
HOLD, SETTLE = 200_000, 400_000         # удержание кнопки и пауза после

def build(lines):
    t, out = 0, []
    for ln in lines:
        ln = ln.split("#")[0].strip()
        if not ln: continue
        op, _, rest = ln.partition(" ")
        if op == "at":     t = int(rest)
        elif op == "wait": t += int(rest)
        elif op == "move":
            x, y = map(int, rest.split()); out.append(f"{t} M {x} {767-y} 0")
        elif op == "click":
            x, y, b = rest.split()
            x, y = int(x), 767 - int(y)
            out += [f"{t} M {x} {y} 0",
                    f"{t+HOLD} M {x} {y} {BTN[b]}",
                    f"{t+2*HOLD} M {x} {y} 0"]
            t += 2*HOLD + SETTLE
        elif op == "type":
            for c in keys(rest): out.append(f"{t} K {c}")
            t += SETTLE
        elif op == "enter":
            for c in keys("\r"): out.append(f"{t} K {c}")
            t += SETTLE
        elif op == "shot": out.append(f"{t} S {rest}")
        else: sys.exit(f"неизвестная команда: {op}")
    return out

if __name__ == "__main__":
    src = open(sys.argv[1]).read().splitlines()
    print("\n".join(build(src)))
