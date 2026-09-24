#!/bin/bash
# ЗАМЫКАНИЕ КРУГА: компилятор Оберона собирает сам себя на настоящем RTL,
# и результат сверяется побайтово с эмулятором.
set -e
P="$(cd "$(dirname "$0")/.." && pwd)"; NB="$P/ext/norebo"
MODS="${*:-ORS.Mod ORB.Mod ORG.Mod ORP.Mod}"

for w in rtl emu; do
  d="$P/build/self_$w"; rm -rf "$d"; mkdir -p "$d"; cd "$d"
  args=""; for m in $MODS; do args="$args $m/s"; done
  if [ "$w" = rtl ]; then bin="$P/build/obj_nb/norebo_tb"; else bin="$NB/norebo.bin"; fi
  NOREBO_PATH="$PWD:$NB/Norebo:$NB/Oberon:$NB/build2" "$bin" ORP.Compile $args > log.txt 2>&1
done

echo "модули: $MODS"
echo
grep -E "выполнено на RTL" "$P/build/self_rtl/log.txt" || true
echo
printf "%-10s %-34s %s\n" "модуль" "контрольная сумма" "совпадение"
echo "------------------------------------------------------------"
fail=0
for m in $MODS; do
  n="${m%.Mod}"
  a=$(md5 -q "$P/build/self_rtl/$n.rsc" 2>/dev/null || echo "нет")
  b=$(md5 -q "$P/build/self_emu/$n.rsc" 2>/dev/null || echo "нет")
  if [ "$a" = "$b" ] && [ "$a" != "нет" ]; then s="✅"; else s="❌"; fail=1; fi
  printf "%-10s %-34s %s\n" "$n" "$a" "$s"
done
echo
if [ $fail -eq 0 ]; then
  echo "✅ КРУГ ЗАМКНУТ: компилятор Оберона на ядре RISC5.v Вирта даёт"
  echo "   побайтово тот же код, что эмулятор на C."
else
  echo "❌ есть расхождения"; exit 1
fi
