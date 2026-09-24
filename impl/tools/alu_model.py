#!/usr/bin/env python3
"""Модель целочисленного ядра RISC5, написанная по RISC5.v.

Нужна для семантического дифференциала: круг «ассемблер → дизассемблер →
ассемблер» пользуется одной раскладкой полей в обе стороны и общую ошибку в
ней не видит. Модель раскладку НЕ разделяет — она написана отдельно, по тексту
верилога, и сверяется с железом по результату и флагам.

Источники в RISC5.v:
  aluRes — таблица операций;
  nn = regwr ? aluRes[31] : N          — знак
  zz = regwr ? (aluRes == 0) : Z       — ноль
  cx = ADD ? (~sb&sc&~sa)|(sb&sc&sa)|(sb&~sa)
     : SUB ? (~sb&sc&~sa)|(sb&sc&sa)|(~sb&sa) : C
  vv = ADD ? (sa&~sb&~sc)|(~sa&sb&sc)
     : SUB ? (sa&~sb&sc)|(~sa&sb&~sc) : OV
  где sa = aluRes[31], sb = B[31], sc = C1[31]
  H <= MUL ? product[63:32] : DIV ? remainder : H
Умножитель и делитель получают ИНВЕРТИРОВАННОЕ u (RISC5.v:54,57), поэтому
u=0 — знаковые операции, u=1 — беззнаковая (делитель) и смешанная (умножитель).
"""
M32 = 0xFFFFFFFF


def s32(x): return x - (1 << 32) if x & 0x80000000 else x


class State:
    def __init__(self):
        self.R = [0] * 16
        self.N = self.Z = self.C = self.V = 0
        self.H = 0


OPNAME = ['MOV','LSL','ASR','ROR','AND','ANN','IOR','XOR',
          'ADD','SUB','MUL','DIV','FAD','FSB','FML','FDV']


def decode(w):
    """Имя операции и признаки — по полям, прочитанным независимо от ассемблера."""
    w &= M32
    if (w >> 31) & 1:
        return None
    return (OPNAME[(w >> 16) & 0xF], (w >> 29) & 1, (w >> 28) & 1,
            (w >> 30) & 1, (w >> 24) & 0xF)          # op, u, v, q(непосредств.), a


def step(st, w):
    """Исполнить одно слово формата F0/F1. Возвращает False, если не поддержано."""
    w &= M32
    p, q, u, v = (w >> 31) & 1, (w >> 30) & 1, (w >> 29) & 1, (w >> 28) & 1
    if p:
        return False                                   # память и переходы вне модели
    a, b, op, c = (w >> 24) & 0xF, (w >> 20) & 0xF, (w >> 16) & 0xF, w & 0xF
    imm = w & 0xFFFF

    B = st.R[b]
    C0 = st.R[c]
    C1 = ((0xFFFF0000 if v else 0) | imm) if q else C0   # C1 = q ? {{16{v}},imm} : C0

    if op == 0:                                         # MOV
        if q:
            res = (imm << 16) & M32 if u else C1
        elif not u:
            res = C0
        else:
            res = st.H if not v else (
                (st.N << 31) | (st.Z << 30) | (st.C << 29) | (st.V << 28) | 0x53)
    elif op == 1: res = (B << (C1 & 31)) & M32                       # LSL
    elif op == 2:                                                    # ASR
        sc_ = C1 & 31
        res = ((s32(B) >> sc_) if sc_ else B) & M32
    elif op == 3:                                                    # ROR
        sc_ = C1 & 31
        res = ((B >> sc_) | (B << (32 - sc_))) & M32 if sc_ else B
    elif op == 4: res = B & C1
    elif op == 5: res = B & (~C1 & M32)
    elif op == 6: res = B | C1
    elif op == 7: res = B ^ C1
    elif op == 8: res = (B + C1 + (st.C if u else 0)) & M32          # ADD / ADC
    elif op == 9: res = (B - C1 - (st.C if u else 0)) & M32          # SUB / SBC
    elif op == 10:                                                   # MUL / UMUL
        # умножитель складывает по битам x сдвинутое y со ЗНАКОМ, а при u=1
        # (инструкция u=0) вычитает поправку на знак x -> знаковое умножение
        prod = (s32(B) if not u else B) * s32(C1)
        res = prod & M32
        st.H = (prod >> 32) & M32
    elif op == 11:                                                   # DIV / UDIV
        if C1 == 0:
            return False                                # деление на ноль вне модели
        if u:
            res, st.H = (B // C1) & M32, (B % C1) & M32
        else:
            x, y = s32(B), s32(C1)
            if y <= 0:
                return False                            # делитель рассчитан на y > 0
            res, st.H = (x // y) & M32, (x % y) & M32   # деление с округлением вниз
    else:
        return False                                    # плавающая точка вне модели

    sa, sb, sc_ = (res >> 31) & 1, (B >> 31) & 1, (C1 >> 31) & 1
    if op == 8:
        st.C = (~sb & sc_ & ~sa) | (sb & sc_ & sa) | (sb & ~sa)
        st.V = (sa & ~sb & ~sc_) | (~sa & sb & sc_)
    elif op == 9:
        st.C = (~sb & sc_ & ~sa) | (sb & sc_ & sa) | (~sb & sa)
        st.V = (sa & ~sb & sc_) | (~sa & sb & ~sc_)
    st.C &= 1; st.V &= 1
    st.N, st.Z = sa, int(res == 0)
    st.R[a] = res
    return True
