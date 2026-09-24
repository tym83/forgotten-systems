#!/usr/bin/env python3
"""PBM (P1) -> PNG. Нужен только чтобы глазами смотреть на экран Оберона."""
import sys
from PIL import Image

def load(path):
    t = open(path).read().split()
    assert t[0] == "P1"
    w, h = int(t[1]), int(t[2])
    px = t[3:3 + w * h]
    im = Image.new("1", (w, h))
    im.putdata([0 if c == '1' else 1 for c in px])   # 1 = чёрный
    return im

if __name__ == "__main__":
    load(sys.argv[1]).save(sys.argv[2])
    print(sys.argv[2])
