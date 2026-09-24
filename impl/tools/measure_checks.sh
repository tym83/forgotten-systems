#!/bin/bash
# Замер цены проверок времени исполнения в Обероне.
# Конфигурация B — сток (проверки всегда включены, выключить штатно нельзя).
# Конфигурация A — тот же компилятор с патчем check := FALSE.
# Сравнивается размер порождаемого КОДА на одной и той же нагрузке.
set -e
P="$(cd "$(dirname "$0")/.." && pwd)"; NB="$P/ext/norebo"
WORK="$P/build/measure"; rm -rf "$WORK"; mkdir -p "$WORK/A" "$WORK/B"

MODS="$*"
[ -z "$MODS" ] && MODS="ORS.Mod ORB.Mod ORG.Mod ORP.Mod Kernel.Mod Files.Mod Modules.Mod Texts.Mod Oberon.Mod Fonts.Mod"

run() {  # $1 = A|B
  local cfg=$1 dir="$WORK/$1"
  cd "$dir"
  local args=""
  for m in $MODS; do args="$args $m/s"; done
  NOREBO_CYCLES=1 NOREBO_PATH="$P/build/cfg$cfg:$NB/Norebo:$NB/Oberon:$NB/build2" \
    "$NB/norebo.bin" ORP.Compile $args 2>&1
}
# ⚠ Ловушка Norebo: если исходник не найден по NOREBO_PATH, он УХОДИТ В ВЕЧНЫЙ ЦИКЛ
# вместо сообщения об ошибке. Порядок путей ниже проверен и работает — не трогать.
run B > "$WORK/B.log" 2>&1
run A > "$WORK/A.log" 2>&1

python3 - "$WORK" <<'PY'
import re, sys, pathlib
w = pathlib.Path(sys.argv[1])
def parse(p):
    d = {}
    for line in (w/p).read_text(errors="replace").splitlines():
        m = re.match(r"\s+compiling (\w+)\s+(\d+)\s+(\d+)", line)
        if m: d[m.group(1)] = (int(m.group(2)), int(m.group(3)))
    return d
B, A = parse("B.log"), parse("A.log")
print(f"{'модуль':<12}{'B код':>8}{'A код':>8}{'Δ слов':>8}{'Δ %':>8}")
print("-"*44)
tb = ta = 0
for m in B:
    if m not in A: continue
    b, a = B[m][0], A[m][0]; tb += b; ta += a
    print(f"{m:<12}{b:>8}{a:>8}{a-b:>8}{100*(b-a)/b:>7.1f}%")
print("-"*44)
print(f"{'ИТОГО':<12}{tb:>8}{ta:>8}{ta-tb:>8}{100*(tb-ta)/tb:>7.1f}%")
print(f"\nРАЗМЕР КОДА: проверки занимают {100*(tb-ta)/tb:.1f}% ({tb-ta} слов из {tb})")

# Такты компиляции (модель латентностей проверена против RTL потактово)
def cyc(p):
    for line in (w/p).read_text(errors="replace").splitlines():
        m = re.match(r"CYCLES (\d+) INSNS (\d+)", line)
        if m: return int(m.group(1)), int(m.group(2))
    return None, None
cb, ib = cyc("B.log"); ca, ia = cyc("A.log")
if cb and ca:
    print(f"\nТАКТЫ на самой нагрузке (компилятор компилирует {len(B)} модулей):")
    print(f"  B (сток)        {cb:>12,} тактов, {ib:>11,} инструкций")
    print(f"  A (без проверок){ca:>12,} тактов, {ia:>11,} инструкций")
    print(f"  Δ               {cb-ca:>12,} тактов  =  {100*(cb-ca)/cb:.2f}%")
    print(f"  Δ инструкций    {ib-ia:>12,}         =  {100*(ib-ia)/ib:.2f}%")
    print(f"  тактов на инструкцию: B {cb/ib:.3f}, A {ca/ia:.3f}")
PY
