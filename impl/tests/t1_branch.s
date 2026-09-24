; T1.6 — ВСЕ 16 условий ветвления на четырёх состояниях флагов.
; Ожидаемый исход вычислен по таблице истинности из спецификации:
;   MI=N  EQ=Z  CS=C  VS=V  LS=C|Z  LT=N^V  LE=(N^V)|Z  T=1
;   старший бит условия инвертирует результат (PL, NE, CC, VC, HI, GE, GT, F)
; Состояния флагов предварительно измерены (t1_probe_flags.s).
; Схема проверки: R5 := 0 ; <установка флагов> ; B<cond> skip ; R5 := 1 ; skip:
;   Обнуление R5 идёт ПЕРВЫМ: запись в регистр сама ставит N и Z.
;   R5 = 0 -> переход СОСТОЯЛСЯ, R5 = 1 -> НЕ состоялся.
        MOV  R0, 0
        MOV  R1, 5
        MOV  R2, 7
        MOV  R4, -1
        MOV  R6, 0
        MHI  R6, 0x7FFF
        IOR  R6, R6, 0xFFFF      ; R6 = 0x7FFFFFFF, максимум со знаком
        MOV  R7, 0
        MHI  R7, 0x8000          ; R7 = 0x80000000, минимум со знаком
; ──────── S1: 5-5=0  (N=0 Z=1 C=0 V=0) ────────
        MOV  R5, 0
        SUB  R3, R1, R1
        BMI sk0
        MOV  R5, 1
sk0:
; EXPECT R5 = 1   ; MI при N=0 Z=1 C=0 V=0
        MOV  R5, 0
        SUB  R3, R1, R1
        BEQ sk1
        MOV  R5, 1
sk1:
; EXPECT R5 = 0   ; EQ при N=0 Z=1 C=0 V=0
        MOV  R5, 0
        SUB  R3, R1, R1
        BCS sk2
        MOV  R5, 1
sk2:
; EXPECT R5 = 1   ; CS при N=0 Z=1 C=0 V=0
        MOV  R5, 0
        SUB  R3, R1, R1
        BVS sk3
        MOV  R5, 1
sk3:
; EXPECT R5 = 1   ; VS при N=0 Z=1 C=0 V=0
        MOV  R5, 0
        SUB  R3, R1, R1
        BLS sk4
        MOV  R5, 1
sk4:
; EXPECT R5 = 0   ; LS при N=0 Z=1 C=0 V=0
        MOV  R5, 0
        SUB  R3, R1, R1
        BLT sk5
        MOV  R5, 1
sk5:
; EXPECT R5 = 1   ; LT при N=0 Z=1 C=0 V=0
        MOV  R5, 0
        SUB  R3, R1, R1
        BLE sk6
        MOV  R5, 1
sk6:
; EXPECT R5 = 0   ; LE при N=0 Z=1 C=0 V=0
        MOV  R5, 0
        SUB  R3, R1, R1
        B sk7
        MOV  R5, 1
sk7:
; EXPECT R5 = 0   ; T при N=0 Z=1 C=0 V=0
        MOV  R5, 0
        SUB  R3, R1, R1
        BPL sk8
        MOV  R5, 1
sk8:
; EXPECT R5 = 0   ; PL при N=0 Z=1 C=0 V=0
        MOV  R5, 0
        SUB  R3, R1, R1
        BNE sk9
        MOV  R5, 1
sk9:
; EXPECT R5 = 1   ; NE при N=0 Z=1 C=0 V=0
        MOV  R5, 0
        SUB  R3, R1, R1
        BCC sk10
        MOV  R5, 1
sk10:
; EXPECT R5 = 0   ; CC при N=0 Z=1 C=0 V=0
        MOV  R5, 0
        SUB  R3, R1, R1
        BVC sk11
        MOV  R5, 1
sk11:
; EXPECT R5 = 0   ; VC при N=0 Z=1 C=0 V=0
        MOV  R5, 0
        SUB  R3, R1, R1
        BHI sk12
        MOV  R5, 1
sk12:
; EXPECT R5 = 1   ; HI при N=0 Z=1 C=0 V=0
        MOV  R5, 0
        SUB  R3, R1, R1
        BGE sk13
        MOV  R5, 1
sk13:
; EXPECT R5 = 0   ; GE при N=0 Z=1 C=0 V=0
        MOV  R5, 0
        SUB  R3, R1, R1
        BGT sk14
        MOV  R5, 1
sk14:
; EXPECT R5 = 1   ; GT при N=0 Z=1 C=0 V=0
        MOV  R5, 0
        SUB  R3, R1, R1
        BNV sk15
        MOV  R5, 1
sk15:
; EXPECT R5 = 1   ; NV при N=0 Z=1 C=0 V=0
; ──────── S2: 0-5 заём  (N=1 Z=0 C=1 V=0) ────────
        MOV  R5, 0
        SUB  R3, R0, R1
        BMI sk16
        MOV  R5, 1
sk16:
; EXPECT R5 = 0   ; MI при N=1 Z=0 C=1 V=0
        MOV  R5, 0
        SUB  R3, R0, R1
        BEQ sk17
        MOV  R5, 1
sk17:
; EXPECT R5 = 1   ; EQ при N=1 Z=0 C=1 V=0
        MOV  R5, 0
        SUB  R3, R0, R1
        BCS sk18
        MOV  R5, 1
sk18:
; EXPECT R5 = 0   ; CS при N=1 Z=0 C=1 V=0
        MOV  R5, 0
        SUB  R3, R0, R1
        BVS sk19
        MOV  R5, 1
sk19:
; EXPECT R5 = 1   ; VS при N=1 Z=0 C=1 V=0
        MOV  R5, 0
        SUB  R3, R0, R1
        BLS sk20
        MOV  R5, 1
sk20:
; EXPECT R5 = 0   ; LS при N=1 Z=0 C=1 V=0
        MOV  R5, 0
        SUB  R3, R0, R1
        BLT sk21
        MOV  R5, 1
sk21:
; EXPECT R5 = 0   ; LT при N=1 Z=0 C=1 V=0
        MOV  R5, 0
        SUB  R3, R0, R1
        BLE sk22
        MOV  R5, 1
sk22:
; EXPECT R5 = 0   ; LE при N=1 Z=0 C=1 V=0
        MOV  R5, 0
        SUB  R3, R0, R1
        B sk23
        MOV  R5, 1
sk23:
; EXPECT R5 = 0   ; T при N=1 Z=0 C=1 V=0
        MOV  R5, 0
        SUB  R3, R0, R1
        BPL sk24
        MOV  R5, 1
sk24:
; EXPECT R5 = 1   ; PL при N=1 Z=0 C=1 V=0
        MOV  R5, 0
        SUB  R3, R0, R1
        BNE sk25
        MOV  R5, 1
sk25:
; EXPECT R5 = 0   ; NE при N=1 Z=0 C=1 V=0
        MOV  R5, 0
        SUB  R3, R0, R1
        BCC sk26
        MOV  R5, 1
sk26:
; EXPECT R5 = 1   ; CC при N=1 Z=0 C=1 V=0
        MOV  R5, 0
        SUB  R3, R0, R1
        BVC sk27
        MOV  R5, 1
sk27:
; EXPECT R5 = 0   ; VC при N=1 Z=0 C=1 V=0
        MOV  R5, 0
        SUB  R3, R0, R1
        BHI sk28
        MOV  R5, 1
sk28:
; EXPECT R5 = 1   ; HI при N=1 Z=0 C=1 V=0
        MOV  R5, 0
        SUB  R3, R0, R1
        BGE sk29
        MOV  R5, 1
sk29:
; EXPECT R5 = 1   ; GE при N=1 Z=0 C=1 V=0
        MOV  R5, 0
        SUB  R3, R0, R1
        BGT sk30
        MOV  R5, 1
sk30:
; EXPECT R5 = 1   ; GT при N=1 Z=0 C=1 V=0
        MOV  R5, 0
        SUB  R3, R0, R1
        BNV sk31
        MOV  R5, 1
sk31:
; EXPECT R5 = 1   ; NV при N=1 Z=0 C=1 V=0
; ──────── S3: 7-5=2  (N=0 Z=0 C=0 V=0) ────────
        MOV  R5, 0
        SUB  R3, R2, R1
        BMI sk32
        MOV  R5, 1
sk32:
; EXPECT R5 = 1   ; MI при N=0 Z=0 C=0 V=0
        MOV  R5, 0
        SUB  R3, R2, R1
        BEQ sk33
        MOV  R5, 1
sk33:
; EXPECT R5 = 1   ; EQ при N=0 Z=0 C=0 V=0
        MOV  R5, 0
        SUB  R3, R2, R1
        BCS sk34
        MOV  R5, 1
sk34:
; EXPECT R5 = 1   ; CS при N=0 Z=0 C=0 V=0
        MOV  R5, 0
        SUB  R3, R2, R1
        BVS sk35
        MOV  R5, 1
sk35:
; EXPECT R5 = 1   ; VS при N=0 Z=0 C=0 V=0
        MOV  R5, 0
        SUB  R3, R2, R1
        BLS sk36
        MOV  R5, 1
sk36:
; EXPECT R5 = 1   ; LS при N=0 Z=0 C=0 V=0
        MOV  R5, 0
        SUB  R3, R2, R1
        BLT sk37
        MOV  R5, 1
sk37:
; EXPECT R5 = 1   ; LT при N=0 Z=0 C=0 V=0
        MOV  R5, 0
        SUB  R3, R2, R1
        BLE sk38
        MOV  R5, 1
sk38:
; EXPECT R5 = 1   ; LE при N=0 Z=0 C=0 V=0
        MOV  R5, 0
        SUB  R3, R2, R1
        B sk39
        MOV  R5, 1
sk39:
; EXPECT R5 = 0   ; T при N=0 Z=0 C=0 V=0
        MOV  R5, 0
        SUB  R3, R2, R1
        BPL sk40
        MOV  R5, 1
sk40:
; EXPECT R5 = 0   ; PL при N=0 Z=0 C=0 V=0
        MOV  R5, 0
        SUB  R3, R2, R1
        BNE sk41
        MOV  R5, 1
sk41:
; EXPECT R5 = 0   ; NE при N=0 Z=0 C=0 V=0
        MOV  R5, 0
        SUB  R3, R2, R1
        BCC sk42
        MOV  R5, 1
sk42:
; EXPECT R5 = 0   ; CC при N=0 Z=0 C=0 V=0
        MOV  R5, 0
        SUB  R3, R2, R1
        BVC sk43
        MOV  R5, 1
sk43:
; EXPECT R5 = 0   ; VC при N=0 Z=0 C=0 V=0
        MOV  R5, 0
        SUB  R3, R2, R1
        BHI sk44
        MOV  R5, 1
sk44:
; EXPECT R5 = 0   ; HI при N=0 Z=0 C=0 V=0
        MOV  R5, 0
        SUB  R3, R2, R1
        BGE sk45
        MOV  R5, 1
sk45:
; EXPECT R5 = 0   ; GE при N=0 Z=0 C=0 V=0
        MOV  R5, 0
        SUB  R3, R2, R1
        BGT sk46
        MOV  R5, 1
sk46:
; EXPECT R5 = 0   ; GT при N=0 Z=0 C=0 V=0
        MOV  R5, 0
        SUB  R3, R2, R1
        BNV sk47
        MOV  R5, 1
sk47:
; EXPECT R5 = 1   ; NV при N=0 Z=0 C=0 V=0
; ──────── S4: -1+1 перенос  (N=0 Z=1 C=1 V=0) ────────
        MOV  R5, 0
        ADD  R3, R4, 1
        BMI sk48
        MOV  R5, 1
sk48:
; EXPECT R5 = 1   ; MI при N=0 Z=1 C=1 V=0
        MOV  R5, 0
        ADD  R3, R4, 1
        BEQ sk49
        MOV  R5, 1
sk49:
; EXPECT R5 = 0   ; EQ при N=0 Z=1 C=1 V=0
        MOV  R5, 0
        ADD  R3, R4, 1
        BCS sk50
        MOV  R5, 1
sk50:
; EXPECT R5 = 0   ; CS при N=0 Z=1 C=1 V=0
        MOV  R5, 0
        ADD  R3, R4, 1
        BVS sk51
        MOV  R5, 1
sk51:
; EXPECT R5 = 1   ; VS при N=0 Z=1 C=1 V=0
        MOV  R5, 0
        ADD  R3, R4, 1
        BLS sk52
        MOV  R5, 1
sk52:
; EXPECT R5 = 0   ; LS при N=0 Z=1 C=1 V=0
        MOV  R5, 0
        ADD  R3, R4, 1
        BLT sk53
        MOV  R5, 1
sk53:
; EXPECT R5 = 1   ; LT при N=0 Z=1 C=1 V=0
        MOV  R5, 0
        ADD  R3, R4, 1
        BLE sk54
        MOV  R5, 1
sk54:
; EXPECT R5 = 0   ; LE при N=0 Z=1 C=1 V=0
        MOV  R5, 0
        ADD  R3, R4, 1
        B sk55
        MOV  R5, 1
sk55:
; EXPECT R5 = 0   ; T при N=0 Z=1 C=1 V=0
        MOV  R5, 0
        ADD  R3, R4, 1
        BPL sk56
        MOV  R5, 1
sk56:
; EXPECT R5 = 0   ; PL при N=0 Z=1 C=1 V=0
        MOV  R5, 0
        ADD  R3, R4, 1
        BNE sk57
        MOV  R5, 1
sk57:
; EXPECT R5 = 1   ; NE при N=0 Z=1 C=1 V=0
        MOV  R5, 0
        ADD  R3, R4, 1
        BCC sk58
        MOV  R5, 1
sk58:
; EXPECT R5 = 1   ; CC при N=0 Z=1 C=1 V=0
        MOV  R5, 0
        ADD  R3, R4, 1
        BVC sk59
        MOV  R5, 1
sk59:
; EXPECT R5 = 0   ; VC при N=0 Z=1 C=1 V=0
        MOV  R5, 0
        ADD  R3, R4, 1
        BHI sk60
        MOV  R5, 1
sk60:
; EXPECT R5 = 1   ; HI при N=0 Z=1 C=1 V=0
        MOV  R5, 0
        ADD  R3, R4, 1
        BGE sk61
        MOV  R5, 1
sk61:
; EXPECT R5 = 0   ; GE при N=0 Z=1 C=1 V=0
        MOV  R5, 0
        ADD  R3, R4, 1
        BGT sk62
        MOV  R5, 1
sk62:
; EXPECT R5 = 1   ; GT при N=0 Z=1 C=1 V=0
        MOV  R5, 0
        ADD  R3, R4, 1
        BNV sk63
        MOV  R5, 1
sk63:
; EXPECT R5 = 1   ; NV при N=0 Z=1 C=1 V=0
; ──────── S5: max+1 перепол.  (N=1 Z=0 C=0 V=1) ────────
        MOV  R5, 0
        ADD  R3, R6, 1
        BMI sk64
        MOV  R5, 1
sk64:
; EXPECT R5 = 0   ; MI при N=1 Z=0 C=0 V=1
        MOV  R5, 0
        ADD  R3, R6, 1
        BEQ sk65
        MOV  R5, 1
sk65:
; EXPECT R5 = 1   ; EQ при N=1 Z=0 C=0 V=1
        MOV  R5, 0
        ADD  R3, R6, 1
        BCS sk66
        MOV  R5, 1
sk66:
; EXPECT R5 = 1   ; CS при N=1 Z=0 C=0 V=1
        MOV  R5, 0
        ADD  R3, R6, 1
        BVS sk67
        MOV  R5, 1
sk67:
; EXPECT R5 = 0   ; VS при N=1 Z=0 C=0 V=1
        MOV  R5, 0
        ADD  R3, R6, 1
        BLS sk68
        MOV  R5, 1
sk68:
; EXPECT R5 = 1   ; LS при N=1 Z=0 C=0 V=1
        MOV  R5, 0
        ADD  R3, R6, 1
        BLT sk69
        MOV  R5, 1
sk69:
; EXPECT R5 = 1   ; LT при N=1 Z=0 C=0 V=1
        MOV  R5, 0
        ADD  R3, R6, 1
        BLE sk70
        MOV  R5, 1
sk70:
; EXPECT R5 = 1   ; LE при N=1 Z=0 C=0 V=1
        MOV  R5, 0
        ADD  R3, R6, 1
        B sk71
        MOV  R5, 1
sk71:
; EXPECT R5 = 0   ; T при N=1 Z=0 C=0 V=1
        MOV  R5, 0
        ADD  R3, R6, 1
        BPL sk72
        MOV  R5, 1
sk72:
; EXPECT R5 = 1   ; PL при N=1 Z=0 C=0 V=1
        MOV  R5, 0
        ADD  R3, R6, 1
        BNE sk73
        MOV  R5, 1
sk73:
; EXPECT R5 = 0   ; NE при N=1 Z=0 C=0 V=1
        MOV  R5, 0
        ADD  R3, R6, 1
        BCC sk74
        MOV  R5, 1
sk74:
; EXPECT R5 = 0   ; CC при N=1 Z=0 C=0 V=1
        MOV  R5, 0
        ADD  R3, R6, 1
        BVC sk75
        MOV  R5, 1
sk75:
; EXPECT R5 = 1   ; VC при N=1 Z=0 C=0 V=1
        MOV  R5, 0
        ADD  R3, R6, 1
        BHI sk76
        MOV  R5, 1
sk76:
; EXPECT R5 = 0   ; HI при N=1 Z=0 C=0 V=1
        MOV  R5, 0
        ADD  R3, R6, 1
        BGE sk77
        MOV  R5, 1
sk77:
; EXPECT R5 = 0   ; GE при N=1 Z=0 C=0 V=1
        MOV  R5, 0
        ADD  R3, R6, 1
        BGT sk78
        MOV  R5, 1
sk78:
; EXPECT R5 = 0   ; GT при N=1 Z=0 C=0 V=1
        MOV  R5, 0
        ADD  R3, R6, 1
        BNV sk79
        MOV  R5, 1
sk79:
; EXPECT R5 = 1   ; NV при N=1 Z=0 C=0 V=1
; ──────── S6: min-1 перепол.  (N=0 Z=0 C=0 V=1) ────────
        MOV  R5, 0
        SUB  R3, R7, 1
        BMI sk80
        MOV  R5, 1
sk80:
; EXPECT R5 = 1   ; MI при N=0 Z=0 C=0 V=1
        MOV  R5, 0
        SUB  R3, R7, 1
        BEQ sk81
        MOV  R5, 1
sk81:
; EXPECT R5 = 1   ; EQ при N=0 Z=0 C=0 V=1
        MOV  R5, 0
        SUB  R3, R7, 1
        BCS sk82
        MOV  R5, 1
sk82:
; EXPECT R5 = 1   ; CS при N=0 Z=0 C=0 V=1
        MOV  R5, 0
        SUB  R3, R7, 1
        BVS sk83
        MOV  R5, 1
sk83:
; EXPECT R5 = 0   ; VS при N=0 Z=0 C=0 V=1
        MOV  R5, 0
        SUB  R3, R7, 1
        BLS sk84
        MOV  R5, 1
sk84:
; EXPECT R5 = 1   ; LS при N=0 Z=0 C=0 V=1
        MOV  R5, 0
        SUB  R3, R7, 1
        BLT sk85
        MOV  R5, 1
sk85:
; EXPECT R5 = 0   ; LT при N=0 Z=0 C=0 V=1
        MOV  R5, 0
        SUB  R3, R7, 1
        BLE sk86
        MOV  R5, 1
sk86:
; EXPECT R5 = 0   ; LE при N=0 Z=0 C=0 V=1
        MOV  R5, 0
        SUB  R3, R7, 1
        B sk87
        MOV  R5, 1
sk87:
; EXPECT R5 = 0   ; T при N=0 Z=0 C=0 V=1
        MOV  R5, 0
        SUB  R3, R7, 1
        BPL sk88
        MOV  R5, 1
sk88:
; EXPECT R5 = 0   ; PL при N=0 Z=0 C=0 V=1
        MOV  R5, 0
        SUB  R3, R7, 1
        BNE sk89
        MOV  R5, 1
sk89:
; EXPECT R5 = 0   ; NE при N=0 Z=0 C=0 V=1
        MOV  R5, 0
        SUB  R3, R7, 1
        BCC sk90
        MOV  R5, 1
sk90:
; EXPECT R5 = 0   ; CC при N=0 Z=0 C=0 V=1
        MOV  R5, 0
        SUB  R3, R7, 1
        BVC sk91
        MOV  R5, 1
sk91:
; EXPECT R5 = 1   ; VC при N=0 Z=0 C=0 V=1
        MOV  R5, 0
        SUB  R3, R7, 1
        BHI sk92
        MOV  R5, 1
sk92:
; EXPECT R5 = 0   ; HI при N=0 Z=0 C=0 V=1
        MOV  R5, 0
        SUB  R3, R7, 1
        BGE sk93
        MOV  R5, 1
sk93:
; EXPECT R5 = 1   ; GE при N=0 Z=0 C=0 V=1
        MOV  R5, 0
        SUB  R3, R7, 1
        BGT sk94
        MOV  R5, 1
sk94:
; EXPECT R5 = 1   ; GT при N=0 Z=0 C=0 V=1
        MOV  R5, 0
        SUB  R3, R7, 1
        BNV sk95
        MOV  R5, 1
sk95:
; EXPECT R5 = 1   ; NV при N=0 Z=0 C=0 V=1
; ──────── S7: N=1,C=0,V=0  (N=1 Z=0 C=0 V=0) ────────
        MOV  R5, 0
        ADD  R3, R7, 0
        BMI sk96
        MOV  R5, 1
sk96:
; EXPECT R5 = 0   ; MI при N=1 Z=0 C=0 V=0
        MOV  R5, 0
        ADD  R3, R7, 0
        BEQ sk97
        MOV  R5, 1
sk97:
; EXPECT R5 = 1   ; EQ при N=1 Z=0 C=0 V=0
        MOV  R5, 0
        ADD  R3, R7, 0
        BCS sk98
        MOV  R5, 1
sk98:
; EXPECT R5 = 1   ; CS при N=1 Z=0 C=0 V=0
        MOV  R5, 0
        ADD  R3, R7, 0
        BVS sk99
        MOV  R5, 1
sk99:
; EXPECT R5 = 1   ; VS при N=1 Z=0 C=0 V=0
        MOV  R5, 0
        ADD  R3, R7, 0
        BLS sk100
        MOV  R5, 1
sk100:
; EXPECT R5 = 1   ; LS при N=1 Z=0 C=0 V=0
        MOV  R5, 0
        ADD  R3, R7, 0
        BLT sk101
        MOV  R5, 1
sk101:
; EXPECT R5 = 0   ; LT при N=1 Z=0 C=0 V=0
        MOV  R5, 0
        ADD  R3, R7, 0
        BLE sk102
        MOV  R5, 1
sk102:
; EXPECT R5 = 0   ; LE при N=1 Z=0 C=0 V=0
        MOV  R5, 0
        ADD  R3, R7, 0
        B sk103
        MOV  R5, 1
sk103:
; EXPECT R5 = 0   ; T при N=1 Z=0 C=0 V=0
        MOV  R5, 0
        ADD  R3, R7, 0
        BPL sk104
        MOV  R5, 1
sk104:
; EXPECT R5 = 1   ; PL при N=1 Z=0 C=0 V=0
        MOV  R5, 0
        ADD  R3, R7, 0
        BNE sk105
        MOV  R5, 1
sk105:
; EXPECT R5 = 0   ; NE при N=1 Z=0 C=0 V=0
        MOV  R5, 0
        ADD  R3, R7, 0
        BCC sk106
        MOV  R5, 1
sk106:
; EXPECT R5 = 0   ; CC при N=1 Z=0 C=0 V=0
        MOV  R5, 0
        ADD  R3, R7, 0
        BVC sk107
        MOV  R5, 1
sk107:
; EXPECT R5 = 0   ; VC при N=1 Z=0 C=0 V=0
        MOV  R5, 0
        ADD  R3, R7, 0
        BHI sk108
        MOV  R5, 1
sk108:
; EXPECT R5 = 0   ; HI при N=1 Z=0 C=0 V=0
        MOV  R5, 0
        ADD  R3, R7, 0
        BGE sk109
        MOV  R5, 1
sk109:
; EXPECT R5 = 1   ; GE при N=1 Z=0 C=0 V=0
        MOV  R5, 0
        ADD  R3, R7, 0
        BGT sk110
        MOV  R5, 1
sk110:
; EXPECT R5 = 1   ; GT при N=1 Z=0 C=0 V=0
        MOV  R5, 0
        ADD  R3, R7, 0
        BNV sk111
        MOV  R5, 1
sk111:
; EXPECT R5 = 1   ; NV при N=1 Z=0 C=0 V=0
        HALT
