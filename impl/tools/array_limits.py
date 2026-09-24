#!/usr/bin/env python3
"""Распределение длин массивов в скомпилированной системе Оберон.

Нужно, чтобы закрыть развилку по кодированию CHK: предел в 12 бит (до 4095)
ломает диагностику, предел в 8 бит (до 255) её сохраняет. Выбор — по данным.

Метод: ORG.Index для массива фиксированной длины эмитит пару
    Put1a(Cmp, RH, y.r, lim)   ->  F1: SUB RH, idx, #lim
    Trap(10, 1)                ->  F3: BLR CC, pos*100H + 1*10H + MT
Ищем такие пары и достаём непосредственный предел.

Кодирование (ORG.Put1): (((a+40H)*10H + b)*10H + op)*10000H + im
  -> биты 31:28 = 0100 (q=1,u=0,v=0), 27:24 = a, 23:20 = b, 19:16 = op, 15:0 = im
Ловушка (ORG.Put3, BLR=1, cond=10): старший байт = (1+12)*16 + 10 = 0xDA
  -> биты 7:4 = номер ловушки, 3:0 = MT = 12
"""
import struct, sys, pathlib, collections

def code_section(path):
    d = pathlib.Path(path).read_bytes(); i = 0
    def s():
        nonlocal i
        j = d.index(b"\0", i); r = d[i:j]; i = j + 1; return r
    def n():
        nonlocal i
        v = struct.unpack_from("<i", d, i)[0]; i += 4; return v
    s(); n(); i += 1; n()
    while s(): n()
    v = n(); i += v
    n()
    v = n(); i += v
    ncode = n()
    return [struct.unpack_from("<I", d, i + k*4)[0] for k in range(ncode)]

TRAP_HI = 0xDA            # BLR, cond = 10 (CC)

def analyse(path):
    w = code_section(path)
    fixed, dynamic, other = [], 0, 0
    for k in range(1, len(w)):
        t = w[k]
        if (t >> 24) != TRAP_HI:            continue
        if (t & 0xF) != 12:                 continue     # не через MT
        if ((t >> 4) & 0xF) != 1:           continue     # не ловушка индекса
        p = w[k-1]
        top = p >> 28
        op  = (p >> 16) & 0xF
        if top == 0b0100 and op == 9:                    # F1 SUB с непосредственным
            fixed.append(p & 0xFFFF)
        elif top in (0b0000, 0b0010) and op == 9:        # F0 SUB — открытый массив
            dynamic += 1
        else:
            other += 1
    return fixed, dynamic, other

def main():
    allfixed, alldyn, allother = [], 0, 0
    per = {}
    for p in sys.argv[1:]:
        try:
            f, d, o = analyse(p)
        except Exception as e:
            print(f"  ⚠ {pathlib.Path(p).name}: {e}"); continue
        per[pathlib.Path(p).stem] = (len(f), d, o)
        allfixed += f; alldyn += d; allother += o

    print(f"{'модуль':<16}{'фикс.':>7}{'открытых':>10}{'проч.':>7}")
    print("-"*40)
    for m, (a, b, c) in sorted(per.items(), key=lambda x: -x[1][0]):
        if a or b or c: print(f"{m:<16}{a:>7}{b:>10}{c:>7}")
    print("-"*40)
    print(f"{'ИТОГО':<16}{len(allfixed):>7}{alldyn:>10}{allother:>7}")

    if not allfixed: return
    allfixed.sort()
    n = len(allfixed)
    print(f"\n=== РАСПРЕДЕЛЕНИЕ {n} ПРОВЕРОК С ФИКСИРОВАННЫМ ПРЕДЕЛОМ ===")
    buckets = [(0,15),(16,63),(64,127),(128,255),(256,1023),(1024,4095),(4096,0xFFFF)]
    cum = 0
    for lo, hi in buckets:
        c = sum(1 for x in allfixed if lo <= x <= hi); cum += c
        bar = "█" * round(40*c/n)
        print(f"  {lo:>5}…{hi:<6} {c:>5} ({100*c/n:>5.1f}%)  накопл. {100*cum/n:>5.1f}%  {bar}")
    print(f"\n  минимум {allfixed[0]}, медиана {allfixed[n//2]}, максимум {allfixed[-1]}")
    le255  = sum(1 for x in allfixed if x <= 255)
    le4095 = sum(1 for x in allfixed if x <= 4095)
    print(f"\n=== ОТВЕТ НА РАЗВИЛКУ ===")
    print(f"  предел  8 бит (≤255):  покрывает {le255:>4} из {n}  = {100*le255/n:.1f}%  (диагностика ЦЕЛА)")
    print(f"  предел 12 бит (≤4095): покрывает {le4095:>4} из {n}  = {100*le4095/n:.1f}%  (диагностика СЛОМАНА)")
    print(f"  разница в покрытии: {100*(le4095-le255)/n:.1f} п.п.")
    tot = n + alldyn
    print(f"\n  доля от ВСЕХ проверок индекса ({tot}, включая открытые массивы):")
    print(f"    8 бит  {100*le255/tot:.1f}%   12 бит {100*le4095/tot:.1f}%")

if __name__ == "__main__":
    main()
