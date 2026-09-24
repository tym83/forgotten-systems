#!/bin/bash
# Полный замер по ТРЁМ конфигурациям проверки границ массивов:
#   A — проверок нет вообще (check := FALSE)
#   B — программные проверки (сток: CMP + BLR, 2 слова / 2 такта)
#   C — аппаратные проверки (CHK, 1 слово / 1 такт)
#
# Две стадии обязательны. Прямое сравнение компиляторов A/B/C меряет не цену
# проверок, а то, сколько работы компилятор тратит на их ГЕНЕРАЦИЮ.
# Поэтому: стадия 2 — каждым компилятором пересобрать компилятор (тогда проверки
# окажутся или не окажутся внутри двоичного кода), и только потом прогнать
# полученными компиляторами одну и ту же нагрузку.
set -e
P="$(cd "$(dirname "$0")/.." && pwd)"; NB="$P/ext/norebo"
COMP="ORS.Mod ORB.Mod ORG.Mod ORP.Mod"
LOAD="${*:-Texts.Mod Fonts.Mod Files.Mod Modules.Mod Oberon.Mod}"

for cfg in A B E; do
  d="$P/build/s2$cfg"; rm -rf "$d"; mkdir -p "$d"; cd "$d"
  [ -f "$P/build/cfg$cfg/ORG.Mod" ] && cp "$P/build/cfg$cfg/ORG.Mod" .
  args=""; for m in $COMP; do args="$args $m/s"; done
  NOREBO_PATH="$d:$P/build/cfg$cfg:$NB/Norebo:$NB/Oberon:$NB/build2" \
    "$NB/norebo.bin" ORP.Compile $args > "$d/build.log" 2>&1
done

echo "нагрузка: $LOAD"
for cfg in A B E; do
  d="$P/build/r2$cfg"; rm -rf "$d"; mkdir -p "$d"; cd "$d"
  args=""; for m in $LOAD; do args="$args $m/s"; done
  NOREBO_CYCLES=1 NOREBO_PATH="$P/build/s2$cfg:$NB/Norebo:$NB/Oberon:$NB/build2" \
    "$NB/norebo.bin" ORP.Compile $args > "$d/run.log" 2>&1
done

python3 - "$P/build" <<'PY'
import re, sys, pathlib
b = pathlib.Path(sys.argv[1])
def get(c):
    t = (b/f"r2{c}"/"run.log").read_text(errors="replace")
    m = re.search(r"CYCLES (\d+) INSNS (\d+)", t)
    code = sum(int(x) for x in re.findall(r"^\s+compiling \w+\s+(\d+)", t, re.M))
    return (int(m.group(1)), int(m.group(2)), code) if m else (None,)*3
A, B_, C = get("A"), get("B"), get("E")
names = {"A": "нет проверок", "B": "программные", "E": "аппаратные (CHK)"}
print(f"\n{'конфигурация':<20}{'такты':>14}{'инструкции':>14}{'код, слов':>12}")
print("-"*60)
for k, v in (("A",A), ("B",B_), ("E",C)):
    print(f"{names[k]:<20}{v[0]:>14,}{v[1]:>14,}{v[2]:>12,}")
print("-"*60)
print(f"\nЦЕНА ПРОВЕРОК относительно конфигурации без них:")
for k, v in (("B",B_), ("E",C)):
    print(f"  {names[k]:<18} такты +{100*(v[0]-A[0])/A[0]:>5.2f}%   "
          f"инстр. +{100*(v[1]-A[1])/A[1]:>5.2f}%   код +{100*(v[2]-A[2])/A[2]:>5.2f}%")
print(f"\nЧТО ДАЁТ АППАРАТНАЯ ПОДДЕРЖКА (C против B):")
print(f"  такты      {B_[0]-C[0]:>10,}  = {100*(B_[0]-C[0])/B_[0]:.2f}% всей нагрузки")
print(f"  инструкции {B_[1]-C[1]:>10,}  = {100*(B_[1]-C[1])/B_[1]:.2f}%")
print(f"  код, слов  {B_[2]-C[2]:>10,}  = {100*(B_[2]-C[2])/B_[2]:.2f}%")
PY
