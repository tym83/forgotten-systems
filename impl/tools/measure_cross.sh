#!/bin/bash
# Разложение цены проверок перекрёстной сборкой 2×2.
#
# Проблема: конфигурация A отличается от B ДВУМЯ вещами сразу — внутри неё нет
# проверок И она не эмитит проверки для нагрузки. Разница A↔B складывает цену
# исполнения проверок и работу компилятора по их порождению.
#
# Решение: построить все четыре комбинации.
#   A  = патченый ORG.Mod, собранный компилятором A   (нет внутри, не эмитит)
#   A' = СТОКОВЫЙ  ORG.Mod, собранный компилятором A  (нет внутри, ЭМИТИТ)
#   B' = патченый ORG.Mod, собранный компилятором B   (ЕСТЬ внутри, не эмитит)
#   B  = стоковый ORG.Mod, собранный компилятором B   (есть внутри, эмитит)
# Тогда:
#   цена ИСПОЛНЕНИЯ проверок = B − A'  (и независимо B' − A)
#   цена ПОРОЖДЕНИЯ проверок = A' − A  (и независимо B − B')
set -e
P="$(cd "$(dirname "$0")/.." && pwd)"; NB="$P/ext/norebo"
COMP="ORS.Mod ORB.Mod ORG.Mod ORP.Mod"
LOAD="${*:-Texts.Mod Fonts.Mod Files.Mod Modules.Mod Oberon.Mod}"

# $1 = каким компилятором (A|B), $2 = какой ORG.Mod (stock|patched), $3 = имя
stage2() {
  local by="$1" src="$2" name="$3"
  local bin="$P/build/x_bin$by"; rm -rf "$bin"; mkdir -p "$bin"
  cp "$P/build/cfg$by"/*.rsc "$bin"/ 2>/dev/null || true
  local d="$P/build/x2$name"; rm -rf "$d"; mkdir -p "$d"; cd "$d"
  # исходник кладём явно, чтобы он нашёлся ПЕРВЫМ
  if [ "$src" = "patched" ]; then cp "$P/patches/ORG-cfgA.Mod" ORG.Mod; fi
  local args=""; for m in $COMP; do args="$args $m/s"; done
  NOREBO_PATH="$d:$bin:$NB/Norebo:$NB/Oberon:$NB/build2" \
    "$NB/norebo.bin" ORP.Compile $args > build.log 2>&1
}
stage2 A patched A
stage2 A stock   Ap
stage2 B patched Bp
stage2 B stock   B

for n in A Ap Bp B; do
  d="$P/build/xrun$n"; rm -rf "$d"; mkdir -p "$d"; cd "$d"
  args=""; for m in $LOAD; do args="$args $m/s"; done
  NOREBO_CYCLES=1 NOREBO_PATH="$P/build/x2$n:$NB/Norebo:$NB/Oberon:$NB/build2" \
    "$NB/norebo.bin" ORP.Compile $args > run.log 2>&1
done

python3 - "$P/build" <<'PY'
import re, sys, pathlib
b = pathlib.Path(sys.argv[1])
def get(n):
    t = (b / f"xrun{n}" / "run.log").read_text(errors="replace")
    m = re.search(r"CYCLES (\d+) INSNS (\d+)", t)
    code = sum(int(x) for x in re.findall(r"^\s+compiling \w+\s+(\d+)", t, re.M))
    return (int(m.group(1)), int(m.group(2)), code)
A, Ap, Bp, B = get("A"), get("Ap"), get("Bp"), get("B")
print(f"{'':30}{'такты':>13}{'инстр.':>13}{'код':>8}")
print("-"*66)
for n, v in (("A  нет внутри, не эмитит", A), ("A' нет внутри, ЭМИТИТ", Ap),
             ("B' есть внутри, не эмитит", Bp), ("B  есть внутри, эмитит", B)):
    print(f"{n:<30}{v[0]:>13,}{v[1]:>13,}{v[2]:>8,}")
print("-"*66)
print("\nКОНТРОЛЬ постановки (порождённый код):")
print(f"  A' даёт {Ap[2]} слов, B даёт {B[2]} — {'✅ совпадают' if Ap[2]==B[2] else '❌ различаются'}")
print(f"  B' даёт {Bp[2]} слов, A даёт {A[2]} — {'✅ совпадают' if Bp[2]==A[2] else '❌ различаются'}")
e1, e2 = B[0]-Ap[0], Bp[0]-A[0]
g1, g2 = Ap[0]-A[0], B[0]-Bp[0]
print(f"\nРАЗЛОЖЕНИЕ (всего B−A = {B[0]-A[0]:,} тактов = {100*(B[0]-A[0])/A[0]:.2f}%):")
print(f"  исполнение проверок:  B−A' = {e1:>8,}  ({100*e1/A[0]:.2f}%)")
print(f"                        B'−A = {e2:>8,}  ({100*e2/A[0]:.2f}%)   расхождение {abs(e1-e2)*100/max(e1,e2):.1f}%")
print(f"  порождение проверок:  A'−A = {g1:>8,}  ({100*g1/A[0]:.2f}%)")
print(f"                        B−B' = {g2:>8,}  ({100*g2/A[0]:.2f}%)   расхождение {abs(g1-g2)*100/max(g1,g2):.1f}%")
print(f"\n  сумма {e1+g1:,} против B−A {B[0]-A[0]:,} — {'✅ разложение точное' if e1+g1==B[0]-A[0] else '❌'}")
PY
