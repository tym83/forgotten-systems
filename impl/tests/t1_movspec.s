; T1.8 — особые формы MOV (u=1).
        MOV  R0, 0
        MOV  R1, 5
; --- MOVH: чтение регистра H
        MUL  R2, R1, R1          ; H := 0
        MOVH R3
; EXPECT R3 = 0
        MOV  R4, 0
        MHI  R4, 0x0001
        MUL  R5, R4, R4          ; 0x10000^2 -> H = 1
        MOVH R3
; EXPECT R3 = 1
; --- MHI: непосредственное в старшую половину
        MHI  R6, 0xBEEF
; EXPECT R6 = 3203334144         ; 0xBEEF0000
        MHI  R6, 0
; EXPECT R6 = 0
        HALT
