#!/usr/bin/env python3
"""Свип задержки: площадь против достижимого критического пути.

Что это меряет: оценку abc для СКОМБИНИРОВАННОЙ логики после технологического
отображения, при WireLoad = "none" — то есть БЕЗ задержек проводов вообще.
Это оптимистичная оценка, пригодная для ОТНОСИТЕЛЬНОГО сравнения конфигураций,
а не как абсолютная частота кремния. Полноценный статический анализ требует
OpenSTA по нетлисту; его в маршруте нет.
"""
import re, subprocess, sys, csv, pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
LIB  = ROOT / "syn/lib/nangate45_typ.lib"
SRC  = ["rtl/RISC5.v", "rtl/Registers.v", "rtl/Multiplier.v", "rtl/Divider.v",
        "rtl/FPAdder.v", "rtl/FPMultiplier.v", "rtl/FPDivider.v",
        "rtl/LeftShifter.v", "rtl/RightShifter.v"]

def run(period_ps, defines=""):
    src = " ".join(str(ROOT / s) for s in SRC)
    scr = (f"+strash;&get,-n;&dch,-f;&nf,-D,{period_ps};&put;"
           f"buffer;upsize,-D,{period_ps};dnsize,-D,{period_ps};stime,-p")
    script = f"""
read_verilog {defines} {src}
hierarchy -check -top RISC5
synth -top RISC5 -flatten
dfflibmap -liberty {LIB}
abc -liberty {LIB} -constr {ROOT}/syn/core.constr -D {period_ps} -script {scr}
opt_clean
stat -liberty {LIB}
"""
    r = subprocess.run(["yosys", "-s", "/dev/stdin"], input=script,
                       capture_output=True, text=True)
    out = r.stdout + r.stderr
    d = re.findall(r"Delay\s*=\s*([0-9.]+)\s*ps", out)
    a = re.search(r"Chip area for module[^:]*:\s*([0-9.]+)", out)
    return (float(d[-1]) if d else None, float(a.group(1)) if a else None)

def main():
    cfgs = [("базовое", ""), ("с CHK", "-DWITH_CHK -DCHK_SPLIT")]
    periods = [int(x) for x in (sys.argv[1:] or
               ["5000","3000","2000","1500","1200","1000","800"])]
    rows = []
    for name, d in cfgs:
        print(f"\n=== {name} ===")
        print(f"{'цель,пс':>9}{'достигнуто,пс':>15}{'Fmax,МГц':>11}{'площадь,мкм²':>15}")
        print("-" * 50)
        for p in periods:
            delay, area = run(p, d)
            if delay is None: print(f"{p:>9}   нет данных"); continue
            f = 1e6 / delay
            print(f"{p:>9}{delay:>15.1f}{f:>11.1f}{area:>15.2f}")
            rows.append([name, p, delay, round(f,1), area])
    out = ROOT / "syn/results/fmax_sweep.csv"
    out.parent.mkdir(parents=True, exist_ok=True)
    with out.open("w", newline="") as f:
        w = csv.writer(f); w.writerow(["config","target_ps","delay_ps","fmax_mhz","area_um2"])
        w.writerows(rows)
    print(f"\n→ {out}")

if __name__ == "__main__":
    main()
