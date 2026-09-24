#!/usr/bin/env python3
"""Семантический дифференциал: модель АЛУ против железа на случайных программах.

Замыкает последнюю дыру. Круг «ассемблер → дизассемблер → ассемблер» слеп к
общей ошибке раскладки полей: обе стороны пользуются одной. Здесь цепочка
другая и общей раскладки в ней нет:

  мнемоника --[ассемблер]--> слово --[модель, написана отдельно по RISC5.v]--> предсказание
                                   --[железо]--> результат

Проверяется двоякое:
  1. предсказание модели совпадает с железом (результат И все четыре флага) —
     это привязывает модель к машине;
  2. модель, разобрав слово, называет ту же операцию, что мы просили у
     ассемблера — это привязывает ассемблер к модели.
Вместе цепочка замкнута: ошибка в раскладке полей ассемблера сломала бы
пункт 2, ошибка в понимании семантики — пункт 1.
"""
import random, sys
sys.path.insert(0, "tools")
import asm
from alu_model import State, step, decode

REGS = list(range(1, 12))          # R12 — MT, R15 — связь: не трогаем
SEED = 20260923                    # фиксирован, чтобы прогон воспроизводился
CASES = 900

REG_OPS = ['LSL', 'ASR', 'ROR', 'AND', 'ANN', 'IOR', 'XOR',
           'ADD', 'SUB', 'ADC', 'SBC', 'MUL', 'UMUL', 'DIV', 'UDIV']
# Формы с непосредственным операндом: бит v задаёт заполнение старшей половины,
# поэтому знак числа выбирается вместе с формой.
IMM_OPS = ['LSL', 'ASR', 'ROR', 'AND', 'ANN', 'IOR', 'XOR', 'ADD', 'SUB',
           'ADC', 'SBC', 'MUL', 'DIV', 'ADD.uv', 'SUB.uv', 'AND.uv']
MOV_FORMS = ['reg', 'imm', 'mhi', 'H', 'NZCV']


def load(rng, reg, val):
    """Загрузить 32-битную константу: MHI задаёт старшую половину, IOR доливает."""
    return [f"        MHI  R{reg}, 0x{(val >> 16) & 0xFFFF:04X}",
            f"        IOR  R{reg}, R{reg}, 0x{val & 0xFFFF:04X}"]


TOTAL = {"f": 0, "w": 0, "e": 0}
HEAD = None


def flush(lines, words, final=False, st=None):
    """Закрыть текущий файл и начать следующий: программа не должна выйти за ROOM.

    Состояние модели обнуляется: каждый файл железо начинает со сброса, и
    регистры, флаги и H там нули. Без этого перенос C, V и H через границу
    файла давал бы ложные расхождения.
    """
    TOTAL["f"] += 1
    n = TOTAL["f"]
    lines.append("        HALT")
    text = "\n".join(lines) + "\n"
    path = f"tests/t1_alu_diff{n}.s"
    open(path, "w").write(text)
    n_exp = sum(1 for l in lines if l.startswith("; EXPECT"))
    TOTAL["w"] += len(words) + 1
    TOTAL["e"] += n_exp
    print(f"  {path}: {len(words)+1} слов, {n_exp} проверок")
    if final:
        return None, None
    if st is not None:
        st.__init__()
    return list(HEAD), []


def main():
    rng = random.Random(SEED)
    lines, st, mism = [], State(), []
    lines.append("; T1.19 — семантический дифференциал (СГЕНЕРИРОВАН tools/gen_alu_diff.py).")
    lines.append(f"; Зерно {SEED}, случаев {CASES}. Ожидания посчитаны моделью tools/alu_model.py,")
    lines.append("; написанной по RISC5.v независимо от ассемблера. Проверяются результат и флаги.")
    lines.append("")
    global HEAD
    HEAD = list(lines)

    # Счётчик команд 22-битный, а программа лежит по ORG = 0xFFE000: от него до
    # края адресного пространства помещается ровно 2048 слов. Поэтому режем
    # дифференциал на файлы с запасом.
    ROOM = 1980
    words = []
    def emit(text):
        w = asm.assemble("        " + text.strip() + "\n")[0][0]
        words.append(w)
        if not step(st, w):
            sys.exit(f"модель не поддержала: {text}")
        return w

    for _ in range(CASES):
        if len(words) > ROOM:
            lines, words = flush(lines, words, st=st)
        kind = rng.choice(['reg'] * 5 + ['imm'] * 4 + ['mov'] * 2)

        if kind == 'mov':
            form = rng.choice(MOV_FORMS)
            a = rng.choice(REGS)
            if form == 'reg':
                c = rng.choice(REGS); vc = rng.getrandbits(32)
                for t in load(rng, c, vc): lines.append(t); emit(t)
                text = f"MOV  R{a}, R{c}"
            elif form == 'imm':
                n = rng.choice([rng.randint(0, 0xFFFF), rng.randint(-0x10000, -1)])
                text = f"MOV  R{a}, {n}"
            elif form == 'mhi':
                text = f"MHI  R{a}, 0x{rng.getrandbits(16):04X}"
            else:
                text = f"MOV  R{a}, {form}"
            lines.append("        " + text); emit(text)
            lines += [f"; EXPECT R{a} = 0x{st.R[a]:08X}",
                      f"; EXPECT N = {st.N}", f"; EXPECT Z = {st.Z}",
                      f"; EXPECT C = {st.C}", f"; EXPECT V = {st.V}", ""]
            continue

        if kind == 'imm':
            mn = rng.choice(IMM_OPS)
            b, a = rng.choice(REGS), rng.choice(REGS)
            vb = rng.getrandbits(32)
            if mn.endswith('.uv'):
                n = rng.randint(-0x10000, -1)       # суффикс задаёт v=1
            elif mn == 'DIV':
                n = rng.randint(1, 0xFFFF)          # делитель рассчитан на y > 0
            elif mn in ('LSL', 'ASR', 'ROR'):
                n = rng.randint(0, 31)
            elif mn in ('ADC', 'SBC'):
                # псевдоним фиксирует v=0, поэтому отрицательное недостижимо:
                # такую форму надо писать как ADD.uv / SUB.uv
                n = rng.randint(0, 0xFFFF)
            else:
                n = rng.choice([rng.randint(0, 0xFFFF), rng.randint(-0x10000, -1)])
            for t in load(rng, b, vb): lines.append(t); emit(t)
            text = f"{mn}  R{a}, R{b}, {n}"
            lines.append("        " + text)
            w = emit(text)
            op, u, v, q, da = decode(w)
            want = {'ADC': ('ADD', 1), 'SBC': ('SUB', 1),
                    'ADD.uv': ('ADD', 1), 'SUB.uv': ('SUB', 1),
                    'AND.uv': ('AND', 1)}.get(mn, (mn, 0))
            if (op, u) != want or da != a or q != 1:
                mism.append(f"{text}: слово {w:08X}, модель читает {op} u={u} "
                            f"q={q} a={da}, ожидалось {want} q=1 a={a}")
            lines += [f"; EXPECT R{a} = 0x{st.R[a]:08X}",
                      f"; EXPECT N = {st.N}", f"; EXPECT Z = {st.Z}",
                      f"; EXPECT C = {st.C}", f"; EXPECT V = {st.V}"]
            if mn in ('MUL', 'DIV'):
                lines.append(f"; EXPECT H = 0x{st.H:08X}")
            lines.append("")
            continue

        mn = rng.choice(REG_OPS)
        b = rng.choice(REGS)
        c = rng.choice([r for r in REGS if r != b])   # разные регистры операндов
        a = rng.choice(REGS)                          # приёмник может совпасть с любым
        vb = rng.getrandbits(32)
        if mn in ('DIV', 'UDIV'):
            vc = rng.randint(1, 0x7FFFFFFF)          # делитель рассчитан на y > 0
        else:
            vc = rng.getrandbits(32)
        for t in load(rng, b, vb): lines.append(t); emit(t)
        for t in load(rng, c, vc): lines.append(t); emit(t)
        text = f"{mn}  R{a}, R{b}, R{c}"
        lines.append("        " + text)
        w = emit(text)
        # пункт 2: модель, разобрав слово, должна назвать ту же операцию
        op, u, v, q, da = decode(w)
        want = {'ADC': ('ADD', 1), 'SBC': ('SUB', 1),
                'UMUL': ('MUL', 1), 'UDIV': ('DIV', 1)}.get(mn, (mn, 0))
        if (op, u) != want or da != a:
            mism.append(f"{text}: ассемблер дал {w:08X}, модель читает "
                        f"{op} u={u} a={da}, ожидалось {want} a={a}")
        lines += [f"; EXPECT R{a} = 0x{st.R[a]:08X}",
                  f"; EXPECT N = {st.N}", f"; EXPECT Z = {st.Z}",
                  f"; EXPECT C = {st.C}", f"; EXPECT V = {st.V}"]
        if mn in ('MUL', 'UMUL', 'DIV', 'UDIV'):
            lines.append(f"; EXPECT H = 0x{st.H:08X}")
        lines.append("")

    flush(lines, words, final=True, st=st)
    print(f"всего {CASES} случаев, {TOTAL['w']} слов, {TOTAL['e']} проверок "
          f"в {TOTAL['f']} файлах")
    if mism:
        print(f"❌ ассемблер и модель разошлись в {len(mism)} случаях:")
        for m in mism[:8]: print("   ", m)
        return 1
    print("✅ ассемблер и модель согласны в разборе всех порождённых слов")
    return 0


if __name__ == "__main__":
    sys.exit(main())
