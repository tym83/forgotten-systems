#!/usr/bin/env python3
"""Распределение ОБЪЯВЛЕННЫХ длин массивов в исходниках Project Oberon 2013.

Дополняет анализ по скомпилированному коду (tools/array_limits.py): тот работает
только на модулях, которые компилируются данным компилятором, и потому не покрывает
оконную часть системы. Здесь — разбор объявлений во всех исходниках, включая графику.

Разбирает:
    ARRAY <выражение> OF ...        -- длина, если это константа или известная CONST
    ARRAY a, b OF ...               -- многомерные: каждая размерность отдельно
Пропускает открытые массивы (ARRAY OF) -- у них длина динамическая.
"""
import re, sys, pathlib, collections

def consts(text):
    """Значения CONST-идентификаторов (простые целые и простая арифметика)."""
    env = {}
    for m in re.finditer(r"\b([A-Za-z]\w*)\s*\*?\s*=\s*([^;]+?)[;\n]", text):
        name, expr = m.group(1), m.group(2).strip()
        expr = re.sub(r"\b([0-9A-F]+)H\b", lambda x: str(int(x.group(1), 16)), expr)
        if re.fullmatch(r"[\d\s+\-*/()]+", expr):
            try: env[name] = int(eval(expr, {}, {}))
            except Exception: pass
        elif re.fullmatch(r"[\w\s+\-*/()]+", expr):
            try: env[name] = int(eval(expr, {}, dict(env)))
            except Exception: pass
    return env

def arrays(text, env):
    out = []
    for m in re.finditer(r"\bARRAY\b([^;]*?)\bOF\b", text, re.S):
        dims = m.group(1).strip()
        if not dims:                       # открытый массив
            continue
        for d in dims.split(","):
            d = d.strip()
            d = re.sub(r"\b([0-9A-F]+)H\b", lambda x: str(int(x.group(1), 16)), d)
            try:
                v = int(eval(d, {}, dict(env)))
                if 0 < v <= 1 << 24: out.append(v)
            except Exception:
                pass
    return out

def main():
    all_lens, per = [], {}
    for p in sorted(pathlib.Path(sys.argv[1]).glob("*.Mod")):
        if p.name.endswith(".Orig.Mod"): continue
        t = p.read_bytes().decode("latin-1").replace("\r", "\n")
        t = re.sub(r"\(\*.*?\*\)", " ", t, flags=re.S)          # убрать комментарии
        ls = arrays(t, consts(t))
        if ls: per[p.name[:-4]] = ls
        all_lens += ls
    print(f"{'модуль':<18}{'массивов':>9}  длины")
    print("-"*70)
    for m, ls in sorted(per.items(), key=lambda x: -len(x[1])):
        s = ", ".join(str(x) for x in sorted(set(ls)))
        print(f"{m:<18}{len(ls):>9}  {s[:48]}")
    print("-"*70)
    n = len(all_lens); all_lens.sort()
    print(f"{'ИТОГО':<18}{n:>9}   модулей {len(per)}")
    print(f"\n=== РАСПРЕДЕЛЕНИЕ {n} ОБЪЯВЛЕННЫХ РАЗМЕРНОСТЕЙ ===")
    cum = 0
    for lo, hi in [(1,15),(16,63),(64,127),(128,255),(256,1023),(1024,4095),(4096,1<<24)]:
        c = sum(1 for x in all_lens if lo <= x <= hi); cum += c
        print(f"  {lo:>5}…{hi:<8} {c:>5} ({100*c/n:>5.1f}%)  накопл. {100*cum/n:>5.1f}%  {'█'*round(40*c/n)}")
    print(f"\n  минимум {all_lens[0]}, медиана {all_lens[n//2]}, максимум {all_lens[-1]}")
    le255 = sum(1 for x in all_lens if x <= 255); le4095 = sum(1 for x in all_lens if x <= 4095)
    print(f"\n  ≤255  (8 бит):  {le255:>4}/{n} = {100*le255/n:.1f}%")
    print(f"  ≤4095 (12 бит): {le4095:>4}/{n} = {100*le4095/n:.1f}%")
    print(f"  разница: {100*(le4095-le255)/n:.1f} п.п.")

if __name__ == "__main__":
    main()
