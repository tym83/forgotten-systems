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
RESET_PC = 0x00FFE000    # адрес сброса: с него начинается любая программа
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
    # ⚠ Журнал НЕ ложится на диск. `-d cpu` с one-insn-per-tb пишет ~230 байт
    # на команду, а программа после полезной части крутится в пустом цикле —
    # за минуту это десятки гигабайт. Один раз так и вышло: журнал забил диск
    # виртуалки докера до отказа, containerd перестал писать даже собственную
    # базу, и чинилось это только пересозданием машины.
    #
    # Поэтому журнал идёт в конвейер: `head` берёт свой кусок и закрывает
    # трубу, QEMU получает SIGPIPE и умирает сам. На диск не попадает ничего.
    #
    # ⚠ И без one-insn-per-tb состояние печатается на КАЖДЫЙ БЛОК трансляции,
    # а не на команду: счётчики перестают совпадать, и сравнение молча съезжает.
    # ⚠ `timeout` всё равно нужен: QEMU не умирает от SIGPIPE молча и может
    # остаться крутиться с закрытой трубой. Проверено — контейнер висел.
    cmd = (f"cd /src && timeout 60 ./build/qemu-system-risc5 -M oberon{flag} "
           f"-accel tcg,one-insn-per-tb=on "
           f"-bios prog.bin -nographic -monitor none -serial none "
           f"-d cpu -D /dev/stdout 2>/dev/null | head -c {(budget + 8) * 400}")
    out = subprocess.run(["docker", "run", "--rm", "-v", f"{QEMU}:/src",
                          "qemu-build:risc5", cmd], capture_output=True, text=True)
    text = out.stdout
    # 400 байт на команду — с запасом: настоящий размер записи ~310,
    # и на нехватке проверка честно падает, а не сравнивает не то.
    blocks = text.split("PC   ")[1:]
    if not blocks:
        raise SystemExit("  ❌ журнал QEMU пуст")
    return blocks


def state_at(blocks, idx):
    """Регистры и счётчик команд из записи журнала."""
    blk = blocks[idx]
    regs = {int(m[0]): int(m[1], 16) for m in re.findall(r"R(\d+)\s+([0-9a-f]{8})", blk)}
    pc = int(re.match(r"([0-9a-f]{8})", blk).group(1), 16)
    return [regs.get(i, -1) for i in range(16)], pc


def aligned(blocks, budget, want_pc):
    """Запись, соответствующая состоянию модели после `budget` команд.

    ⚠ Номер записи НЕ вычисляется по формуле. QEMU печатает состояние перед
    исполнением блока, модель считает после исполненной команды, и у разных
    сборок первая запись разная: зашитый сдвиг сходился локально и разъезжался
    на прогоне в CI. Ошибка при этом выглядит как расхождение ровно одного
    регистра — того, который пишет соседняя команда.
    
    Поэтому запись ищется по счётчику команд в окрестности ±2 записей. Тело
    цикла длиннее, так что совпадение в этом окне единственно.
    """
    hits = [k for k in range(max(0, budget - 2), min(len(blocks), budget + 3))
            if state_at(blocks, k)[1] == want_pc]
    if len(hits) != 1:
        return None, hits
    return hits[0], hits


def main():
    # Берём ту же копию, что уезжает на страницу: в tests/ файл порождаемый и
    # в свежем дереве его нет.
    binp = IMPL / "web/bench_bounds_e.bin"
    if not binp.exists():
        raise SystemExit("  ❌ нет web/bench_bounds_e.bin — соберите: make -C impl web")

    rtl = in_rtl(binp, BUDGET)
    blocks = in_qemu(binp, BUDGET, chk=True)
    idx, hits = aligned(blocks, BUDGET, rtl["pc"])
    if idx is None:
        print(f"  ❌ в журнале QEMU нет записи с адресом {rtl['pc']:08X} "
              f"рядом с {BUDGET}-й командой (подошло записей: {len(hits)})")
        return 1
    qemu, qpc = state_at(blocks, idx)

    bad = 0
    for i in range(16):
        if rtl["regs"][i] != qemu[i]:
            print(f"  ❌ R{i}: RTL {rtl['regs'][i]:08X}, QEMU {qemu[i]:08X}")
            bad += 1
    if bad:
        print(f"\nрасхождений: {bad}")
        return 1
    done = rtl["regs"][5]
    print(f"  ✅ CHK: 16 регистров сошлись на {rtl['pc']:08X} после {BUDGET} команд "
          f"(сделано итераций: {1000000 - done}, запись журнала {idx})")

    # Отрицательный контроль. Проверка, которая не умеет краснеть, ничего не
    # проверяет: гоняем ту же программу на машине БЕЗ расширения — там эта
    # кодировка означает другое, и состояния обязаны разойтись.
    plain_blocks = in_qemu(binp, BUDGET, chk=False)
    plain, _ = state_at(plain_blocks, idx)
    if plain == [rtl["regs"][i] for i in range(16)]:
        print("  ❌ без расширения состояние то же — значит сверка ничего не проверяет")
        return 1
    diff = [i for i in range(16) if plain[i] != rtl["regs"][i]]
    print(f"  ✅ без расширения расходится {', '.join('R%d' % i for i in diff)} — "
          f"сверка умеет краснеть")
    return 0


if __name__ == "__main__":
    sys.exit(main())
