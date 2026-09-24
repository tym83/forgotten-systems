#!/usr/bin/env python3
"""Порядок сборки модулей Оберона: топологическая сортировка по IMPORT.

Порядок не берётся из памяти и не списывается из чужого скрипта — он выводится
из самих исходников. Модуль можно компилировать только после всех, чьи
символьные файлы ему нужны.
"""
import re, sys, pathlib

SRC = pathlib.Path("ext/po2013-src")


def imports(path):
    t = open(path, encoding="latin-1").read()
    m = re.search(r"\bIMPORT\b(.*?);", t, re.S)
    if not m:
        return set()
    names = set()
    for part in m.group(1).split(","):
        part = part.strip()
        if ":=" in part:                     # псевдоним: A := B
            part = part.split(":=")[1].strip()
        part = part.split()[0] if part.split() else ""
        if part and part != "SYSTEM":
            names.add(part)
    return names


def order(only=None):
    mods = {}
    for p in sorted(SRC.glob("*.Mod")):
        name = p.stem
        if only is not None and name not in only:
            continue
        mods[name] = imports(p)
    done, out = set(), []
    while len(out) < len(mods):
        progress = False
        for n in sorted(mods):
            if n in done:
                continue
            if mods[n] <= done | (set(mods) ^ set(mods)):   # пусто, заполним ниже
                pass
            if all(d in done or d not in mods for d in mods[n]):
                out.append(n); done.add(n); progress = True
        if not progress:
            left = [n for n in sorted(mods) if n not in done]
            sys.exit(f"цикл в зависимостях: {left}")
    return out, mods


if __name__ == "__main__":
    only = None
    if len(sys.argv) > 1:
        only = set(open(sys.argv[1]).read().split())
    out, mods = order(only)
    print(" ".join(out))
    print(f"\nмодулей: {len(out)}", file=sys.stderr)
