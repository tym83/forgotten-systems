; T1.1 — целая арифметика, включая формы с u=1 и регистр H.
        MOV  R0, 0
        MOV  R1, 100
        MOV  R2, 7
; --- MUL: младшие 32 бита в Ra, старшие в H
        MUL  R3, R1, R2
; EXPECT R3 = 700
; EXPECT H = 0
; --- MUL с переполнением: H обязан получить старшие биты
        MOV  R4, 0
        MHI  R4, 0x0001          ; R4 = 0x00010000
        MUL  R5, R4, R4          ; 0x10000 * 0x10000 = 0x1_0000_0000
; EXPECT R5 = 0
; EXPECT H = 1
; --- DIV: частное в Ra, ОСТАТОК в H
        DIV  R6, R1, R2          ; 100 / 7 = 14, остаток 2
; EXPECT R6 = 14
; EXPECT H = 2
; --- UMUL: беззнаковое умножение (u=1)
        MOV  R7, -1              ; 0xFFFFFFFF
        UMUL R8, R7, R7          ; беззнаково: 0xFFFFFFFE00000001
; EXPECT R8 = 1
; EXPECT H = 4294967295   ; НЕ 4294967294: UMUL считает второй операнд ЗНАКОВО, см. FINDING-11
; --- знаковое MUL тех же операндов: (-1)*(-1) = 1, H = 0
        MUL  R9, R7, R7
; EXPECT R9 = 1
; EXPECT H = 0
; --- ADD/SUB с переносом: ADC и SBC (u=1)
        MOV  R10, -1
        ADD  R11, R10, 1         ; 0xFFFFFFFF + 1 -> 0, перенос C=1
; EXPECT R11 = 0
; EXPECT C = 1
; EXPECT Z = 1
        MOV  R12, 5
        ADC  R13, R12, 0         ; 5 + 0 + C(=1) = 6
; EXPECT R13 = 6
        MOV  R14, 10
        SUB  R11, R14, 1         ; перенос сбрасывается
        SBC  R13, R12, 0         ; 5 - 0 - C
; --- переполнение знака
        MOV  R1, 0
        MHI  R1, 0x7FFF
        IOR  R1, R1, 0xFFFF      ; R1 = 0x7FFFFFFF (максимум)
        ADD  R2, R1, 1           ; переполнение знака
; EXPECT V = 1
; EXPECT N = 1
        HALT
