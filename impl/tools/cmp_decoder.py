#!/usr/bin/env python3
"""Сравнивает таблицы декодера двух ядер и показывает, какие кодировки различаются."""
import sys, collections
def load(p):
    d = {}
    for line in open(p):
        if line.startswith("#"): continue
        f = line.split()
        d[(f[0], f[1], f[2])] = tuple(f[3:])
    return d
a, b = load(sys.argv[1]), load(sys.argv[2])
diff = collections.defaultdict(list)
for k in sorted(a):
    if a[k] != b[k]: diff[(k[0], k[1])].append(k[2])   # k[2] = "<поле a>.<набор>"
print(f"комбинаций проверено: {len(a)}  ({len(set((k[0],k[1]) for k in a))} кодировок × 16 значений поля a × 5 наборов операндов)")
if not diff:
    print("расхождений НЕТ ❌ — новая инструкция не декодируется, что тоже ошибка")
    sys.exit(1)
print(f"\nразличающихся кодировок: {len(diff)}")
for (nib, op), sets in sorted(diff.items()):
    print(f"  IR[31:28]={int(nib,16):04b}  op={int(op,16):<2}  различий: {len(sets)} из 80 (16 значений a × 5 наборов)")
expect = {("1", "1")}
got = set(diff.keys())
print()
if got == expect:
    print("✅ различается РОВНО ожидаемая кодировка (0001, op=1) — это CHK")
    sys.exit(0)
print(f"❌ ожидалось {sorted(expect)}, получено {sorted(got)}")
sys.exit(1)
