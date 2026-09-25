#!/usr/bin/env python3
"""Сверка аппаратной проверки границ: QEMU против настоящего RTL.

Одна и та же программа (`tests/bench_bounds_e.bin`, та самая, что считает
числа на странице) гоняется двумя способами:

  * в QEMU с `-machine oberon,chk=on`;
  * на модели, собранной Verilator'ом из RISC5.v с `-DWITH_CHK -DCHK_SPLIT`
    и скомпилированной в WASM — то есть на том же железе, что и в браузере.

Сравнивается состояние ВСЕХ регистров после одинакового числа инструкций.
Проверка нужна ровно затем, чтобы расширение системы команд не разъехалось
между браузером и кластером: в кластере машину исполняет QEMU, в браузере —
RTL, и «работает у меня» здесь ничего не значит.
"""
import json, pathlib, re, subprocess, sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
IMPL = ROOT / "impl"
QEMU = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / ".qemu-work"
BUDGET = 8000            # инструкций: внутри цикла, и журнал остаётся мелким
                         # (одна команда на блок — это ~230 байт журнала на команду)


def in_rtl(binpath, budget):
    """Регистры после `budget` инструкций на модели, снятой с RTL."""
    js = f"""
import fs from 'node:fs';
const b = fs.readFileSync('{binpath}');
const prom = new Uint32Array(b.buffer, b.byteOffset, b.length / 4);
const M = await (await import('./risc5-chk.js')).default();
const pP = M._malloc(prom.length * 4);
M.HEAPU8.set(new Uint8Array(prom.buffer, prom.byteOffset, prom.length * 4), pP);
const pI = M._malloc(1024);
M._soc_init(pP, prom.length, pI, 1024);
M._soc_run({budget});
console.log(JSON.stringify({{
  regs: Array.from({{length: 16}}, (_, i) => M._soc_reg(i) >>> 0),
  insns: M._soc_insns(), pc: M._soc_pc() >>> 0,
}}));
"""
    out = subprocess.run(["node", "--input-type=module", "-e", js],
                         cwd=IMPL / "web", capture_output=True, text=True, check=True)
    return json.loads(out.stdout.strip().splitlines()[-1])


def in_qemu(binpath, budget, chk):
    """То же самое в QEMU: гоняем с журналом команд и берём состояние на той же команде."""
    data = pathlib.Path(binpath).read_bytes()
    (QEMU / "prog.bin").write_bytes(data)
    flag = ",chk=on" if chk else ""
    # ⚠ `-d cpu` печатает состояние на КАЖДЫЙ БЛОК трансляции, а не на каждую
    # команду: без one-insn-per-tb счётчик блоков не равен счётчику команд, и
    # сравнение молча съезжает. На этом уже терялся целый заход отладки.
    cmd = (f"cd /src && timeout 300 ./build/qemu-system-risc5 -M oberon{flag} "
           f"-accel tcg,one-insn-per-tb=on "
           f"-bios prog.bin -nographic -monitor none -serial none "
           f"-d cpu -D /tmp/q.log >/dev/null 2>&1; "
           f"head -c 3000000 /tmp/q.log > /src/chk.txt")
    subprocess.run(["docker", "run", "--rm", "-v", f"{QEMU}:/src",
                    "qemu-build:risc5", cmd], check=True, capture_output=True)
    text = (QEMU / "chk.txt").read_text(errors="replace")
    blocks = text.split("PC   ")
    # ⚠ QEMU печатает состояние ПЕРЕД исполнением блока, а счётчик модели —
    # ПОСЛЕ исполненной команды. Отсюда сдвиг на единицу: blocks[0] — обрывок
    # до первой строки состояния, blocks[n+1] — состояние после n-й команды.
    # Без сдвига расходится ровно один регистр — тот, который пишет следующая
    # команда, и выглядит это как настоящая ошибка реализации.
    if len(blocks) <= budget + 1:
        raise SystemExit(f"  ❌ в журнале QEMU только {len(blocks) - 1} команд, нужно {budget + 1}")
    blk = blocks[budget + 1]
    regs = {int(m[0]): int(m[1], 16) for m in re.findall(r"R(\d+)\s+([0-9a-f]{8})", blk)}
    return [regs.get(i, -1) for i in range(16)]


def main():
    binp = IMPL / "tests/bench_bounds_e.bin"
    if not binp.exists():
        raise SystemExit("  ❌ нет tests/bench_bounds_e.bin — соберите: make -C impl web")

    rtl = in_rtl(binp, BUDGET)
    qemu = in_qemu(binp, BUDGET, chk=True)

    bad = 0
    for i in range(16):
        if rtl["regs"][i] != qemu[i]:
            print(f"  ❌ R{i}: RTL {rtl['regs'][i]:08X}, QEMU {qemu[i]:08X}")
            bad += 1
    if bad:
        print(f"\nрасхождений: {bad}")
        return 1
    done = rtl["regs"][5]
    print(f"  ✅ CHK: 16 регистров сошлись после {BUDGET} команд "
          f"(сделано итераций: {1000000 - done})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
