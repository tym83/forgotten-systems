; T1.17 — зонд безразличных битов u и v (СГЕНЕРИРОВАН tools/gen_dontcare_test.py).
; Для каждой формы: базовая (u=0,v=0) в R3, испытуемая в R4, XOR в R5.
; R5 = 0 означает, что бит безразличен и слово исполняется как базовая операция.

; ── LSL u=1 v=0 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03110002      ; LSL R3, R1, R2
        WORD 0x24110002      ; то же с u=1 v=0
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── LSL u=1 v=1 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03110002      ; LSL R3, R1, R2
        WORD 0x34110002      ; то же с u=1 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── ASR u=1 v=0 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03120002      ; ASR R3, R1, R2
        WORD 0x24120002      ; то же с u=1 v=0
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── ASR u=0 v=1 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03120002      ; ASR R3, R1, R2
        WORD 0x14120002      ; то же с u=0 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── ASR u=1 v=1 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03120002      ; ASR R3, R1, R2
        WORD 0x34120002      ; то же с u=1 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── ROR u=1 v=0 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03130002      ; ROR R3, R1, R2
        WORD 0x24130002      ; то же с u=1 v=0
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── ROR u=0 v=1 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03130002      ; ROR R3, R1, R2
        WORD 0x14130002      ; то же с u=0 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── ROR u=1 v=1 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03130002      ; ROR R3, R1, R2
        WORD 0x34130002      ; то же с u=1 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── AND u=1 v=0 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03140002      ; AND R3, R1, R2
        WORD 0x24140002      ; то же с u=1 v=0
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── AND u=0 v=1 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03140002      ; AND R3, R1, R2
        WORD 0x14140002      ; то же с u=0 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── AND u=1 v=1 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03140002      ; AND R3, R1, R2
        WORD 0x34140002      ; то же с u=1 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── ANN u=1 v=0 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03150002      ; ANN R3, R1, R2
        WORD 0x24150002      ; то же с u=1 v=0
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── ANN u=0 v=1 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03150002      ; ANN R3, R1, R2
        WORD 0x14150002      ; то же с u=0 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── ANN u=1 v=1 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03150002      ; ANN R3, R1, R2
        WORD 0x34150002      ; то же с u=1 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── IOR u=1 v=0 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03160002      ; IOR R3, R1, R2
        WORD 0x24160002      ; то же с u=1 v=0
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── IOR u=0 v=1 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03160002      ; IOR R3, R1, R2
        WORD 0x14160002      ; то же с u=0 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── IOR u=1 v=1 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03160002      ; IOR R3, R1, R2
        WORD 0x34160002      ; то же с u=1 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── XOR u=1 v=0 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03170002      ; XOR R3, R1, R2
        WORD 0x24170002      ; то же с u=1 v=0
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── XOR u=0 v=1 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03170002      ; XOR R3, R1, R2
        WORD 0x14170002      ; то же с u=0 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── XOR u=1 v=1 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x03170002      ; XOR R3, R1, R2
        WORD 0x34170002      ; то же с u=1 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── DIV u=1 v=0 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x031B0002      ; DIV R3, R1, R2
        WORD 0x241B0002      ; то же с u=1 v=0
        XOR  R5, R3, R4
; EXPECT R4 = 0x30303030   ; UDIV: беззнаковое деление

; ── DIV u=0 v=1 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x031B0002      ; DIV R3, R1, R2
        WORD 0x141B0002      ; то же с u=0 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── DIV u=1 v=1 ──
        MHI  R1, 0xF0F0
        IOR  R1, R1, 0xF0F0
        MHI  R2, 0x0000
        IOR  R2, R2, 0x0005
        WORD 0x031B0002      ; DIV R3, R1, R2
        WORD 0x341B0002      ; то же с u=1 v=1
        XOR  R5, R3, R4
; EXPECT R4 = 0x30303030   ; UDIV: бит v делителю безразличен

; ── FSB u=1 v=0 ──
        MHI  R1, 0x3FC0
        IOR  R1, R1, 0x0000
        MHI  R2, 0x4010
        IOR  R2, R2, 0x0000
        WORD 0x031D0002      ; FSB R3, R1, R2
        WORD 0x241D0002      ; то же с u=1 v=0
        XOR  R5, R3, R4
; EXPECT R4 = 0x4B3FFFFC   ; FSB.u: сумматор в режиме преобразования

; ── FSB u=0 v=1 ──
        MHI  R1, 0x3FC0
        IOR  R1, R1, 0x0000
        MHI  R2, 0x4010
        IOR  R2, R2, 0x0000
        WORD 0x031D0002      ; FSB R3, R1, R2
        WORD 0x141D0002      ; то же с u=0 v=1
        XOR  R5, R3, R4
; EXPECT R4 = 0x00500000   ; FSB.v: то же с усечением

; ── FSB u=1 v=1 ──
        MHI  R1, 0x3FC0
        IOR  R1, R1, 0x0000
        MHI  R2, 0x4010
        IOR  R2, R2, 0x0000
        WORD 0x031D0002      ; FSB R3, R1, R2
        WORD 0x341D0002      ; то же с u=1 v=1
        XOR  R5, R3, R4
; EXPECT R4 = 0x00BFFFFC   ; FSB.uv

; ── FML u=1 v=0 ──
        MHI  R1, 0x3FC0
        IOR  R1, R1, 0x0000
        MHI  R2, 0x4010
        IOR  R2, R2, 0x0000
        WORD 0x031E0002      ; FML R3, R1, R2
        WORD 0x241E0002      ; то же с u=1 v=0
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── FML u=0 v=1 ──
        MHI  R1, 0x3FC0
        IOR  R1, R1, 0x0000
        MHI  R2, 0x4010
        IOR  R2, R2, 0x0000
        WORD 0x031E0002      ; FML R3, R1, R2
        WORD 0x141E0002      ; то же с u=0 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── FML u=1 v=1 ──
        MHI  R1, 0x3FC0
        IOR  R1, R1, 0x0000
        MHI  R2, 0x4010
        IOR  R2, R2, 0x0000
        WORD 0x031E0002      ; FML R3, R1, R2
        WORD 0x341E0002      ; то же с u=1 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── FDV u=1 v=0 ──
        MHI  R1, 0x3FC0
        IOR  R1, R1, 0x0000
        MHI  R2, 0x4010
        IOR  R2, R2, 0x0000
        WORD 0x031F0002      ; FDV R3, R1, R2
        WORD 0x241F0002      ; то же с u=1 v=0
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── FDV u=0 v=1 ──
        MHI  R1, 0x3FC0
        IOR  R1, R1, 0x0000
        MHI  R2, 0x4010
        IOR  R2, R2, 0x0000
        WORD 0x031F0002      ; FDV R3, R1, R2
        WORD 0x141F0002      ; то же с u=0 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

; ── FDV u=1 v=1 ──
        MHI  R1, 0x3FC0
        IOR  R1, R1, 0x0000
        MHI  R2, 0x4010
        IOR  R2, R2, 0x0000
        WORD 0x031F0002      ; FDV R3, R1, R2
        WORD 0x341F0002      ; то же с u=1 v=1
        XOR  R5, R3, R4
; EXPECT R5 = 0

        HALT
