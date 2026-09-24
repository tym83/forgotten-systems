; T1-FLAGS — N и Z ставятся при ЛЮБОЙ записи в регистр.
; RISC5.v:127  regwr = ~p & ~stall | (LDR & ...) | (BR & cond & v & ...)
; Третий член — принятый BL/BLR пишет R15, значит тоже ставит флаги. Это находка ревью.
        MOV  R0, 0
        MOV  R1, 100
; --- обычная арифметика
        SUB  R2, R1, R1
; EXPECT Z = 1
; EXPECT N = 0
        SUB  R2, R0, R1
; EXPECT Z = 0
; EXPECT N = 1
; --- ЗАГРУЗКА тоже ставит флаги
        ST   R1, R0, 0
        MOV  R3, 0
        ST   R3, R0, 4
        SUB  R4, R0, R1        ; портим флаги: N=1, Z=0
        LD   R5, R0, 0         ; грузим 100
; EXPECT Z = 0
; EXPECT N = 0
; EXPECT R5 = 100
        SUB  R4, R0, R1        ; снова N=1
        LD   R6, R0, 4         ; грузим 0
; EXPECT Z = 1
; EXPECT N = 0
; --- ХРАНЕНИЕ флаги НЕ трогает (regwr = 0)
        SUB  R4, R0, R1        ; N=1, Z=0
        ST   R1, R0, 8
; EXPECT N = 1
; EXPECT Z = 0
; --- ПРИНЯТЫЙ BL затирает N и Z (пишет R15)
        SUB  R4, R0, R1        ; N=1, Z=0
        BL   tgt
tgt:
; EXPECT N = 0
; EXPECT Z = 0
        HALT
