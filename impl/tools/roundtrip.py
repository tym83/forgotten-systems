#!/usr/bin/env python3
"""Замкнутый круг на настоящем выводе компилятора Вирта.

Берём объектные файлы, порождённые ORG.Mod, и для каждого слова кода:
  слово -> дизассемблер (снят с RISC5.v) -> наш ассемблер -> слово
Требуем побитового совпадения.

Что это доказывает: наш ассемблер покрывает ровно то пространство кодирования,
которым пользуется настоящий компилятор, и воспроизводит каждую его инструкцию
бит в бит, включая безразличные биты.

Чего это НЕ доказывает: правильность раскладки полей — дизассемблер и ассемблер
пользуются одной и той же раскладкой, и общая ошибка в ней здесь не видна.
Раскладку проверяют 260 направленных тестов на железе, где результат сверяется
с архитектурной семантикой, а не с нашим же представлением о ней.
"""
import sys, collections
sys.path.insert(0, "tools")
import asm, rsc
from disasm import disasm


def run(paths):
    total = bad = unnamed = 0
    forms = collections.Counter()
    fails = []
    for p in paths:
        m = rsc.parse(p)
        for i, w in enumerate(m["code"]):
            total += 1
            txt = disasm(w)
            if txt is None:
                unnamed += 1
                forms["(без мнемоники)"] += 1
                fails.append((p, i, w, "нет мнемоники"))
                continue
            forms[txt.split()[0]] += 1
            try:
                back = asm.assemble("        " + txt + "\n", raw=True)[0][0]
            except Exception as e:
                bad += 1
                fails.append((p, i, w, f"не собралось: {e}"))
                continue
            if back != w:
                bad += 1
                fails.append((p, i, w, f"{txt} -> {back:08X}"))
    print(f"  слов кода: {total}, разных мнемоник: {len(forms)}")
    print("  " + "  ".join(f"{k}:{v}" for k, v in forms.most_common(12)))
    if fails:
        print(f"\n❌ не воспроизведено: {len(fails)}")
        for p, i, w, why in fails[:12]:
            print(f"    {p.split('/')[-1]}[{i}] {w:08X}  {why}")
        if len(fails) > 12:
            print(f"    ... и ещё {len(fails) - 12}")
        return 1
    print(f"\n✅ все {total} слов настоящего компилятора воспроизведены бит в бит")
    return 0


if __name__ == "__main__":
    sys.exit(run(sys.argv[1:]))
