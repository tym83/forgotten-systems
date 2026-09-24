#!/usr/bin/env python3
"""
Мини-ассемблер RISC5 (Project Oberon).

Кодирование по архитектурной справке, сверенной с RISC.v:
  F0  00u0 | a | b | op |   (12 бит не исп.)   | 0000 | c     регистр-регистр
  F1  01uv | a | b | op |            n (16)                   регистр-непосредственное
  F2  10uv | a | b |              off (20)                    load/store
  F3  110v | cond |     (20 бит)      | 0000 | c              ветвление по регистру
  F3  111v | cond |            off (24)                       ветвление по смещению

Назначение: направленные тесты ISA (см. HARNESS.md). Не оптимизирующий, не полный
ассемблер — ровно столько, сколько нужно для тестов и для листингов в статью.
"""
import re, sys, struct

OPS = {  # op-код в битах 19:16
    'MOV':0, 'LSL':1, 'ASR':2, 'ROR':3,
    'AND':4, 'ANN':5, 'IOR':6, 'XOR':7,
    'ADD':8, 'SUB':9, 'MUL':10,'DIV':11,
    'FAD':12,'FSB':13,'FML':14,'FDV':15,
}
# формы с u=1
OPS_U = {'ADC':8, 'SBC':9, 'UMUL':10}

COND = {
    'MI':0x0,'EQ':0x1,'CS':0x2,'VS':0x3,'LS':0x4,'LT':0x5,'LE':0x6,'':0x7,
    'PL':0x8,'NE':0x9,'CC':0xA,'VC':0xB,'HI':0xC,'GE':0xD,'GT':0xE,'NV':0xF,
}

# ⚠ ОПРОВЕРГНУТО РЕВЬЮ (см. design/REVIEW.md, ревьюер 2, п.2).
# Исходное допущение «в F0 бит 28 всегда 0, там 32 свободных слота» — НЕВЕРНО.
# По RISC5.v:68-71  p=IR[31] q=IR[30] u=IR[29] v=IR[28], формат F0 = 00uv, и бит 28
# уже используется: ORG.Floor -> Put0(Fad+V), ORG.Float -> Put0(Fad+U) (ORG.Mod:928-934).
# Все 16 значений op заняты. Ловушки на неизвестную инструкцию в RISC5 НЕТ ВООБЩЕ —
# любое 32-битное слово валидно, поэтому неверное кодирование выполнится молча.
#
# Новое кодирование (требует явного сужения декода в RTL:
#   assign FML = ~p & (op==14) & ~v;  ):
#   FMAC -> F0, op=14 (Fml), v=1   — переиспользуем don't-care бит, а не "свободный слот"
#   CHK  -> ТРЕБУЕТ формы F1 с 16-битным непосредственным пределом, иначе экономия НУЛЕВАЯ
#           (предел массива — константа, сегодня она идёт в immediate поле Cmp)
# Окончательное кодирование не зафиксировано до сведения всех пяти ревью.
EXT_UNRESOLVED = True


class AsmError(Exception):
    pass


def reg(tok):
    m = re.fullmatch(r'R(\d{1,2})', tok.upper())
    if not m:
        raise AsmError(f'ожидался регистр, получено {tok!r}')
    n = int(m.group(1))
    if not 0 <= n <= 15:
        raise AsmError(f'регистр вне диапазона: {tok}')
    return n


def imm(tok, bits, signed=True):
    tok = tok.strip()
    v = int(tok, 0)
    if signed:
        lo, hi = -(1 << (bits - 1)), (1 << (bits - 1)) - 1
    else:
        lo, hi = 0, (1 << bits) - 1
    if not lo <= v <= hi:
        raise AsmError(f'непосредственное {v} не влезает в {bits} бит '
                       f'({"знаковое" if signed else "беззнаковое"})')
    return v & ((1 << bits) - 1)


def is_reg(tok):
    return re.fullmatch(r'[Rr]\d{1,2}', tok.strip()) is not None


def enc_f0(u, a, b, op, c):
    return ((0b0000 | (u << 1)) << 28) | (a << 24) | (b << 20) | (op << 16) | c


def enc_f1(u, v, a, b, op, n):
    return ((0b0100 | (u << 1) | v) << 28) | (a << 24) | (b << 20) | (op << 16) | (n & 0xFFFF)


def enc_f2(u, v, a, b, off):
    return ((0b1000 | (u << 1) | v) << 28) | (a << 24) | (b << 20) | (off & 0xFFFFF)


def enc_f3_reg(v, cond, c):
    return ((0b1100 | v) << 28) | (cond << 24) | c


def enc_f3_off(v, cond, off):
    return ((0b1110 | v) << 28) | (cond << 24) | (off & 0xFFFFFF)


class Assembler:
    def __init__(self):
        self.labels = {}
        self.expects = []   # (индекс_слова, текст) — проверки для оснастки

    def assemble(self, text):
        lines = self._parse(text)
        self._pass1(lines)
        return self._pass2(lines), self.labels, self.expects

    # --- разбор -------------------------------------------------------
    def _parse(self, text):
        out = []
        for lineno, raw in enumerate(text.splitlines(), 1):
            # ; EXPECT ... — директива оснастки, не код
            m = re.match(r'\s*;\s*EXPECT\s+(.*)', raw, re.I)
            if m:
                out.append(('expect', m.group(1).strip(), lineno))
                continue
            line = raw.split(';')[0].strip()
            if not line:
                continue
            m = re.match(r'([A-Za-z_]\w*):\s*(.*)', line)
            if m:
                out.append(('label', m.group(1), lineno))
                line = m.group(2).strip()
                if not line:
                    continue
            out.append(('insn', line, lineno))
        return out

    def _pass1(self, lines):
        pc = 0
        for kind, val, lineno in lines:
            if kind == 'label':
                if val in self.labels:
                    raise AsmError(f'строка {lineno}: метка {val} уже определена')
                self.labels[val] = pc
            elif kind == 'insn':
                pc += 4

    def _pass2(self, lines):
        words = []
        for kind, val, lineno in lines:
            if kind == 'expect':
                self.expects.append((len(words), val))
            elif kind == 'insn':
                try:
                    words.append(self._encode(val, len(words) * 4))
                except AsmError as e:
                    raise AsmError(f'строка {lineno}: {e}\n  {val}')
        return words

    # --- кодирование --------------------------------------------------
    def _encode(self, line, pc):
        parts = re.split(r'[\s,]+', line.strip())
        mn = parts[0].upper()
        args = [p for p in parts[1:] if p]

        if mn == 'HALT':                 # псевдо: B .  (бесконечный цикл)
            return enc_f3_off(0, COND[''], -1)
        if mn == 'NOP':                  # псевдо: MOV R0, R0
            return enc_f0(0, 0, 0, OPS['MOV'], 0)
        if mn == 'WORD':                 # сырое слово
            return int(args[0], 0) & 0xFFFFFFFF

        # --- расширения проекта: ЗАБЛОКИРОВАНЫ до пересмотра кодирования
        if mn in ('FMAC', 'CHK'):
            raise AsmError(
                f'{mn}: кодирование опровергнуто ревью и не зафиксировано заново. '
                'См. design/REVIEW.md, ревьюер 2, п.2 и п.3.')

        # --- память
        if mn in ('LD', 'LDB', 'ST', 'STB'):
            u = 1 if mn.startswith('ST') else 0
            v = 1 if mn.endswith('B') else 0
            if len(args) != 3:
                raise AsmError(f'{mn} требует a, b, off')
            return enc_f2(u, v, reg(args[0]), reg(args[1]), imm(args[2], 20))

        # --- ветвления
        m = re.fullmatch(r'(B|BL)(MI|EQ|CS|VS|LS|LT|LE|PL|NE|CC|VC|HI|GE|GT|NV)?', mn)
        if m:
            v = 1 if m.group(1) == 'BL' else 0
            cond = COND[m.group(2) or '']
            if len(args) != 1:
                raise AsmError(f'{mn} требует один аргумент')
            tgt = args[0]
            if is_reg(tgt):
                return enc_f3_reg(v, cond, reg(tgt))
            if tgt in self.labels:
                # PC = PC + 4 + off*4  ->  off = (target - pc - 4) / 4
                off = (self.labels[tgt] - pc - 4) // 4
            else:
                off = int(tgt, 0)
            if not -(1 << 23) <= off <= (1 << 23) - 1:
                raise AsmError(f'смещение ветвления {off} вне 24-битного диапазона')
            return enc_f3_off(v, cond, off)

        # --- MHI (F1, u=1, op=MOV)
        if mn == 'MHI':
            if len(args) != 2:
                raise AsmError('MHI требует a, n')
            return enc_f1(1, 0, reg(args[0]), 0, OPS['MOV'], imm(args[1], 16, signed=False))

        # --- MOV a, H  (F0, u=1, op=MOV, b=0)
        if mn == 'MOVH':
            if len(args) != 1:
                raise AsmError('MOVH требует a')
            return enc_f0(1, reg(args[0]), 0, OPS['MOV'], 0)

        # TODO(verify): MOV a, NZCV — в справке помечено v=1, но F0 имеет v=0
        # постоянно. Кодирование неоднозначно; не реализуем, пока не сверено с RISC.v.

        # --- регистровые/непосредственные
        op = OPS.get(mn)
        u = 0
        if op is None:
            op = OPS_U.get(mn)
            if op is None:
                raise AsmError(f'неизвестная мнемоника {mn}')
            u = 1

        if mn == 'MOV':
            if len(args) != 2:
                raise AsmError('MOV требует a, n')
            a, src = reg(args[0]), args[1]
            if is_reg(src):
                return enc_f0(0, a, 0, OPS['MOV'], reg(src))
            val = int(src, 0)
            v = 1 if val < 0 else 0
            return enc_f1(0, v, a, 0, OPS['MOV'], imm(src, 16))

        if len(args) != 3:
            raise AsmError(f'{mn} требует a, b, n')
        a, b, src = reg(args[0]), reg(args[1]), args[2]
        if is_reg(src):
            return enc_f0(u, a, b, op, reg(src))
        val = int(src, 0)
        v = 1 if val < 0 else 0
        return enc_f1(u, v, a, b, op, imm(src, 16))


def assemble(text):
    return Assembler().assemble(text)


# ---------------------------------------------------------------- самотест
SELFTEST = r'''
start:  MOV  R0, 0
        MOV  R1, 100
        ST   R1, R0, 0
        MOV  R2, -1
        LD   R3, R0, 0
; EXPECT R3 = 100
; EXPECT Z = 0
        ADD  R4, R3, R1
        SUB  R5, R4, 1
        MUL  R6, R1, R1
        MOVH R7
        FAD  R8, R1, R2
        LSL  R10, R1, 4
        ASR  R11, R1, 2
loop:   SUB  R1, R1, 1
        BNE  loop
        BL   subr
        HALT
subr:   MOV  R12, 7
        B    R15
'''

def _selftest():
    words, labels, expects = assemble(SELFTEST)
    print(f'собрано слов: {len(words)}')
    print(f'метки: {labels}')
    print(f'проверок EXPECT: {len(expects)} -> {expects}')
    print()
    for i, w in enumerate(words):
        print(f'  {i*4:04X}: {w:08X}   {w>>28:04b} {(w>>24)&0xF:04b} '
              f'{(w>>20)&0xF:04b} {(w>>16)&0xF:04b}')

    fails = []
    def chk(name, got, want):
        if got != want:
            fails.append(f'{name}: получено {got:08X}, ожидалось {want:08X}')

    # Разбор кодирования: [31:28] формат | [27:24] a | [23:20] b | [19:16] op | остальное
    # MOV R0,0    F1 u=0 v=0 -> 0100 | a=0 | b=0 | op=0 | n=0
    chk('MOV R0,0',      words[0],  0x40000000)
    # MOV R1,100  0100 | a=1 | b=0 | op=0 | n=0x64
    chk('MOV R1,100',    words[1],  0x41000064)
    # ST R1,R0,0  F2 u=1 v=0 -> 1010 | a=1 | b=0 | off=0
    chk('ST R1,R0,0',    words[2],  0xA1000000)
    # MOV R2,-1   F1 u=0 v=1 -> 0101 | a=2 | b=0 | op=0 | n=0xFFFF
    chk('MOV R2,-1',     words[3],  0x5200FFFF)
    # LD R3,R0,0  F2 u=0 v=0 -> 1000 | a=3 | b=0 | off=0
    chk('LD R3,R0,0',    words[4],  0x83000000)
    # ADD R4,R3,R1 F0 u=0 -> 0000 | a=4 | b=3 | op=8 | c=1
    chk('ADD R4,R3,R1',  words[5],  0x04380001)
    # MUL R6,R1,R1 F0 -> 0000 | a=6 | b=1 | op=10 | c=1
    chk('MUL R6,R1,R1',  words[7],  0x061A0001)
    # MOVH R7     F0 u=1 -> 0010 | a=7 | b=0 | op=0 | c=0
    chk('MOVH R7',       words[8],  0x27000000)
    # BNE loop  pc=0x34, loop=0x30 -> off=-2; 1110 | cond=NE(9) | 0xFFFFFE
    chk('BNE loop',      words[13], 0xE9FFFFFE)
    # BL subr -> off=1; 1111 | cond=always(7) | 1
    chk('BL subr',       words[14], 0xF7000001)
    # HALT = B .  -> 1110 | 7 | off=-1
    chk('HALT',          words[15], 0xE7FFFFFF)
    # B R15  F3 reg v=0 -> 1100 | cond=7 | c=15
    chk('B R15',         words[17], 0xC700000F)

    print()
    if fails:
        print('❌ САМОТЕСТ ПРОВАЛЕН:')
        for f in fails: print('   ', f)
        return 1
    print('✅ самотест пройден')
    return 0


def main():
    import json, os
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest':
        sys.exit(_selftest())
    if len(sys.argv) < 2:
        print('использование: asm.py FILE.s [-o OUT]  ->  OUT.bin + OUT.chk', file=sys.stderr)
        sys.exit(1)
    src_path = sys.argv[1]
    out = sys.argv[3] if len(sys.argv) > 3 and sys.argv[2] == '-o' else os.path.splitext(src_path)[0]
    words, labels, expects = assemble(open(src_path).read())
    with open(out + '.bin', 'wb') as f:
        for w in words:
            f.write(struct.pack('<I', w))
    with open(out + '.chk', 'w') as f:
        json.dump({'n_words': len(words), 'labels': labels,
                   'expects': [{'at': i, 'expr': e} for i, e in expects]}, f, indent=1)
    print(f'{out}.bin: {len(words)} слов, {len(expects)} проверок')


if __name__ == '__main__':
    main()
