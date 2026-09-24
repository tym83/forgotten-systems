#!/usr/bin/env python3
"""Сверка qemu-system-risc5 с моделью, снятой с настоящего RTL.

Программа собирается НАШИМ ассемблером, считается НАШЕЙ моделью АЛУ и
исполняется в QEMU. Сходятся все регистры и флаги — или проверка красная.

Модель независима от цели QEMU: она написана раньше и сверена с железом на
4650 проверках. Поэтому совпадение здесь — не самосогласованность, а
внешнее свидетельство.
"""
import pathlib, re, struct, subprocess, sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
IMPL = ROOT / "impl"
sys.path.insert(0, str(IMPL / "tools"))
from alu_model import State, step            # noqa: E402

QEMU = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / ".qemu-work"


def model(words):
    st = State()
    for w in words[:-1]:                     # последняя — переход, вне модели
        if not step(st, w):
            break
    return st


def in_qemu(binpath):
    work = QEMU
    subprocess.run(["docker", "run", "--rm", "-v", f"{work}:/src",
                    "qemu-build:risc5",
                    "cd /src && timeout 2 ./build/qemu-system-risc5 -M oberon "
                    "-bios prog.bin -nographic -monitor none -serial none "
                    "-d cpu -D /tmp/q.log >/dev/null 2>&1; tail -7 /tmp/q.log "
                    "> /src/state.txt"], check=True, capture_output=True)
    text = (work / "state.txt").read_text()
    regs = {int(m[0]): int(m[1], 16) for m in re.findall(r"R(\d+)\s+([0-9a-f]{8})", text)}
    fl = re.search(r"N(\d) Z(\d) C(\d) V(\d)", text)
    h = re.search(r"H\s+([0-9a-f]{8})", text)
    return regs, tuple(int(x) for x in fl.groups()), int(h.group(1), 16)


def main():
    src = IMPL / "build/qtest/t.s"
    binp = IMPL / "build/qtest/t.bin"
    subprocess.run([sys.executable, str(IMPL / "tools/asm.py"), str(src),
                    "-o", str(binp.with_suffix(""))], check=True,
                   capture_output=True, cwd=IMPL)
    data = binp.read_bytes()
    words = list(struct.unpack("<%dI" % (len(data) // 4), data))

    st = model(words)
    (QEMU / "prog.bin").write_bytes(data)
    regs, flags, h = in_qemu(binp)

    bad = 0
    for i in range(16):
        exp, got = st.R[i], regs.get(i, -1)
        if exp != got:
            print(f"  ❌ R{i}: модель {exp:08X}, QEMU {got:08X}"); bad += 1
    if flags != (st.N, st.Z, st.C, st.V):
        print(f"  ❌ флаги: модель {(st.N, st.Z, st.C, st.V)}, QEMU {flags}"); bad += 1
    if h != st.H:
        print(f"  ❌ H: модель {st.H:08X}, QEMU {h:08X}"); bad += 1

    if bad:
        print(f"\nрасхождений: {bad}")
        return 1
    print(f"  ✅ 16 регистров, 4 флага и H сошлись с моделью, снятой с RTL")
    return 0


if __name__ == "__main__":
    sys.exit(main())
