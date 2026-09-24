#!/bin/bash
# Счётная нагрузка: цена проверок границ на коде с плотной индексацией массивов.
# Раньше эти числа снимались вручную и в репозитории не воспроизводились (найдено аудитом).
#
# ⚠ Ограничение, которое надо держать в голове: bench/ArrBench.Mod написан так, что
# ВСЕ его массивы попадают под аппаратную проверку. Это верхняя граница выигрыша,
# а не типичный случай. См. docs/FINDING-19-audit-corrections.md.
set -e
P="$(cd "$(dirname "$0")/.." && pwd)"; NB="$P/ext/norebo"
echo "нагрузка: bench/ArrBench.Mod (сортировка + умножение матриц)"
printf "%-4s %-52s %s\n" "кфг" "код" "такты"
for cfg in A B E; do
  d="$P/build/bench$cfg"; rm -rf "$d"; mkdir -p "$d"; cd "$d"
  cp "$P/bench/ArrBench.Mod" .
  NOREBO_PATH="$PWD:$P/build/s2$cfg:$NB/Norebo:$NB/Oberon:$NB/build2" \
    "$NB/norebo.bin" ORP.Compile ArrBench.Mod/s > compile.log 2>&1
  W=$(python3 "$P/tools/count_traps.py" ArrBench.rsc | tr -s ' ')
  NOREBO_CYCLES=1 NOREBO_PATH="$PWD:$P/build/s2$cfg:$NB/Norebo:$NB/Oberon:$NB/build2" \
    "$NB/norebo.bin" ArrBench.Run > run.log 2>&1 || true
  R=$(grep -oE "CYCLES [0-9]+ INSNS [0-9]+" run.log || echo "нет данных")
  printf "%-4s %-52s %s\n" "$cfg" "$W" "$R"
done
python3 - "$P/build" <<'PY'
import re, sys, pathlib
b = pathlib.Path(sys.argv[1])
def cyc(c):
    t = (b / f"bench{c}" / "run.log").read_text(errors="replace")
    m = re.search(r"CYCLES (\d+) INSNS (\d+)", t)
    return (int(m.group(1)), int(m.group(2))) if m else (None, None)
A, B_, E = cyc("A"), cyc("B"), cyc("E")
if not all(x[0] for x in (A, B_, E)):
    print("\nнет данных — смотри build/bench*/run.log"); sys.exit(1)
print(f"\n  без проверок   {A[0]:>12,} тактов")
print(f"  программные    {B_[0]:>12,}  +{100*(B_[0]-A[0])/A[0]:.2f}%")
print(f"  аппаратные     {E[0]:>12,}  +{100*(E[0]-A[0])/A[0]:.2f}%")
print(f"\n  аппаратура снимает {100*(B_[0]-E[0])/(B_[0]-A[0]):.1f}% цены проверок")
PY
