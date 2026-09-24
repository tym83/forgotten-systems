#!/usr/bin/env python3
"""Запуск команды с ограничением по времени (на macOS нет timeout)."""
import subprocess, sys
t = float(sys.argv[1])
try:
    r = subprocess.run(sys.argv[2:], timeout=t, capture_output=True, text=True)
    sys.stdout.write(r.stdout[-2000:]); sys.stderr.write(r.stderr[-2000:])
    sys.exit(r.returncode)
except subprocess.TimeoutExpired as e:
    out = (e.stdout or b"")[-1000:]
    print(f"⏱ ЗАВИС: превышено {t}с", file=sys.stderr)
    if out: print("последний вывод:", out.decode(errors="replace"), file=sys.stderr)
    sys.exit(124)
