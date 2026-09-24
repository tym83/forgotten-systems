#!/bin/bash
# ДИНАМИЧЕСКАЯ цена проверок времени исполнения.
#
# Ловушка, в которую я сначала попал: если прогнать компиляторы cfgA и cfgB,
# то разница в тактах отражает лишь то, что cfgA НЕ ГЕНЕРИРУЕТ проверки,
# то есть делает меньше работы. Это не цена проверок при исполнении.
#
# Правильно: нужна ВТОРАЯ стадия. Компилятором cfgA собрать компилятор заново ->
# получится двоичный код БЕЗ проверок внутри. Тем же способом через cfgB -> С проверками.
# Затем обоими полученными компиляторами скомпилировать ОДНУ И ТУ ЖЕ нагрузку
# и сравнить такты. Тогда разница — это ровно исполнение проверок.
set -e
P="$(cd "$(dirname "$0")/.." && pwd)"; NB="$P/ext/norebo"
COMP="ORS.Mod ORB.Mod ORG.Mod ORP.Mod"
LOAD="${*:-Texts.Mod Fonts.Mod Files.Mod Modules.Mod Oberon.Mod}"

# --- стадия 2: пересобрать компилятор компилятором из cfgX
for cfg in A B; do
  d="$P/build/stage2$cfg"; rm -rf "$d"; mkdir -p "$d"; cd "$d"
  # ORG.Mod берём тот же, что использовался в cfgX (для A — пропатченный)
  [ "$cfg" = A ] && cp "$P/build/cfgA/ORG.Mod" . || true
  args=""; for m in $COMP; do args="$args $m/s"; done
  NOREBO_PATH="$d:$P/build/cfg$cfg:$NB/Norebo:$NB/Oberon:$NB/build2" \
    "$NB/norebo.bin" ORP.Compile $args > "$d/build.log" 2>&1
done

# --- прогон одной нагрузки обоими компиляторами стадии 2
echo "нагрузка: $LOAD"
for cfg in A B; do
  d="$P/build/run2$cfg"; rm -rf "$d"; mkdir -p "$d"; cd "$d"
  args=""; for m in $LOAD; do args="$args $m/s"; done
  NOREBO_CYCLES=1 NOREBO_PATH="$P/build/stage2$cfg:$NB/Norebo:$NB/Oberon:$NB/build2" \
    "$NB/norebo.bin" ORP.Compile $args > "$d/run.log" 2>&1
done

python3 - "$P/build" <<'PY'
import re, sys, pathlib
b = pathlib.Path(sys.argv[1])
def cyc(p):
    t = (b/p/"run.log").read_text(errors="replace")
    m = re.search(r"CYCLES (\d+) INSNS (\d+)", t)
    return (int(m.group(1)), int(m.group(2))) if m else (None, None)
ca, ia = cyc("run2A"); cb, ib = cyc("run2B")
if not cb: print("нет данных, смотри build/run2B/run.log"); sys.exit(1)
print(f"\n  компилятор СО проверками   {cb:>13,} тактов  {ib:>12,} инстр.")
print(f"  компилятор БЕЗ проверок    {ca:>13,} тактов  {ia:>12,} инстр.")
print(f"  Δ                          {cb-ca:>13,} тактов  {ib-ia:>12,} инстр.")
print(f"\n  ДИНАМИЧЕСКАЯ цена проверок: {100*(cb-ca)/cb:.2f}% тактов, {100*(ib-ia)/ib:.2f}% инструкций")
PY
