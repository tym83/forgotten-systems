; Сверка плавающей точки с эталоном.
; Значения лежат в том же ПЗУ по слову 64 (адрес FFE100) — так их не надо
; класть в память отдельно, программа и данные приезжают одним файлом.
        MOV R14, 0xFFE1
        LSL R14, R14, 8        ; 0xFFE100 — вход
        MOV R13, 0x1000
        LSL R13, R13, 4        ; 0x10000 — выход
        MOV R10, 0
outer:  MOV R11, 0
inner:  LSL R0, R10, 2
        ADD R0, R14, R0
        LD  R1, R0, 0
        LSL R0, R11, 2
        ADD R0, R14, R0
        LD  R2, R0, 0
        FAD R3, R1, R2
        ST  R3, R13, 0
        MOV R5, 0x8000
        LSL R5, R5, 16
        XOR R4, R2, R5
        FAD R3, R1, R4
        ST  R3, R13, 4
        FML R3, R1, R2
        ST  R3, R13, 8
        FDV R3, R1, R2
        ST  R3, R13, 12
        ADD R13, R13, 16
        ADD R11, R11, 1
        SUB R0, R11, 16
        BNE inner
        ADD R10, R10, 1
        SUB R0, R10, 16
        BNE outer
        MOV R10, 0
conv:   LSL R0, R10, 2
        ADD R0, R14, R0
        LD  R1, R0, 0
        MOV R6, 0              ; ⚠ второй операнд у переводов — НОЛЬ
        FLT R3, R1, R6
        ST  R3, R13, 0
        FLOOR R3, R1, R6
        ST  R3, R13, 4
        ADD R13, R13, 8
        ADD R10, R10, 1
        SUB R0, R10, 16
        BNE conv
done:   B done
