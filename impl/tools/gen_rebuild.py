#!/usr/bin/env python3
"""Сценарий полной пересборки системы Обероном внутри самой системы.

Порядок модулей выводится топологической сортировкой по IMPORT из исходников,
лежащих НА ОБРАЗЕ (а не из нашей копии 2019 года): компилятор внутри системы
читает именно их.

Модули собираются пачками. Одной командой всё сразу собрать нельзя: внутри
команды управление не возвращается в Oberon.Loop, сборщик мусора не работает,
и таблицы символов копятся до исчерпания кучи — на этом падал первый заход
самораскрутки компилятора (находка 23). Пачка выбрана малой, а четыре модуля
компилятора идут поодиночке: у них самые тяжёлые таблицы.
"""
import sys, pathlib
sys.path.insert(0, "tools")
import modorder
from oberonfs import Image

IMG = "ext/disk/Oberon-2016-08-02.dsk"
SKIP = {"BootLoad", "SmallPrograms", "Display.Orig", "Input.Orig"}
# Поодиночке: у компилятора самые тяжёлые таблицы символов, а RISC.Mod
# на этом образе вообще не компилируется (pos 926 bad divisor — константа
# 80000000H как делитель отрицательна для знакового INTEGER), и в пачке его
# отказ утащил бы за собой соседей.
ALONE = {"ORS", "ORB", "ORG", "ORP", "Texts", "Modules", "Display", "System", "RISC"}
XLOG, YLOG = 980, 6          # System.Clear в заголовке System.Log
BATCH = 3
ROW0, ROWH, XCMD = 569, 12, 690          # первая новая строка, высота, x команды


def main():
    src = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else None
    if src is None:
        sys.exit("укажите каталог с исходниками, выгруженными с образа")
    modorder.SRC = src
    order, _ = modorder.order()
    mods = [m for m in order if m not in SKIP]
    size = {m: (src / f"{m}.Mod").stat().st_size for m in mods}

    lines, i = [], 0
    while i < len(mods):
        if mods[i] in ALONE:
            lines.append([mods[i]]); i += 1
        else:
            grp = []
            while i < len(mods) and len(grp) < BATCH and mods[i] not in ALONE:
                grp.append(mods[i]); i += 1
            lines.append(grp)

    # Во вьюер System.Tool влезает около 15 новых строк. Растягивать его
    # System.Grow нельзя: он закрывает журнал, а без журнала отказ компиляции
    # не виден — файл просто останется прежним, и побайтовое сравнение
    # покажет «совпало». Поэтому режем на сессии, продолжающие один диск.
    PER = 11
    parts = [lines[i:i + PER] for i in range(0, len(lines), PER)]

    print(f"модулей к сборке: {len(mods)}, команд {len(lines)}, сессий {len(parts)}")
    for pi, part in enumerate(parts, 1):
        out = [f"# Пересборка системы, сессия {pi} из {len(parts)}: "
               f"{sum(len(g) for g in part)} модулей в {len(part)} командах.",
               "at 12000000", "click 700 620 L"]
        for k, grp in enumerate(part):
            out.append("type ORP.Compile " + " ".join(f"{m}.Mod/s" for m in grp) + " ~")
            if k != len(part) - 1:
                out.append("enter")
        out += ["wait 3000000", f"shot build/rb{pi}_typed.pbm"]
        # Оценка: компилятор (109 356 байт исходника) занял 40.8 млн инструкций.
        # Внутри системы добавляются файловые операции через модель SPI-диска,
        # поэтому берём четырёхкратный запас и не меньше 25 млн на команду.
        total = 20_000_000
        for k, grp in enumerate(part):
            b = sum(size[m] for m in grp)
            wait = max(25_000_000, int(b / 109356 * 40.8e6 * 4))
            # Журнал чистится после каждой команды: вьюер System.Log вмещает
            # около 18 строк и НЕ прокручивается сам, поэтому без очистки вывод
            # поздних команд просто не виден — а «не виден» и «не выполнялось»
            # снаружи неразличимы.
            out += [f"click {XCMD} {ROW0 + k * ROWH} M      # {' '.join(grp)}",
                    f"wait {wait}",
                    f"shot build/rb{pi}_c{k:02d}.pbm",
                    f"click {XLOG} {YLOG} M",
                    "wait 2000000"]
            total += wait + 4_000_000
        out.append(f"shot build/rb{pi}_done.pbm")
        open(f"scripts/rebuild{pi}.src", "w").write("\n".join(out) + "\n")
        print(f"  scripts/rebuild{pi}.src: бюджет {total:,} инструкций")
        for k, grp in enumerate(part):
            print(f"     строка {k:2d} (y={ROW0+k*ROWH}): {' '.join(grp)}")


if __name__ == "__main__":
    main()
