#!/usr/bin/env python3
"""Обратная таблица «символ -> PS/2 скан-код» прямо из Input.Mod.

Оберон хранит прямую таблицу kbdTab в исходнике драйвера: индекс — скан-код
(плюс 80H, если нажат Shift), значение — ASCII. Мы разбираем её и строим
обратное отображение, чтобы не выдумывать раскладку самостоятельно.
"""
import re, sys

def load(path="ext/po2013-src/Input.Mod"):
    src = open(path, encoding="latin-1").read()
    m = re.search(r"KTabAdr := SYSTEM\.ADR\(\$(.*?)\$\)", src, re.S)
    if not m:
        sys.exit("таблица kbdTab не найдена в " + path)
    by = bytes.fromhex("".join(m.group(1).split()))
    assert len(by) == 256, f"ожидалось 256 байт, получено {len(by)}"
    rev = {}
    for code, ch in enumerate(by):
        if ch == 0:
            continue
        # первое вхождение выигрывает: младшие коды — основная раскладка
        rev.setdefault(chr(ch), (code & 0x7F, code >= 0x80))
    return rev

REV = load()

def keys(text):
    """Строка -> список скан-кодов, включая нажатия и отпускания Shift."""
    out, shifted = [], False
    for ch in text:
        if ch not in REV:
            sys.exit(f"символ {ch!r} не набирается на этой раскладке")
        code, need = REV[ch]
        if need and not shifted: out += [0x12]; shifted = True
        elif not need and shifted: out += [0xF0, 0x12]; shifted = False
        out += [code, 0xF0, code]          # нажатие и отпускание
    if shifted: out += [0xF0, 0x12]
    return out

if __name__ == "__main__":
    t = sys.argv[1] if len(sys.argv) > 1 else "ORP.Compile ORS.Mod/s ~"
    print(f"символов в таблице: {len(REV)}")
    print("проверка:", " ".join(f"{c:02X}" for c in keys(t)[:24]), "...")
    for ch in "ORPCompile./~ ":
        print(f"  {ch!r} -> {REV[ch][0]:02X}{' +Shift' if REV[ch][1] else ''}")
