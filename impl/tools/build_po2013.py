#!/usr/bin/env python3
"""Компилирует полный комплект исходников Project Oberon 2013 в порядке зависимостей.

Порядок вычисляется топологической сортировкой по секциям IMPORT, а не задаётся руками.
Цель — получить .rsc всех модулей для статического анализа (запускать их не нужно,
поэтому оконные модули тоже годятся)."""
import re, sys, pathlib, subprocess, collections

ROOT = pathlib.Path(__file__).resolve().parent.parent
SRC  = ROOT / "ext/po2013-src"
NB   = ROOT / "ext/norebo"
OUT  = ROOT / "build/po2013"

# Модули, которые для статического анализа не нужны или не компилируются
# (загрузчик живёт до системы; .Orig — альтернативные варианты того же модуля).
SKIP = {"BootLoad", "Display.Orig", "Input.Orig"}

def imports(text):
    m = re.search(r"\bIMPORT\b(.*?);", text, re.S)
    if not m: return set()
    out = set()
    for part in m.group(1).split(","):
        part = part.strip()
        if ":=" in part: part = part.split(":=")[1].strip()   # алиас
        name = part.split(".")[0].strip()
        if name and name not in ("SYSTEM",): out.add(name)
    return out

def main():
    mods = {}
    for p in sorted(SRC.glob("*.Mod")):
        stem = p.name[:-4]
        if stem in SKIP: continue
        txt = p.read_bytes().decode("latin-1").replace("\r", "\n")
        mods[stem] = (p, imports(txt))

    # топологическая сортировка; внешние зависимости игнорируем
    order, seen, stack = [], set(), set()
    def visit(m):
        if m in seen or m not in mods: return
        if m in stack: return                      # цикл — оставляем как есть
        stack.add(m)
        for d in sorted(mods[m][1]): visit(d)
        stack.discard(m); seen.add(m); order.append(m)
    for m in sorted(mods): visit(m)

    OUT.mkdir(parents=True, exist_ok=True)
    fresh = "--fresh" in sys.argv
    if fresh:
        for f in OUT.glob("*"): f.unlink()
    for m in order:
        (OUT / f"{m}.Mod").write_bytes(mods[m][0].read_bytes())

    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    cfg = args[0] if args else "B"
    env = {"NOREBO_PATH": f"{OUT}:{ROOT}/build/s2{cfg}:{NB}/Norebo:{NB}/Oberon:{NB}/build2"}
    import os
    e = dict(os.environ); e.update(env)

    budget = 8
    for a in sys.argv[1:]:
        if a.startswith("--budget="): budget = int(a.split("=")[1])
    print(f"порядок сборки ({len(order)} модулей), конфигурация {cfg}, бюджет {budget}:")
    built_now = 0
    ok = failed = []
    ok, failed = [], []
    for m in order:
        if not fresh and (OUT / f"{m}.rsc").exists():
            ok.append(m); continue
        if built_now >= budget:
            print(f"  … бюджет исчерпан, осталось после {m}"); break
        built_now += 1
        # Norebo при ненайденном файле уходит в ВЕЧНЫЙ ЦИКЛ вместо ошибки,
        # поэтому таймаут обязателен и должен быть нефатальным.
        try:
            r = subprocess.run([str(NB / "norebo.bin"), "ORP.Compile", f"{m}.Mod/s"],
                               cwd=OUT, env=e, capture_output=True, text=True, timeout=12)
            out = r.stdout + r.stderr
        except subprocess.TimeoutExpired:
            out = "ЗАВИС (вероятно, не найден импортируемый модуль)"
        if (OUT / f"{m}.rsc").exists() and "error" not in out.lower() and "not found" not in out:
            ok.append(m); mark = "✅"
        else:
            failed.append((m, out.strip().splitlines()[-1] if out.strip() else "?")); mark = "❌"
        print(f"  {mark} {m}")
    print(f"\nсобрано {len(ok)}, не собралось {len(failed)}")
    for m, why in failed: print(f"   ❌ {m}: {why[:100]}")

if __name__ == "__main__":
    main()
