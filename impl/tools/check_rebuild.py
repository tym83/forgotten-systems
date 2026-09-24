#!/usr/bin/env python3
"""Проверка полной пересборки системы: неподвижная точка по объектным файлам.

Система пересобирается своим же компилятором внутри себя на RTL. Если компилятор
и исходники согласованы, порождённые объектные файлы обязаны совпасть с теми,
что лежали на образе, ПОБАЙТОВО.

Исключения перечислены явно и объяснены — иначе проверка выродится в «что
получилось, то и правильно».
"""
import sys
sys.path.insert(0, "tools")
from oberonfs import Image

# Модули, которые на этом образе НЕ компилируются. Это свойство образа, а не
# нашей машины: каждая причина проверена отдельно.
BROKEN = {
    "RISC":  "pos 926 bad divisor — константа 80000000H как делитель "
             "отрицательна для знакового INTEGER",
    "ORC":   "import not available — импортирует V24, которого на образе нет "
             "ни исходником, ни символьным файлом",
    "Net":   "incompatible parameters — сигнатуры вызовов SCC разошлись с "
             "SCC.Mod того же образа",
}

# ⚠ Побайтовое сравнение САМО ПО СЕБЕ не отличает «пересобрано и совпало» от
# «не трогали вовсе»: первая версия этой проверки зелено проходила на нетронутом
# образе. Поэтому ниже перечислены не «допустимые отличия», а ОБЯЗАТЕЛЬНЫЕ
# признаки того, что пересборка действительно состоялась. Их отсутствие —
# провал, а не послабление.
REQUIRE_DIFF = {
    "Math.rsc": "поставляемый двоичный файл устарел: на образе 449 слов кода, "
                "пересборка даёт 447 при том же ключе 32C32F12",
}
REQUIRE_NEW = {
    "PIO.rsc": "на образе отсутствовал вовсе",
    "PIO.smb": "на образе отсутствовал вовсе",
}


def main(before, after):
    a, b = Image(before), Image(after)
    fa, fb = a.files(), b.files()
    same, diff, new, gone = [], [], [], []
    for n in sorted(set(fa) | set(fb)):
        if n not in fa:
            new.append(n)
        elif n not in fb:
            gone.append(n)
        elif a.read(fa[n]) == b.read(fb[n]):
            same.append(n)
        else:
            diff.append(n)

    rsc_same = [n for n in same if n.endswith(".rsc")]
    print(f"  файлов: было {len(fa)}, стало {len(fb)}")
    print(f"  объектных файлов совпало побайтово: {len(rsc_same)}")

    bad = []
    for n in diff:
        if n in REQUIRE_DIFF:
            print(f"  ожидаемое отличие {n}: {REQUIRE_DIFF[n]}")
        else:
            bad.append(f"неожиданно изменился {n}")
    for n in new:
        if n in REQUIRE_NEW:
            print(f"  ожидаемо появился {n}: {REQUIRE_NEW[n]}")
        else:
            bad.append(f"неожиданно появился {n}")
    for n in gone:
        bad.append(f"пропал {n}")

    # Главная проверка: объектные файлы собранных модулей обязаны совпасть.
    for n in sorted(fa):
        if not n.endswith(".rsc"):
            continue
        mod = n[:-4]
        if mod in BROKEN or n in REQUIRE_DIFF:
            continue
        if n not in same:
            bad.append(f"{n} не совпал, хотя модуль собирается")

    for mod, why in BROKEN.items():
        print(f"  не собирается {mod}: {why}")

    # Положительные признаки: без них сравнение ничего не доказывает.
    for n in REQUIRE_NEW:
        if n not in new:
            bad.append(f"{n} НЕ появился — значит пересборка не выполнялась "
                       f"(на исходном образе этого файла нет)")
    for n in REQUIRE_DIFF:
        if n not in diff:
            bad.append(f"{n} НЕ изменился — значит пересборка не выполнялась "
                       f"(поставляемый файл устарел и обязан отличаться)")
    if len(rsc_same) < 35:
        bad.append(f"совпавших объектных файлов всего {len(rsc_same)}")

    if bad:
        print("\n❌ пересборка не сошлась:")
        for x in bad:
            print("   ", x)
        return 1
    print(f"\n✅ НЕПОДВИЖНАЯ ТОЧКА СИСТЕМЫ: {len(rsc_same)} объектных файлов "
          f"пересобраны побайтово идентично")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1], sys.argv[2]))
