#!/usr/bin/env python3
"""Считает ловушки в скомпилированном модуле Оберона (.rsc).

Проверка того, что замер A/B меряет именно проверки времени исполнения:
разница в размере кода должна состоять из инструкций Trap, то есть условных
BLR на регистр MT (R12), которые эмитит ORG.Trap:
    Put3(BLR, cond, ORS.Pos()*100H + num*10H + MT)
Формат F3 с ссылкой: биты 31:28 = 111v (v=1 -> со ссылкой), c в битах 3:0.
Для ловушек c = MT = 12, а номер ловушки — в битах 7:4.
"""
import struct, sys, pathlib

TRAPNAME = {1: "индекс массива", 2: "тип", 3: "диапазон", 4: "NIL",
            5: "NIL (проц.)", 6: "деление", 7: "утверждение"}

def code_section(path):
    """Достаёт секцию кода из .rsc. Формат по ORG.Close / Modules.Load."""
    d = pathlib.Path(path).read_bytes()
    i = 0
    def s():                       # строка с нулевым байтом
        nonlocal i
        j = d.index(b"\0", i); r = d[i:j]; i = j + 1; return r
    def n():                       # 32-битное слово
        nonlocal i
        v = struct.unpack_from("<i", d, i)[0]; i += 4; return v
    # Формат по ORG.Close (ORG.Mod:1063-1079):
    #   имя\0 | ключ(4) | версия(1) | размер(4)
    #   [ имя\0 | ключ(4) ]* | 0     -- импорты, завершаются пустым именем
    #   tdx*4(4) | описатели(tdx*4 байт)
    #   varsize-tdx*4(4) | strx(4) | строки(strx байт)
    #   pc(4) | код(pc слов)
    s(); n()                       # имя, ключ
    i += 1                         # версия (байт)
    n()                            # size
    while s(): n()                 # импорты, до пустого имени
    # ВНИМАНИЕ: писать `i += n()` нельзя — Python берёт старое i ДО вызова n(),
    # а n() внутри сдвигает i, и этот сдвиг теряется. Только в два шага.
    v = n(); i += v                # описатели типов: длина в байтах
    n()                            # varsize - tdx*4
    v = n(); i += v                # строки: длина в байтах
    ncode = n()
    return [struct.unpack_from("<I", d, i + k*4)[0] for k in range(ncode)]

def chks(words):
    """Аппаратные проверки CHK: F0 (биты 31:28 = 0001), op=1, младший нибл = MT=12."""
    return [k for k, w in enumerate(words)
            if (w >> 28) == 0b0001 and ((w >> 16) & 0xF) == 1 and (w & 0xF) == 12]

def traps(words):
    out = []
    for k, w in enumerate(words):
        # Put3: code := ((op+12)*10H + cond)*1000000H + off
        # BLR = 1 -> старший байт = (1+12)*16 + cond = 0xD0|cond, то есть нибл 1101.
        # Ловушка: off = pos*100H + num*10H + MT, значит младший нибл = 12 (MT),
        # номер ловушки в битах 7:4, позиция в исходнике в битах 23:8.
        if (w >> 28) == 0b1101 and (w & 0xF) == 12:
            out.append((k, (w >> 4) & 0xF, (w >> 8) & 0xFFFF))
    return out

for p in sys.argv[1:]:
    ws = code_section(p)
    t = traps(ws)
    by = {}
    for _, num, _ in t: by[num] = by.get(num, 0) + 1
    name = pathlib.Path(p).name
    det = ", ".join(f"{TRAPNAME.get(k, k)}: {v}" for k, v in sorted(by.items()))
    ch = chks(ws)
    chs = f"   CHK {len(ch):>4}" if ch else ""
    print(f"{name:<14} слов кода {len(ws):>6}   ловушек {len(t):>5}{chs}   {det}")
