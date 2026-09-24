#!/usr/bin/env python3
"""Свип площади ядра RISC5 по целевому периоду.

Защитимый маршрут (по рекомендации ревью методологии):
  synth -flatten -> dfflibmap -liberty -> abc -liberty -D <период> -> stat -liberty
Без dfflibmap триггеры выпадают из площади МОЛЧА (проверено: 76% потерь).
ВАЖНО: без -constr (драйвер + нагрузка) параметр -D игнорируется ПОЛНОСТЬЮ — проверено,
площадь совпадает до последнего знака при -D 200 и -D 50000. См. docs/FINDING-03.
Результат — график площадь-vs-период, а не одна цифра.
"""
import re, subprocess, sys, csv, os, pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
LIB  = ROOT / "syn/lib/nangate45_typ.lib"
SRC  = ["rtl/RISC5.v", "rtl/Registers.v", "rtl/Multiplier.v", "rtl/Divider.v",
        "rtl/FPAdder.v", "rtl/FPMultiplier.v", "rtl/FPDivider.v",
        "rtl/LeftShifter.v", "rtl/RightShifter.v"]

def nand2_area():
    t = LIB.read_text(errors="replace")
    m = re.search(r"cell\s*\(\s*NAND2_X1\s*\)\s*\{(.*?)\n\s{0,4}\}", t, re.S)
    return float(re.search(r"area\s*:\s*([0-9.]+)\s*;", m.group(1)).group(1))

def synth(period_ps, top="RISC5", extra_src=None, defines=""):
    src = " ".join(str(ROOT / s) for s in (extra_src or SRC))
    d = defines or ""
    script = f"""
read_verilog {d} {src}
hierarchy -check -top {top}
synth -top {top} -flatten
dfflibmap -liberty {LIB}
abc -liberty {LIB} -constr {ROOT}/syn/core.constr -D {period_ps}
opt_clean
stat -liberty {LIB}
"""
    r = subprocess.run(["yosys", "-s", "/dev/stdin"], input=script,
                       capture_output=True, text=True)
    out = r.stdout + r.stderr
    def g(pat, cast=float, default=None):
        m = re.search(pat, out, re.M)
        return cast(m.group(1)) if m else default
    return {
        "area":  g(r"Chip area for module[^:]*:\s*([0-9.]+)"),
        "seq":   g(r"sequential elements:\s*([0-9.]+)"),
        "seqpct":g(r"sequential elements:[^(]*\(([0-9.]+)%"),
        "cells": g(r"^\s+(\d+) cells", int),
        "dff":   g(r"^\s+(\d+)\s+[0-9.E+]+\s+DFF_X1", int),
        "unknown": len(re.findall(r"Area for cell type (\S+) is unknown", out)),
        "raw": out,
    }

def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    # --chk: мерить конфигурацию с аппаратной проверкой границ.
    # Параметр defines у synth() был, но main() его никогда не передавал —
    # то есть `make syn` физически не мог померить дельту (найдено аудитом).
    defs = "-DWITH_CHK -DCHK_SPLIT" if "--chk" in sys.argv else ""
    periods = [int(x) for x in (args or
               ["20000","10000","6000","4000","3000","2500","2000"])]
    if defs: print("конфигурация: с аппаратной проверкой границ (CHK_SPLIT)\n")
    n2 = nand2_area()
    print(f"NAND2_X1 = {n2} мкм²  (делитель для kGE)\n")
    hdr = f"{'период,пс':>10} {'площадь,мкм²':>14} {'kGE':>8} {'посл.,мкм²':>12} {'%посл':>6} {'ячеек':>7} {'DFF':>5}"
    print(hdr); print("-" * len(hdr))
    rows = []
    for ps in periods:
        r = synth(ps, defines=defs)
        if r["area"] is None:
            print(f"{ps:>10}   СИНТЕЗ НЕ ДАЛ ПЛОЩАДИ"); continue
        kge = r["area"] / n2 / 1000
        print(f"{ps:>10} {r['area']:>14.2f} {kge:>8.2f} {r['seq']:>12.2f} "
              f"{r['seqpct']:>6.1f} {r['cells']:>7} {r['dff']:>5}")
        rows.append([ps, r["area"], round(kge,3), r["seq"], r["seqpct"], r["cells"], r["dff"]])
    outp = ROOT / ("syn/results/chk_sweep.csv" if defs else "syn/results/base_sweep.csv")
    outp.parent.mkdir(parents=True, exist_ok=True)
    with outp.open("w", newline="") as f:
        w = csv.writer(f); w.writerow(["period_ps","area_um2","kGE","seq_um2","seq_pct","cells","dff"])
        w.writerows(rows)
    print(f"\n→ {outp}")

if __name__ == "__main__":
    main()
