; T1.19 — семантический дифференциал (СГЕНЕРИРОВАН tools/gen_alu_diff.py).
; Зерно 20260923, случаев 900. Ожидания посчитаны моделью tools/alu_model.py,
; написанной по RISC5.v независимо от ассемблера. Проверяются результат и флаги.

        MHI  R5, 0xC924
        IOR  R5, R5, 0x9946
        ADD  R6, R5, -10311
; EXPECT R6 = 0xC92470FF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0xDBB1
        IOR  R11, R11, 0x81EF
        MHI  R1, 0xCDF1
        IOR  R1, R1, 0x7F0B
        LSL  R9, R11, R1
; EXPECT R9 = 0x8C0F7800
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0xA86D
        IOR  R10, R10, 0xF0B1
        MHI  R1, 0xEFA1
        IOR  R1, R1, 0x36B1
        SUB  R8, R10, R1
; EXPECT R8 = 0xB8CCBA00
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0xEB3E
        IOR  R6, R6, 0x3369
        MOV  R1, R6
; EXPECT R1 = 0xEB3E3369
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0x0193
        IOR  R9, R9, 0xFD91
        MHI  R6, 0xBA56
        IOR  R6, R6, 0x7CC8
        LSL  R6, R9, R6
; EXPECT R6 = 0x93FD9100
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x552D
        IOR  R11, R11, 0x8B8E
        MHI  R7, 0x909C
        IOR  R7, R7, 0xB85D
        SUB  R9, R11, R7
; EXPECT R9 = 0xC490D331
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R5, 0x4DFA
        IOR  R5, R5, 0x9D20
        ANN  R2, R5, -57983
; EXPECT R2 = 0x00008020
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R11, 0x7351
        IOR  R11, R11, 0xBD45
        MHI  R3, 0xA7E3
        IOR  R3, R3, 0x4B4E
        UMUL  R11, R11, R3
; EXPECT R11 = 0xEC89E206
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1
; EXPECT H = 0xD84EF899

        MHI  R9, 0x697F
        IOR  R9, R9, 0x2213
        SUB.uv  R2, R9, -40889
; EXPECT R2 = 0x697FC1CB
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x3DAF
        IOR  R10, R10, 0x94B5
        MHI  R5, 0x9E0B
        IOR  R5, R5, 0xD808
        ADC  R11, R10, R5
; EXPECT R11 = 0xDBBB6CBE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R3, H
; EXPECT R3 = 0xD84EF899
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x708B
        IOR  R2, R2, 0xE782
        MHI  R10, 0x4023
        IOR  R10, R10, 0xBDEC
        AND  R9, R2, R10
; EXPECT R9 = 0x4003A580
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x84BE
        IOR  R10, R10, 0x2106
        LSL  R5, R10, 18
; EXPECT R5 = 0x84180000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R1, -57709
; EXPECT R1 = 0xFFFF1E93
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x8BA7
        IOR  R2, R2, 0x2660
        ADD.uv  R9, R2, -60050
; EXPECT R9 = 0x8BA63BCE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0x1E85
        IOR  R9, R9, 0x5DD8
        ROR  R1, R9, 17
; EXPECT R1 = 0xAEEC0F42
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0x6791
        IOR  R8, R8, 0xF29B
        MHI  R9, 0x0FED
        IOR  R9, R9, 0x7B7A
        LSL  R6, R8, R9
; EXPECT R6 = 0x6C000000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0xC1A4
        IOR  R3, R3, 0x05E8
        MHI  R9, 0x208B
        IOR  R9, R9, 0x458D
        UDIV  R10, R3, R9
; EXPECT R10 = 0x00000005
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x1EEBAA27

        MHI  R11, 0x0A87
        IOR  R11, R11, 0xD84A
        MHI  R6, 0xDF5F
        IOR  R6, R6, 0x4217
        ADD  R9, R11, R6
; EXPECT R9 = 0xE9E71A61
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0xB436
        IOR  R2, R2, 0xD2B1
        AND  R11, R2, 53042
; EXPECT R11 = 0x0000C230
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0xA260
        IOR  R3, R3, 0x9291
        MHI  R8, 0x0437
        IOR  R8, R8, 0xF6C4
        UDIV  R11, R3, R8
; EXPECT R11 = 0x00000026
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x0211F179

        MOV  R1, NZCV
; EXPECT R1 = 0x00000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x9E20
        IOR  R9, R9, 0x2C94
        ADC  R2, R9, 56081
; EXPECT R2 = 0x9E2107A5
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x76CF
        IOR  R10, R10, 0x350E
        ROR  R6, R10, 18
; EXPECT R6 = 0xCD439DB3
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x8E02
        IOR  R6, R6, 0x9589
        MHI  R2, 0x3C34
        IOR  R2, R2, 0x4889
        ROR  R10, R6, R2
; EXPECT R10 = 0xC4C7014A
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x6D84
        IOR  R3, R3, 0xC6BF
        ADD  R5, R3, -50418
; EXPECT R5 = 0x6D8401CD
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0xE073
        IOR  R9, R9, 0x6AF7
        MHI  R2, 0x5C46
        IOR  R2, R2, 0xD4AC
        DIV  R4, R9, R2
; EXPECT R4 = 0xFFFFFFFF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x3CBA3FA3

        MHI  R1, 0xEBB3
        IOR  R1, R1, 0x2B3F
        MHI  R6, 0x6B3A
        IOR  R6, R6, 0x57DF
        SBC  R4, R1, R6
; EXPECT R4 = 0x8078D35F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x3C6A
        IOR  R6, R6, 0x6DBE
        DIV  R2, R6, 5662
; EXPECT R2 = 0x0002BB4B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x000008F4

        MHI  R10, 0x89B6
        IOR  R10, R10, 0xE1B6
        LSL  R7, R10, 21
; EXPECT R7 = 0x36C00000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0x2293
        IOR  R11, R11, 0x2B41
        LSL  R4, R11, 5
; EXPECT R4 = 0x52656820
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x1AFD
        IOR  R2, R2, 0x7D8A
        MHI  R6, 0x7A7B
        IOR  R6, R6, 0x4D80
        ANN  R9, R2, R6
; EXPECT R9 = 0x0084300A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x233E
        IOR  R1, R1, 0x21EC
        AND.uv  R5, R1, -30948
; EXPECT R5 = 0x233E010C
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0xD022
        IOR  R3, R3, 0xB87A
        ADC  R10, R3, 44917
; EXPECT R10 = 0xD02367EF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0x7AD1
        IOR  R8, R8, 0xE71B
        MHI  R5, 0x1457
        IOR  R5, R5, 0x2FA5
        SUB  R11, R8, R5
; EXPECT R11 = 0x667AB776
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0xF613
        IOR  R7, R7, 0xEE0D
        ADC  R3, R7, 20850
; EXPECT R3 = 0xF6143F7F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0xD8D9
        IOR  R9, R9, 0x2EE3
        MHI  R5, 0xD0C7
        IOR  R5, R5, 0x632A
        XOR  R1, R9, R5
; EXPECT R1 = 0x081E4DC9
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x6D5A
        IOR  R2, R2, 0x06A0
        ASR  R2, R2, 24
; EXPECT R2 = 0x0000006D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0xA300
; EXPECT R5 = 0xA3000000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0xAFB7
        IOR  R10, R10, 0x9089
        LSL  R5, R10, 24
; EXPECT R5 = 0x89000000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x7211
        IOR  R4, R4, 0x310F
        SUB  R3, R4, 55202
; EXPECT R3 = 0x7210596D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x1498
        IOR  R4, R4, 0x4AE2
        MHI  R9, 0x31B2
        IOR  R9, R9, 0xBAF5
        DIV  R7, R4, R9
; EXPECT R7 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x14984AE2

        MHI  R7, 0x3DBF
        IOR  R7, R7, 0x605D
        MHI  R1, 0xD087
        IOR  R1, R1, 0x33FC
        SBC  R4, R7, R1
; EXPECT R4 = 0x6D382C61
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x18B0
        IOR  R5, R5, 0x0E11
        ADD  R1, R5, 63862
; EXPECT R1 = 0x18B10787
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R4, -25745
; EXPECT R4 = 0xFFFF9B6F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x80EC
        IOR  R6, R6, 0x8CD8
        MHI  R10, 0x8714
        IOR  R10, R10, 0x123E
        AND  R11, R6, R10
; EXPECT R11 = 0x80040018
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x44EA
        IOR  R4, R4, 0x2656
        MHI  R10, 0x48F0
        IOR  R10, R10, 0x94A2
        IOR  R11, R4, R10
; EXPECT R11 = 0x4CFAB6F6
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0xB755
        IOR  R9, R9, 0x2B08
        MHI  R1, 0x7A91
        IOR  R1, R1, 0x7A0E
        UMUL  R8, R9, R1
; EXPECT R8 = 0xCCB22A70
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x57C6C527

        MHI  R2, 0xF062
        IOR  R2, R2, 0x4E31
        MHI  R7, 0x531C
        IOR  R7, R7, 0xD495
        SUB  R3, R2, R7
; EXPECT R3 = 0x9D45799C
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x04EF
        IOR  R9, R9, 0xA3CB
        MHI  R4, 0xD898
        IOR  R4, R4, 0x31CE
        XOR  R7, R9, R4
; EXPECT R7 = 0xDC779205
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x0557
        IOR  R9, R9, 0xE83F
        MHI  R7, 0x1BC6
        IOR  R7, R7, 0xBA9C
        UDIV  R11, R9, R7
; EXPECT R11 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x0557E83F

        MHI  R4, 0xDEC3
        IOR  R4, R4, 0x4B96
        MHI  R6, 0x2562
        IOR  R6, R6, 0x0082
        UDIV  R9, R4, R6
; EXPECT R9 = 0x00000005
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x23D9490C

        MHI  R2, 0x8DBA
        IOR  R2, R2, 0x6B30
        MHI  R5, 0xEB98
        IOR  R5, R5, 0xAB2A
        SBC  R8, R2, R5
; EXPECT R8 = 0xA221C006
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0x17CB
        IOR  R4, R4, 0x7969
        MHI  R6, 0xF23E
        IOR  R6, R6, 0x1AB4
        UMUL  R11, R4, R6
; EXPECT R11 = 0x0ED407D4
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xFEB8A51F

        MHI  R11, 0x4B02
        IOR  R11, R11, 0x7BEA
        AND  R10, R11, 21508
; EXPECT R10 = 0x00005000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0xBEB6
        IOR  R8, R8, 0x3339
        ADD  R4, R8, -57212
; EXPECT R4 = 0xBEB553BD
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0xE266
        IOR  R6, R6, 0x528D
        MHI  R10, 0x2F07
        IOR  R10, R10, 0x9B95
        MUL  R4, R6, R10
; EXPECT R4 = 0xDE646B11
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xFA8FE7F6

        MHI  R3, 0xC796
        IOR  R3, R3, 0xE8D3
        MHI  R9, 0x8F61
        IOR  R9, R9, 0x708D
        SBC  R2, R3, R9
; EXPECT R2 = 0x38357845
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0xF218
        IOR  R2, R2, 0x6F0B
        MOV  R8, R2
; EXPECT R8 = 0xF2186F0B
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x7AE3
        IOR  R5, R5, 0x71A9
        MHI  R11, 0x5ABB
        IOR  R11, R11, 0x9993
        XOR  R7, R5, R11
; EXPECT R7 = 0x2058E83A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R4, -11404
; EXPECT R4 = 0xFFFFD374
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x81CC
        IOR  R1, R1, 0x0AD3
        ASR  R2, R1, 19
; EXPECT R2 = 0xFFFFF039
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x810B
        IOR  R3, R3, 0x783F
        SUB.uv  R7, R3, -24249
; EXPECT R7 = 0x810BD6F8
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R7, -27107
; EXPECT R7 = 0xFFFF961D
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x9BD0
        IOR  R10, R10, 0xF0F2
        MHI  R7, 0xC587
        IOR  R7, R7, 0x1633
        SUB  R2, R10, R7
; EXPECT R2 = 0xD649DABF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R7, H
; EXPECT R7 = 0xFA8FE7F6
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x96F6
        IOR  R11, R11, 0xA999
        MOV  R9, R11
; EXPECT R9 = 0x96F6A999
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0xBD32
        IOR  R5, R5, 0xE196
        MOV  R9, R5
; EXPECT R9 = 0xBD32E196
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x5AB7
; EXPECT R7 = 0x5AB70000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0xD989
        IOR  R10, R10, 0xCC6D
        LSL  R4, R10, 15
; EXPECT R4 = 0xE6368000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R11, NZCV
; EXPECT R11 = 0xA0000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0xB66B
        IOR  R8, R8, 0x27DC
        AND  R9, R8, -2029
; EXPECT R9 = 0xB66B2010
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x698A
        IOR  R6, R6, 0xF2FF
        MHI  R3, 0x15D9
        IOR  R3, R3, 0x990D
        UMUL  R9, R6, R3
; EXPECT R9 = 0x4C6FBDF3
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x09021BD0

        MHI  R7, 0x22FB
        IOR  R7, R7, 0x120D
        IOR  R3, R7, 14968
; EXPECT R3 = 0x22FB3A7D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0xEC58
        IOR  R3, R3, 0xD1D6
        MHI  R6, 0xDD34
        IOR  R6, R6, 0x24A0
        ANN  R1, R3, R6
; EXPECT R1 = 0x2048D156
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R10, H
; EXPECT R10 = 0x09021BD0
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0xB981
        IOR  R3, R3, 0x4059
        MHI  R6, 0xE07D
        IOR  R6, R6, 0x632A
        ADC  R5, R3, R6
; EXPECT R5 = 0x99FEA384
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0x28AE
        IOR  R9, R9, 0xE919
        AND  R4, R9, 22464
; EXPECT R4 = 0x00004100
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x51F9
        IOR  R11, R11, 0xAD00
        MHI  R3, 0x0CDF
        IOR  R3, R3, 0x20FB
        UDIV  R8, R11, R3
; EXPECT R8 = 0x00000006
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x04BEE71E

        MHI  R7, 0xE2C6
        IOR  R7, R7, 0x1CE2
        MHI  R9, 0xF1F4
        IOR  R9, R9, 0x72D3
        ASR  R1, R7, R9
; EXPECT R1 = 0xFFFFFC58
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x7EE8
        IOR  R11, R11, 0x8947
        MHI  R4, 0xDEE2
        IOR  R4, R4, 0xFEEA
        ADC  R5, R11, R4
; EXPECT R5 = 0x5DCB8832
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R8, NZCV
; EXPECT R8 = 0x20000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R3, H
; EXPECT R3 = 0x04BEE71E
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x8775
        IOR  R11, R11, 0x2070
        SBC  R10, R11, 21722
; EXPECT R10 = 0x8774CB95
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0x66FF
        IOR  R8, R8, 0xABE7
        MHI  R7, 0xB3E2
        IOR  R7, R7, 0x8539
        AND  R10, R8, R7
; EXPECT R10 = 0x22E28121
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x2EE5
        IOR  R1, R1, 0xAEF8
        MHI  R3, 0x070F
        IOR  R3, R3, 0xD2A4
        ASR  R8, R1, R3
; EXPECT R8 = 0x02EE5AEF
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0xB2DB
        IOR  R9, R9, 0xE1C1
        MUL  R10, R9, 62882
; EXPECT R10 = 0x9E329122
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0xFFFFB5FB

        MHI  R1, 0xC94E
        IOR  R1, R1, 0xC77A
        MHI  R7, 0x618E
        IOR  R7, R7, 0xAF12
        ASR  R8, R1, R7
; EXPECT R8 = 0xFFFFF253
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0xA664
        IOR  R8, R8, 0x0513
        MHI  R4, 0x6E9D
        IOR  R4, R4, 0xDE0C
        ANN  R10, R8, R4
; EXPECT R10 = 0x80600113
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x5230
        IOR  R7, R7, 0x29FC
        MHI  R1, 0xF869
        IOR  R1, R1, 0xB1FC
        SUB  R11, R7, R1
; EXPECT R11 = 0x59C67800
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x5C18
; EXPECT R5 = 0x5C180000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x2908
        IOR  R11, R11, 0x7CD2
        ANN  R7, R11, 1091
; EXPECT R7 = 0x29087890
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0x28E2
        IOR  R1, R1, 0xC74C
        AND  R7, R1, 59114
; EXPECT R7 = 0x0000C648
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R8, NZCV
; EXPECT R8 = 0x20000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x84DE
        IOR  R3, R3, 0xEDC5
        MHI  R1, 0x29B3
        IOR  R1, R1, 0xC49E
        SUB  R6, R3, R1
; EXPECT R6 = 0x5B2B2927
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MOV  R10, 774
; EXPECT R10 = 0x00000306
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MOV  R4, H
; EXPECT R4 = 0xFFFFB5FB
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R2, 0x2D15
        IOR  R2, R2, 0x8EE4
        MHI  R7, 0xB4FD
        IOR  R7, R7, 0x976D
        MUL  R7, R2, R7
; EXPECT R7 = 0x70CA5314
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1
; EXPECT H = 0xF2CA428D

        MHI  R9, 0x653C
        IOR  R9, R9, 0xB5B1
        ADD.uv  R6, R9, -25791
; EXPECT R6 = 0x653C50F2
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0xE561
        IOR  R9, R9, 0x6EC9
        ADC  R2, R9, 56660
; EXPECT R2 = 0xE5624C1E
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x2AF9
        IOR  R3, R3, 0x3107
        MHI  R5, 0x443D
        IOR  R5, R5, 0x5F2C
        ADD  R7, R3, R5
; EXPECT R7 = 0x6F369033
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x3B1D
        IOR  R2, R2, 0xDA02
        MHI  R11, 0xD9D3
        IOR  R11, R11, 0xB8F1
        IOR  R8, R2, R11
; EXPECT R8 = 0xFBDFFAF3
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R2, NZCV
; EXPECT R2 = 0x80000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x7DE4
        IOR  R3, R3, 0x1E66
        MHI  R10, 0xDEC8
        IOR  R10, R10, 0xC53C
        ROR  R11, R3, R10
; EXPECT R11 = 0xDE41E667
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0xE823
        IOR  R9, R9, 0x0F79
        ASR  R1, R9, 1
; EXPECT R1 = 0xF41187BC
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x3EFE
        IOR  R9, R9, 0xDC74
        MHI  R10, 0xC16D
        IOR  R10, R10, 0x5F57
        XOR  R5, R9, R10
; EXPECT R5 = 0xFF938323
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0xE909
        IOR  R5, R5, 0x796E
        MOV  R5, R5
; EXPECT R5 = 0xE909796E
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x2EAE
        IOR  R10, R10, 0xE9CE
        IOR  R11, R10, -17968
; EXPECT R11 = 0xFFFFF9DE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R3, 7209
; EXPECT R3 = 0x00001C29
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x80E8
        IOR  R1, R1, 0xFD85
        ROR  R5, R1, 6
; EXPECT R5 = 0x1603A3F6
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R8, NZCV
; EXPECT R8 = 0x00000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0x111A
        IOR  R11, R11, 0xCEC8
        ADC  R1, R11, 59316
; EXPECT R1 = 0x111BB67C
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x5F95
        IOR  R1, R1, 0xDC14
        ASR  R1, R1, 28
; EXPECT R1 = 0x00000005
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R11, -55887
; EXPECT R11 = 0xFFFF25B1
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x99A1
        IOR  R10, R10, 0x10AD
        SUB  R10, R10, 42354
; EXPECT R10 = 0x99A06B3B
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0xBA89
        IOR  R4, R4, 0x9106
        MHI  R11, 0x8410
        IOR  R11, R11, 0xC95B
        XOR  R10, R4, R11
; EXPECT R10 = 0x3E99585D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x0898
        IOR  R10, R10, 0xAEF1
        SUB.uv  R6, R10, -17714
; EXPECT R6 = 0x0898F423
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x4582
        IOR  R11, R11, 0x9653
        MHI  R1, 0xBAD0
        IOR  R1, R1, 0xAA27
        ADC  R2, R11, R1
; EXPECT R2 = 0x0053407B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0xF7A3
        IOR  R9, R9, 0x01BB
        SBC  R8, R9, 3464
; EXPECT R8 = 0xF7A2F432
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0xB47E
        IOR  R1, R1, 0x4E77
        AND  R4, R1, 38257
; EXPECT R4 = 0x00000471
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0xF4BE
        IOR  R4, R4, 0xC2E5
        MHI  R1, 0x88C3
        IOR  R1, R1, 0x41E9
        ROR  R7, R4, R1
; EXPECT R7 = 0x72FA5F61
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0xD464
        IOR  R6, R6, 0x7C25
        SBC  R10, R6, 20187
; EXPECT R10 = 0xD4642D4A
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x2BD6
        IOR  R9, R9, 0x2B19
        MHI  R8, 0x450F
        IOR  R8, R8, 0xC383
        XOR  R6, R9, R8
; EXPECT R6 = 0x6ED9E89A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0xDC99
        IOR  R8, R8, 0xF5B0
        LSL  R1, R8, 8
; EXPECT R1 = 0x99F5B000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x38BE
        IOR  R7, R7, 0x2C87
        MHI  R4, 0x40DB
        IOR  R4, R4, 0x6792
        SUB  R5, R7, R4
; EXPECT R5 = 0xF7E2C4F5
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R11, NZCV
; EXPECT R11 = 0xA0000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0x95D8
        IOR  R4, R4, 0x7E57
        MHI  R5, 0xE673
        IOR  R5, R5, 0x1AD0
        SUB  R3, R4, R5
; EXPECT R3 = 0xAF656387
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0xD17E
        IOR  R6, R6, 0x60EC
        MHI  R11, 0x5531
        IOR  R11, R11, 0x1E7A
        ADC  R6, R6, R11
; EXPECT R6 = 0x26AF7F67
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0xA974
        IOR  R1, R1, 0x32EF
        MHI  R5, 0x69F0
        IOR  R5, R5, 0xF754
        AND  R11, R1, R5
; EXPECT R11 = 0x29703244
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0xE517
        IOR  R4, R4, 0x3AA7
        MHI  R1, 0xA4DF
        IOR  R1, R1, 0x7EF0
        ANN  R7, R4, R1
; EXPECT R7 = 0x41000007
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0xFB1C
        IOR  R8, R8, 0xE12B
        AND.uv  R7, R8, -17364
; EXPECT R7 = 0xFB1CA028
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0xE8A3
        IOR  R8, R8, 0xA426
        MHI  R7, 0x252C
        IOR  R7, R7, 0xCA58
        UMUL  R9, R8, R7
; EXPECT R9 = 0xCC4E6910
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x21C85ABA

        MHI  R5, 0xD825
        IOR  R5, R5, 0x0838
        MHI  R9, 0x18A3
        IOR  R9, R9, 0x9CC7
        XOR  R7, R5, R9
; EXPECT R7 = 0xC08694FF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x9ED3
        IOR  R3, R3, 0x1EEA
        DIV  R9, R3, 24697
; EXPECT R9 = 0xFFFEFE22
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x000040D8

        MHI  R1, 0x52A8
        IOR  R1, R1, 0x7C55
        MHI  R6, 0x6D44
        IOR  R6, R6, 0xC62D
        ROR  R4, R1, R6
; EXPECT R4 = 0xE2AA9543
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x747C
        IOR  R7, R7, 0x94AC
        MHI  R5, 0x789D
        IOR  R5, R5, 0x7903
        ROR  R6, R7, R5
; EXPECT R6 = 0x8E8F9295
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0xD4DF
        IOR  R5, R5, 0xF719
        AND  R6, R5, 21601
; EXPECT R6 = 0x00005401
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0x2754
        IOR  R1, R1, 0xA12A
        ROR  R6, R1, 12
; EXPECT R6 = 0x12A2754A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0x58BF
        IOR  R4, R4, 0xB04D
        MHI  R1, 0x89C3
        IOR  R1, R1, 0x743E
        ADC  R8, R4, R1
; EXPECT R8 = 0xE283248C
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x86F2
        IOR  R2, R2, 0x8284
        MHI  R11, 0x4EA7
        IOR  R11, R11, 0xA719
        DIV  R8, R2, R11
; EXPECT R8 = 0xFFFFFFFE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x2441D0B6

        MHI  R3, 0x3EDC
        IOR  R3, R3, 0x1D5F
        MHI  R1, 0x0787
        IOR  R1, R1, 0x1D3B
        ADC  R9, R3, R1
; EXPECT R9 = 0x46633A9A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0xC5BE
        IOR  R6, R6, 0x9B06
        MOV  R8, R6
; EXPECT R8 = 0xC5BE9B06
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x58D6
        IOR  R2, R2, 0x05BA
        MOV  R6, R2
; EXPECT R6 = 0x58D605BA
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x64AB
        IOR  R3, R3, 0x1CF5
        ROR  R4, R3, 3
; EXPECT R4 = 0xAC95639E
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x380F
        IOR  R4, R4, 0x0348
        MHI  R8, 0x2928
        IOR  R8, R8, 0xC6C9
        DIV  R10, R4, R8
; EXPECT R10 = 0x00000001
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x0EE63C7F

        MHI  R3, 0x4D6A
        IOR  R3, R3, 0x499F
        ADD  R5, R3, -39401
; EXPECT R5 = 0x4D69AFB6
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x0F1A
        IOR  R2, R2, 0x58A0
        MHI  R1, 0xE1B2
        IOR  R1, R1, 0xD3B7
        AND  R10, R2, R1
; EXPECT R10 = 0x011250A0
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x15FE
        IOR  R7, R7, 0xDE95
        MHI  R11, 0xDD0A
        IOR  R11, R11, 0x7486
        ANN  R3, R7, R11
; EXPECT R3 = 0x00F48A11
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x107D
        IOR  R5, R5, 0x5D0A
        DIV  R9, R5, 54854
; EXPECT R9 = 0x000013B3
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x00005818

        MHI  R8, 0x4428
        IOR  R8, R8, 0xD05B
        MHI  R10, 0x214D
        IOR  R10, R10, 0x9CAB
        UDIV  R9, R8, R10
; EXPECT R9 = 0x00000002
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x018D9705

        MHI  R2, 0x0754
        IOR  R2, R2, 0x82B0
        MUL  R2, R2, 62805
; EXPECT R2 = 0x5021D470
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x00000706

        MHI  R2, 0x5D50
        IOR  R2, R2, 0x2E61
        MHI  R10, 0x7AD0
        IOR  R10, R10, 0xE4B8
        ADD  R10, R2, R10
; EXPECT R10 = 0xD8211319
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R9, 0x2C67
        IOR  R9, R9, 0x013D
        MHI  R7, 0x7A60
        IOR  R7, R7, 0xED24
        DIV  R3, R9, R7
; EXPECT R3 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 0
; EXPECT V = 1
; EXPECT H = 0x2C67013D

        MHI  R8, 0xC008
        IOR  R8, R8, 0x18F1
        MHI  R10, 0x47F4
        IOR  R10, R10, 0x0323
        SBC  R2, R8, R10
; EXPECT R2 = 0x781415CE
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MOV  R8, NZCV
; EXPECT R8 = 0x10000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R7, 0x89CC
; EXPECT R7 = 0x89CC0000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R2, 0xAA7B
        IOR  R2, R2, 0x8A76
        ANN  R9, R2, -50875
; EXPECT R9 = 0x00008232
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R2, 0xD85C
        IOR  R2, R2, 0xF561
        AND  R9, R2, -53557
; EXPECT R9 = 0xD85C2441
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R10, 0xBC3D
        IOR  R10, R10, 0x693C
        MHI  R1, 0x3E33
        IOR  R1, R1, 0xAEB0
        AND  R11, R10, R1
; EXPECT R11 = 0x3C312830
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MOV  R10, 40932
; EXPECT R10 = 0x00009FE4
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MOV  R2, 5110
; EXPECT R2 = 0x000013F6
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R3, 0xDA3A
        IOR  R3, R3, 0x82F3
        MHI  R11, 0xC268
        IOR  R11, R11, 0xDB47
        SBC  R3, R3, R11
; EXPECT R3 = 0x17D1A7AC
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R6, -50182
; EXPECT R6 = 0xFFFF3BFA
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0xC0A4
        IOR  R9, R9, 0x7E06
        AND  R5, R9, 21710
; EXPECT R5 = 0x00005406
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x153E
        IOR  R4, R4, 0x72D5
        SUB.uv  R2, R4, -2251
; EXPECT R2 = 0x153E7BA0
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0x3E33
        IOR  R1, R1, 0x2844
        ADD.uv  R8, R1, -24004
; EXPECT R8 = 0x3E32CA81
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0x41DA
        IOR  R9, R9, 0xEBD1
        MOV  R5, R9
; EXPECT R5 = 0x41DAEBD1
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x9E61
        IOR  R10, R10, 0x8E7E
        ASR  R8, R10, 30
; EXPECT R8 = 0xFFFFFFFE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0xDC39
        IOR  R2, R2, 0xF890
        MHI  R6, 0x018B
        IOR  R6, R6, 0xC473
        ASR  R11, R2, R6
; EXPECT R11 = 0xFFFFFB87
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0xCC90
        IOR  R11, R11, 0x3904
        MHI  R6, 0xA6EE
        IOR  R6, R6, 0x1F79
        ANN  R1, R11, R6
; EXPECT R1 = 0x48102004
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0xA112
        IOR  R7, R7, 0x0FAD
        MHI  R8, 0x5B32
        IOR  R8, R8, 0x3EB5
        ANN  R5, R7, R8
; EXPECT R5 = 0xA0000108
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0x93A0
; EXPECT R1 = 0x93A00000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x3BC0
        IOR  R10, R10, 0xBA4C
        MUL  R2, R10, 53388
; EXPECT R2 = 0x44C3A190
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x000030AD

        MHI  R11, 0x41B3
        IOR  R11, R11, 0x2C48
        MHI  R8, 0xC005
        IOR  R8, R8, 0xEAB8
        ROR  R3, R11, R8
; EXPECT R3 = 0xB32C4841
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x8392
        IOR  R3, R3, 0x2B05
        MHI  R10, 0xDAD0
        IOR  R10, R10, 0xD6E4
        SBC  R1, R3, R10
; EXPECT R1 = 0xA8C15420
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0xE97B
        IOR  R1, R1, 0x1674
        ADD  R5, R1, -28212
; EXPECT R5 = 0xE97AA840
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0xE339
        IOR  R2, R2, 0x4BA0
        IOR  R4, R2, 44485
; EXPECT R4 = 0xE339EFE5
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R6, -58555
; EXPECT R6 = 0xFFFF1B45
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x4D0D
        IOR  R7, R7, 0xD986
        MHI  R4, 0x2B2F
        IOR  R4, R4, 0x82FB
        IOR  R9, R7, R4
; EXPECT R9 = 0x6F2FDBFF
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x292E
        IOR  R5, R5, 0x7A99
        MHI  R11, 0xF853
        IOR  R11, R11, 0xC6EB
        ADD  R8, R5, R11
; EXPECT R8 = 0x21824184
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x9B43
        IOR  R5, R5, 0x161C
        MHI  R10, 0x6F81
        IOR  R10, R10, 0xAF84
        ANN  R5, R5, R10
; EXPECT R5 = 0x90421018
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x3E98
        IOR  R10, R10, 0x4E63
        MOV  R7, R10
; EXPECT R7 = 0x3E984E63
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R2, H
; EXPECT R2 = 0x000030AD
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x3EE5
        IOR  R2, R2, 0x1E07
        MHI  R1, 0x6586
        IOR  R1, R1, 0x6B9A
        ROR  R6, R2, R1
; EXPECT R6 = 0xB94781CF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x530A
        IOR  R11, R11, 0x66E2
        MHI  R6, 0x384E
        IOR  R6, R6, 0x119A
        SUB  R2, R11, R6
; EXPECT R2 = 0x1ABC5548
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x2DAF
        IOR  R6, R6, 0x8338
        MHI  R11, 0x26FF
        IOR  R11, R11, 0x5794
        DIV  R5, R6, R11
; EXPECT R5 = 0x00000001
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x06B02BA4

        MHI  R11, 0x2EEF
        IOR  R11, R11, 0xF288
        MHI  R7, 0x71F2
        IOR  R7, R7, 0x6E59
        IOR  R7, R11, R7
; EXPECT R7 = 0x7FFFFED9
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x35E8
        IOR  R4, R4, 0xDE64
        MOV  R7, R4
; EXPECT R7 = 0x35E8DE64
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x1778
        IOR  R5, R5, 0x5BB9
        AND.uv  R7, R5, -12552
; EXPECT R7 = 0x17784AB8
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x11DA
        IOR  R7, R7, 0xC2B2
        MHI  R4, 0x8971
        IOR  R4, R4, 0x133A
        ADD  R6, R7, R4
; EXPECT R6 = 0x9B4BD5EC
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x21A0
        IOR  R9, R9, 0xFACF
        LSL  R11, R9, 15
; EXPECT R11 = 0x7D678000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x179C
        IOR  R4, R4, 0x5D4A
        MHI  R9, 0x77DB
        IOR  R9, R9, 0xD69F
        AND  R6, R4, R9
; EXPECT R6 = 0x1798540A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x92F2
        IOR  R6, R6, 0x7034
        MHI  R4, 0x9669
        IOR  R4, R4, 0x1218
        ADC  R11, R6, R4
; EXPECT R11 = 0x295B824C
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R11, 0xD3AE
        IOR  R11, R11, 0x1F7B
        AND.uv  R1, R11, -55856
; EXPECT R1 = 0xD3AE0550
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MOV  R7, NZCV
; EXPECT R7 = 0xB0000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R3, 0xC597
        IOR  R3, R3, 0xF21E
        MHI  R4, 0xA6FC
        IOR  R4, R4, 0x1539
        ADC  R7, R3, R4
; EXPECT R7 = 0x6C940758
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R6, 0xFDB4
        IOR  R6, R6, 0x55A8
        ASR  R1, R6, 26
; EXPECT R1 = 0xFFFFFFFF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R2, 0xEFAF
        IOR  R2, R2, 0x8CD8
        ADD.uv  R7, R2, -12694
; EXPECT R7 = 0xEFAF5B43
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R8, NZCV
; EXPECT R8 = 0xA0000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x083C
        IOR  R5, R5, 0x0B51
        MOV  R2, R5
; EXPECT R2 = 0x083C0B51
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x528A
        IOR  R6, R6, 0xAFFD
        ASR  R2, R6, 21
; EXPECT R2 = 0x00000294
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0xC5FA
        IOR  R11, R11, 0x6277
        AND  R8, R11, -12383
; EXPECT R8 = 0xC5FA4221
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0xEE10
        IOR  R4, R4, 0x8955
        XOR  R2, R4, -41014
; EXPECT R2 = 0x11EFD69F
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x166D
        IOR  R6, R6, 0x7E0D
        MHI  R11, 0x6191
        IOR  R11, R11, 0xFC17
        UMUL  R7, R6, R11
; EXPECT R7 = 0x1E481F2B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x088C46DD

        MHI  R6, 0x3568
        IOR  R6, R6, 0xB32E
        ROR  R11, R6, 11
; EXPECT R11 = 0x65C6AD16
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x0708
        IOR  R5, R5, 0xFDB2
        MUL  R1, R5, -49631
; EXPECT R1 = 0x17E7CFF2
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xFFFFFAAC

        MHI  R11, 0xA222
        IOR  R11, R11, 0x3545
        MHI  R4, 0x8A84
        IOR  R4, R4, 0xEAD9
        AND  R11, R11, R4
; EXPECT R11 = 0x82002041
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0xCED2
        IOR  R3, R3, 0x2971
        MHI  R10, 0x4149
        IOR  R10, R10, 0xAD4F
        IOR  R2, R3, R10
; EXPECT R2 = 0xCFDBAD7F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0xFD44
        IOR  R6, R6, 0xDE0F
        MHI  R10, 0x7C53
        IOR  R10, R10, 0x5922
        UMUL  R6, R6, R10
; EXPECT R6 = 0xD735B4FE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x7AFFD111

        MHI  R5, 0x7E23
        IOR  R5, R5, 0x55B5
        MHI  R2, 0xB4DE
        IOR  R2, R2, 0x1BF9
        ADC  R10, R5, R2
; EXPECT R10 = 0x330171AF
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x4B68
        IOR  R3, R3, 0x2AA1
        ANN  R9, R3, -9108
; EXPECT R9 = 0x00002281
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0xDC18
        IOR  R3, R3, 0x9BE0
        MOV  R1, R3
; EXPECT R1 = 0xDC189BE0
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x83AE
        IOR  R6, R6, 0xBE50
        AND.uv  R7, R6, -31179
; EXPECT R7 = 0x83AE8610
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0xCE76
        IOR  R9, R9, 0xCF0E
        ROR  R7, R9, 29
; EXPECT R7 = 0x73B67876
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0x1521
        IOR  R4, R4, 0x1785
        MHI  R10, 0x23E8
        IOR  R10, R10, 0xD22A
        ADD  R5, R4, R10
; EXPECT R5 = 0x3909E9AF
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x0CAC
        IOR  R5, R5, 0xC875
        MHI  R1, 0x0C2E
        IOR  R1, R1, 0x0A0D
        ROR  R6, R5, R1
; EXPECT R6 = 0x43A86566
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R1, -60821
; EXPECT R1 = 0xFFFF126B
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0x8CA4
        IOR  R8, R8, 0x6190
        MHI  R11, 0x77D5
        IOR  R11, R11, 0x0390
        UDIV  R9, R8, R11
; EXPECT R9 = 0x00000001
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x14CF5E00

        MHI  R6, 0xCFEE
        IOR  R6, R6, 0x570E
        MHI  R3, 0x7CC6
        IOR  R3, R3, 0xAA59
        AND  R9, R6, R3
; EXPECT R9 = 0x4CC60208
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R11, H
; EXPECT R11 = 0x14CF5E00
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0xB428
        IOR  R3, R3, 0xB4AE
        SUB  R3, R3, 53274
; EXPECT R3 = 0xB427E494
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0x1586
        IOR  R11, R11, 0x1E65
        ANN  R1, R11, -43782
; EXPECT R1 = 0x00000A05
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0xE36E
        IOR  R11, R11, 0x39C1
        MHI  R8, 0xF200
        IOR  R8, R8, 0x57E2
        IOR  R3, R11, R8
; EXPECT R3 = 0xF36E7FE3
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0x496B
        IOR  R11, R11, 0x170E
        AND  R6, R11, 18969
; EXPECT R6 = 0x00000208
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0xD672
        IOR  R5, R5, 0xC4B6
        MUL  R11, R5, -6801
; EXPECT R11 = 0xE10418EA
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x0000044F

        MOV  R2, NZCV
; EXPECT R2 = 0x80000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0xC527
        IOR  R4, R4, 0x9418
        MHI  R1, 0x47CA
        IOR  R1, R1, 0xD39F
        LSL  R9, R4, R1
; EXPECT R9 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x9716
        IOR  R7, R7, 0xB6C9
        IOR  R1, R7, 63398
; EXPECT R1 = 0x9716F7EF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x694D
        IOR  R9, R9, 0x78DA
        ADC  R9, R9, 116
; EXPECT R9 = 0x694D794E
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0xFB3D
        IOR  R5, R5, 0x9510
        MHI  R4, 0xDED4
        IOR  R4, R4, 0x1B1C
        ASR  R3, R5, R4
; EXPECT R3 = 0xFFFFFFFF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x1997
        IOR  R4, R4, 0xFC06
        MOV  R6, R4
; EXPECT R6 = 0x1997FC06
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0xEA09
        IOR  R6, R6, 0xC7BE
        MHI  R8, 0xFCF1
        IOR  R8, R8, 0xD1D8
        LSL  R9, R6, R8
; EXPECT R9 = 0xBE000000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R8, -14871
; EXPECT R8 = 0xFFFFC5E9
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x8A82
        IOR  R2, R2, 0x5877
        MOV  R8, R2
; EXPECT R8 = 0x8A825877
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0xE8EB
        IOR  R9, R9, 0xF879
        ASR  R7, R9, 13
; EXPECT R7 = 0xFFFF475F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x9F9D
        IOR  R7, R7, 0x5AE0
        LSL  R8, R7, 21
; EXPECT R8 = 0x5C000000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0xA14F
        IOR  R5, R5, 0x1FF6
        MHI  R10, 0x280A
        IOR  R10, R10, 0xA366
        DIV  R5, R5, R10
; EXPECT R5 = 0xFFFFFFFD
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x196F0A28

        MHI  R6, 0x8D0C
        IOR  R6, R6, 0x44F2
        MHI  R10, 0xC3F9
        IOR  R10, R10, 0x3112
        IOR  R11, R6, R10
; EXPECT R11 = 0xCFFD75F2
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0xFA4C
        IOR  R5, R5, 0xDE4D
        MHI  R7, 0x6EA7
        IOR  R7, R7, 0x529F
        UDIV  R9, R5, R7
; EXPECT R9 = 0x00000002
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x1CFE390F

        MOV  R6, NZCV
; EXPECT R6 = 0x00000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x5B51
        IOR  R9, R9, 0xBD4A
        MHI  R3, 0x6594
        IOR  R3, R3, 0x230A
        ASR  R11, R9, R3
; EXPECT R11 = 0x0016D46F
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0xF7C6
        IOR  R9, R9, 0x8862
        MHI  R1, 0x22E5
        IOR  R1, R1, 0x9395
        DIV  R4, R9, R1
; EXPECT R4 = 0xFFFFFFFF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x1AAC1BF7

        MHI  R6, 0x3AE1
        IOR  R6, R6, 0x508A
        MHI  R3, 0x9DD3
        IOR  R3, R3, 0x507B
        UMUL  R10, R6, R3
; EXPECT R10 = 0xB72AD24E
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0xE96B7812

        MHI  R7, 0x87FF
        IOR  R7, R7, 0xEA80
        MHI  R11, 0x6833
        IOR  R11, R11, 0xEBC3
        ASR  R3, R7, R11
; EXPECT R3 = 0xF0FFFD50
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R1, NZCV
; EXPECT R1 = 0x80000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R1, 19025
; EXPECT R1 = 0x00004A51
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x7332
        IOR  R9, R9, 0x5C47
        MHI  R5, 0x6F6D
        IOR  R5, R5, 0xB1F4
        DIV  R7, R9, R5
; EXPECT R7 = 0x00000001
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x03C4AA53

        MHI  R1, 0x3282
        IOR  R1, R1, 0xF332
        MHI  R11, 0x1A64
        IOR  R11, R11, 0x2E06
        LSL  R8, R1, R11
; EXPECT R8 = 0xA0BCCC80
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x27DA
        IOR  R2, R2, 0xEFC1
        IOR  R4, R2, -44291
; EXPECT R4 = 0xFFFFFFFD
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x367F
        IOR  R2, R2, 0x9748
        MHI  R6, 0x91CE
        IOR  R6, R6, 0xA98A
        MUL  R2, R2, R6
; EXPECT R2 = 0x1F9614D0
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0xE88AAC2B

        MHI  R6, 0x310A
        IOR  R6, R6, 0xEDD6
        MHI  R4, 0xD631
        IOR  R4, R4, 0x96BB
        IOR  R2, R6, R4
; EXPECT R2 = 0xF73BFFFF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x0645
        IOR  R6, R6, 0xBC44
        MHI  R3, 0xBC35
        IOR  R3, R3, 0x7667
        XOR  R3, R6, R3
; EXPECT R3 = 0xBA70CA23
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x3450
        IOR  R9, R9, 0xA7E4
        MHI  R7, 0x8BA5
        IOR  R7, R7, 0xC810
        ASR  R11, R9, R7
; EXPECT R11 = 0x00003450
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x233F
        IOR  R5, R5, 0x834D
        DIV  R11, R5, 10199
; EXPECT R11 = 0x0000E27E
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x0000197B

        MHI  R2, 0xB3B3
        IOR  R2, R2, 0x0740
        MHI  R3, 0x7848
        IOR  R3, R3, 0x0B90
        ASR  R4, R2, R3
; EXPECT R4 = 0xFFFFB3B3
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x2673
        IOR  R7, R7, 0x8FED
        MOV  R4, R7
; EXPECT R4 = 0x26738FED
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x9043
        IOR  R6, R6, 0x17A5
        ADC  R3, R6, 64693
; EXPECT R3 = 0x9044145A
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x986F
        IOR  R5, R5, 0x5502
        XOR  R3, R5, 38887
; EXPECT R3 = 0x986FC2E5
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x90FA
        IOR  R6, R6, 0x5477
        ADC  R3, R6, 28899
; EXPECT R3 = 0x90FAC55A
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x2FB8
        IOR  R9, R9, 0x2DE6
        XOR  R5, R9, 34440
; EXPECT R5 = 0x2FB8AB6E
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0xAE84
        IOR  R7, R7, 0x5869
        MHI  R10, 0x5FCD
        IOR  R10, R10, 0x9FBB
        UDIV  R2, R7, R10
; EXPECT R2 = 0x00000001
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x4EB6B8AE

        MHI  R9, 0x38F5
        IOR  R9, R9, 0x0FE2
        SBC  R1, R9, 58255
; EXPECT R1 = 0x38F42C53
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x4D53
        IOR  R6, R6, 0xFAF5
        MHI  R3, 0xF58B
        IOR  R3, R3, 0x87B7
        ROR  R10, R6, R3
; EXPECT R10 = 0xA7F5EA9A
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x20DC
        IOR  R3, R3, 0xC99F
        ANN  R11, R3, 25241
; EXPECT R11 = 0x20DC8906
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x68CD
        IOR  R3, R3, 0xA0ED
        MHI  R6, 0x2F03
        IOR  R6, R6, 0xA80B
        DIV  R9, R3, R6
; EXPECT R9 = 0x00000002
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x0AC650D7

        MHI  R1, 0xCD24
        IOR  R1, R1, 0xE15F
        MHI  R8, 0xC352
        IOR  R8, R8, 0xB42F
        ADD  R10, R1, R8
; EXPECT R10 = 0x9077958E
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0x82EE
        IOR  R8, R8, 0x8B3A
        SBC  R7, R8, 41257
; EXPECT R7 = 0x82EDEA10
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0x8E71
        IOR  R8, R8, 0x3DA8
        MHI  R1, 0x7C5E
        IOR  R1, R1, 0xD16F
        DIV  R11, R8, R1
; EXPECT R11 = 0xFFFFFFFF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x0AD00F17

        MHI  R1, 0x923D
        IOR  R1, R1, 0x3A2D
        SBC  R9, R1, 42428
; EXPECT R9 = 0x923C9471
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R6, H
; EXPECT R6 = 0x0AD00F17
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0x61CC
        IOR  R11, R11, 0x8E1E
        MHI  R5, 0x0210
        IOR  R5, R5, 0x218D
        ANN  R6, R11, R5
; EXPECT R6 = 0x61CC8E12
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x20DB
        IOR  R3, R3, 0x22C6
        MHI  R7, 0x63DD
        IOR  R7, R7, 0x5D9F
        IOR  R2, R3, R7
; EXPECT R2 = 0x63DF7FDF
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R6, H
; EXPECT R6 = 0x0AD00F17
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0xD747
        IOR  R4, R4, 0xFE49
        MHI  R3, 0x3F6B
        IOR  R3, R3, 0x4F7B
        ROR  R10, R4, R3
; EXPECT R10 = 0xE8FFC93A
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R5, NZCV
; EXPECT R5 = 0x80000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x4ABB
        IOR  R9, R9, 0xC218
        MHI  R2, 0xD750
        IOR  R2, R2, 0x1F3F
        UMUL  R2, R9, R2
; EXPECT R2 = 0xF035ABE8
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0xF41F51B5

        MHI  R9, 0x1194
        IOR  R9, R9, 0xBBBD
        MHI  R3, 0xBF65
        IOR  R3, R3, 0xAE47
        XOR  R9, R9, R3
; EXPECT R9 = 0xAEF115FA
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0x925E
        IOR  R11, R11, 0x2769
        MHI  R5, 0xEF45
        IOR  R5, R5, 0x2D1F
        AND  R1, R11, R5
; EXPECT R1 = 0x82442509
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x1A29
        IOR  R6, R6, 0x571E
        MHI  R5, 0xDA8A
        IOR  R5, R5, 0x0541
        UMUL  R2, R6, R5
; EXPECT R2 = 0xF55EB49E
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0xFC2BF7E3

        MHI  R9, 0xA62F
        IOR  R9, R9, 0xE53E
        IOR  R9, R9, 28172
; EXPECT R9 = 0xA62FEF3E
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0xB1F2
; EXPECT R6 = 0xB1F20000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x8AC7
        IOR  R5, R5, 0x6493
        MOV  R5, R5
; EXPECT R5 = 0x8AC76493
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R10, H
; EXPECT R10 = 0xFC2BF7E3
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x7FEF
        IOR  R1, R1, 0xD0DF
        DIV  R6, R1, 40375
; EXPECT R6 = 0x0000CFAA
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x00001C59

        MOV  R10, NZCV
; EXPECT R10 = 0x00000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x497A
        IOR  R9, R9, 0xE5BE
        ADD.uv  R4, R9, -50342
; EXPECT R4 = 0x497A2118
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0xB09C
        IOR  R10, R10, 0x15A9
        ADD  R5, R10, 52881
; EXPECT R5 = 0xB09CE43A
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0xBBFA
        IOR  R1, R1, 0x39EF
        MOV  R11, R1
; EXPECT R11 = 0xBBFA39EF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R1, NZCV
; EXPECT R1 = 0x80000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x5B93
        IOR  R1, R1, 0x9441
        DIV  R8, R1, 13950
; EXPECT R8 = 0x0001AE38
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x000004B1

        MOV  R6, H
; EXPECT R6 = 0x000004B1
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R8, 41067
; EXPECT R8 = 0x0000A06B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0x29CB
        IOR  R8, R8, 0x7E80
        AND.uv  R2, R8, -996
; EXPECT R2 = 0x29CB7C00
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0xB6FD
        IOR  R5, R5, 0x860F
        MHI  R4, 0x0DB2
        IOR  R4, R4, 0x7620
        ADD  R11, R5, R4
; EXPECT R11 = 0xC4AFFC2F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R3, H
; EXPECT R3 = 0x000004B1
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x5BCF
        IOR  R7, R7, 0x3610
        ADC  R8, R7, 54539
; EXPECT R8 = 0x5BD00B1B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x6BE9
        IOR  R5, R5, 0xDAC6
        IOR  R7, R5, -8195
; EXPECT R7 = 0xFFFFDFFF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R6, NZCV
; EXPECT R6 = 0x80000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0xC1D2
        IOR  R4, R4, 0x24B1
        MHI  R3, 0x4E4E
        IOR  R3, R3, 0xA1CA
        ADD  R1, R4, R3
; EXPECT R1 = 0x1020C67B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x0CD2
        IOR  R10, R10, 0x9508
        ADD  R11, R10, -27789
; EXPECT R11 = 0x0CD2287B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0xE49C
        IOR  R5, R5, 0x06EF
        ADD  R4, R5, -50358
; EXPECT R4 = 0xE49B4239
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0x68A8
        IOR  R8, R8, 0x0557
        ROR  R5, R8, 28
; EXPECT R5 = 0x8A805576
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x5E0C
; EXPECT R2 = 0x5E0C0000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R1, H
; EXPECT R1 = 0x000004B1
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0x7089
        IOR  R1, R1, 0xF591
        AND  R5, R1, -25968
; EXPECT R5 = 0x70899090
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0x17EB
        IOR  R1, R1, 0x331C
        IOR  R9, R1, 37396
; EXPECT R9 = 0x17EBB31C
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x7F28
        IOR  R11, R11, 0x4313
        MHI  R1, 0x62F9
        IOR  R1, R1, 0xD85F
        ADC  R9, R11, R1
; EXPECT R9 = 0xE2221B73
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R10, 0x5D90
        IOR  R10, R10, 0xBDCA
        ADD.uv  R6, R10, -60898
; EXPECT R6 = 0x5D8FCFE8
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x836E
        IOR  R2, R2, 0x1046
        AND.uv  R11, R2, -11850
; EXPECT R11 = 0x836E1006
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0xE05D
        IOR  R10, R10, 0x734B
        AND.uv  R7, R10, -39180
; EXPECT R7 = 0xE05D6240
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0x6BFC
        IOR  R4, R4, 0xF0AE
        DIV  R3, R4, 25318
; EXPECT R3 = 0x00011787
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x00001F64

        MHI  R5, 0xF1F6
        IOR  R5, R5, 0x57D1
        MHI  R4, 0x0DDB
        IOR  R4, R4, 0x8D44
        ROR  R5, R5, R4
; EXPECT R5 = 0x1F1F657D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x6E14
        IOR  R7, R7, 0x990A
        MHI  R9, 0x5242
        IOR  R9, R9, 0xC937
        ADC  R11, R7, R9
; EXPECT R11 = 0xC0576242
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R11, 0x2687
        IOR  R11, R11, 0xC40F
        MHI  R6, 0x5046
        IOR  R6, R6, 0xC119
        ADD  R11, R11, R6
; EXPECT R11 = 0x76CE8528
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x4CDF
        IOR  R3, R3, 0x734E
        MHI  R8, 0x290B
        IOR  R8, R8, 0x230A
        UMUL  R3, R3, R8
; EXPECT R3 = 0xFFD82B0C
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x0C532196

        MOV  R5, 7503
; EXPECT R5 = 0x00001D4F
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0x06B2
; EXPECT R11 = 0x06B20000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0xEE8E
        IOR  R7, R7, 0x9DE4
        SUB.uv  R8, R7, -27342
; EXPECT R8 = 0xEE8F08B2
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x7A1F
        IOR  R6, R6, 0x642C
        SUB  R2, R6, -4491
; EXPECT R2 = 0x7A1F75B7
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0xDE5E
        IOR  R8, R8, 0x5CBD
        MOV  R11, R8
; EXPECT R11 = 0xDE5E5CBD
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x4FA4
        IOR  R7, R7, 0xAE6C
        MHI  R2, 0x6B5D
        IOR  R2, R2, 0xFD9A
        IOR  R7, R7, R2
; EXPECT R7 = 0x6FFDFFFE
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0xB5A1
        IOR  R8, R8, 0xAF34
        IOR  R7, R8, -8700
; EXPECT R7 = 0xFFFFFF34
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x4D80
        IOR  R2, R2, 0xB793
        IOR  R9, R2, 32950
; EXPECT R9 = 0x4D80B7B7
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0x41BF
        IOR  R9, R9, 0x1E38
        XOR  R11, R9, -18406
; EXPECT R11 = 0xBE40A622
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x8709
        IOR  R10, R10, 0x21FA
        MHI  R4, 0x4768
        IOR  R4, R4, 0x0345
        UDIV  R5, R10, R4
; EXPECT R5 = 0x00000001
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x3FA11EB5

        MHI  R10, 0x6075
        IOR  R10, R10, 0xD5D1
        ROR  R8, R10, 13
; EXPECT R8 = 0xAE8B03AE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0x311F
        IOR  R4, R4, 0x29D9
        MHI  R11, 0x455C
        IOR  R11, R11, 0x398B
        XOR  R8, R4, R11
; EXPECT R8 = 0x74431052
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x054A
        IOR  R3, R3, 0x296D
        MHI  R8, 0x8245
        IOR  R8, R8, 0xD08F
        ADC  R11, R3, R8
; EXPECT R11 = 0x878FF9FD
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x7460
        IOR  R10, R10, 0x558F
        DIV  R4, R10, 538
; EXPECT R4 = 0x00376047
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x00000059

        MHI  R11, 0x3CE6
        IOR  R11, R11, 0xA108
        MHI  R5, 0xA0DD
        IOR  R5, R5, 0x3A61
        SBC  R7, R11, R5
; EXPECT R7 = 0x9C0966A7
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R9, 0xBB6F
        IOR  R9, R9, 0xDCAB
        MHI  R10, 0x283C
        IOR  R10, R10, 0xB7A8
        ASR  R3, R9, R10
; EXPECT R3 = 0xFFBB6FDC
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R8, 0x479D
        IOR  R8, R8, 0x286E
        SBC  R2, R8, 129
; EXPECT R2 = 0x479D27EC
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0xDEED
        IOR  R8, R8, 0xA419
        LSL  R5, R8, 22
; EXPECT R5 = 0x06400000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x7EDD
        IOR  R2, R2, 0x9A3C
        AND.uv  R10, R2, -32829
; EXPECT R10 = 0x7EDD1A00
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0xCE95
        IOR  R2, R2, 0x2EF1
        MHI  R7, 0xBDDF
        IOR  R7, R7, 0xD8E4
        AND  R1, R2, R7
; EXPECT R1 = 0x8C9508E0
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0xF0A8
        IOR  R3, R3, 0xCBAF
        SBC  R9, R3, 41343
; EXPECT R9 = 0xF0A82A30
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x5FAB
        IOR  R1, R1, 0x48B8
        MHI  R5, 0x0A18
        IOR  R5, R5, 0xCBED
        AND  R4, R1, R5
; EXPECT R4 = 0x0A0848A8
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x85ED
        IOR  R9, R9, 0x6C8C
        ASR  R8, R9, 27
; EXPECT R8 = 0xFFFFFFF0
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0xB7AA
        IOR  R3, R3, 0xD434
        ADD  R9, R3, 30319
; EXPECT R9 = 0xB7AB4AA3
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0xD8E8
        IOR  R10, R10, 0xD459
        MHI  R9, 0x3784
        IOR  R9, R9, 0x2359
        ADD  R7, R10, R9
; EXPECT R7 = 0x106CF7B2
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0xB9FA
        IOR  R6, R6, 0xA783
        MHI  R7, 0x3451
        IOR  R7, R7, 0xD439
        IOR  R4, R6, R7
; EXPECT R4 = 0xBDFBF7BB
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0xE034
        IOR  R9, R9, 0xBA74
        AND.uv  R3, R9, -3733
; EXPECT R3 = 0xE034B060
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0x7BBB
        IOR  R8, R8, 0xA2FB
        MHI  R6, 0xCA13
        IOR  R6, R6, 0xB759
        SBC  R3, R8, R6
; EXPECT R3 = 0xB1A7EBA1
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MOV  R10, H
; EXPECT R10 = 0x00000059
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R2, 0xC75E
        IOR  R2, R2, 0xE9CE
        MHI  R6, 0x7B3D
        IOR  R6, R6, 0xCBFC
        IOR  R6, R2, R6
; EXPECT R6 = 0xFF7FEBFE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R1, 0xD7C5
        IOR  R1, R1, 0x608C
        MHI  R9, 0x8F2D
        IOR  R9, R9, 0x72D9
        ADD  R11, R1, R9
; EXPECT R11 = 0x66F2D365
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R8, 0xB113
        IOR  R8, R8, 0x42B0
        MHI  R7, 0x42DB
        IOR  R7, R7, 0x2F2F
        UDIV  R7, R8, R7
; EXPECT R7 = 0x00000002
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1
; EXPECT H = 0x2B5CE452

        MHI  R7, 0xC5F2
        IOR  R7, R7, 0x16EE
        MHI  R3, 0x4160
        IOR  R3, R3, 0x0F34
        UDIV  R3, R7, R3
; EXPECT R3 = 0x00000003
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1
; EXPECT H = 0x01D1E952

        MHI  R9, 0xDC65
        IOR  R9, R9, 0x7176
        MHI  R6, 0xCD73
        IOR  R6, R6, 0x25DE
        ASR  R11, R9, R6
; EXPECT R11 = 0xFFFFFFFF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R2, 0x2334
        IOR  R2, R2, 0xFFC2
        AND  R3, R2, 9639
; EXPECT R3 = 0x00002582
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R11, 0x2126
        IOR  R11, R11, 0xE97D
        SBC  R10, R11, 47853
; EXPECT R10 = 0x21262E8F
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x9736
        IOR  R2, R2, 0xD79B
        ASR  R7, R2, 5
; EXPECT R7 = 0xFCB9B6BC
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x3F07
; EXPECT R3 = 0x3F070000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0xC1C7
        IOR  R9, R9, 0x227C
        MHI  R5, 0x375A
        IOR  R5, R5, 0x007A
        IOR  R7, R9, R5
; EXPECT R7 = 0xF7DF227E
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x6144
        IOR  R1, R1, 0x85B5
        MHI  R3, 0x8F02
        IOR  R3, R3, 0x5F6F
        ASR  R2, R1, R3
; EXPECT R2 = 0x0000C289
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R2, H
; EXPECT R2 = 0x01D1E952
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x47B1
        IOR  R6, R6, 0x6C71
        IOR  R6, R6, -12480
; EXPECT R6 = 0xFFFFEF71
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0xC968
        IOR  R3, R3, 0x3617
        MHI  R4, 0x14B8
        IOR  R4, R4, 0x2BCB
        ADC  R7, R3, R4
; EXPECT R7 = 0xDE2061E2
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0xB5DB
        IOR  R4, R4, 0xC6A4
        MHI  R5, 0x45C6
        IOR  R5, R5, 0x66FC
        MUL  R5, R4, R5
; EXPECT R5 = 0x6C54E170
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0xEBCAC6B2

        MHI  R3, 0x4A5B
        IOR  R3, R3, 0x9577
        ADC  R6, R3, 14467
; EXPECT R6 = 0x4A5BCDFA
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x0C0A
        IOR  R4, R4, 0x8CE8
        SUB  R9, R4, -48742
; EXPECT R9 = 0x0C0B4B4E
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x9852
        IOR  R7, R7, 0xE756
        MHI  R6, 0x3203
        IOR  R6, R6, 0x4B2D
        MUL  R11, R7, R6
; EXPECT R11 = 0x925ADC1E
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xEBBEDBB5

        MHI  R7, 0x7F43
        IOR  R7, R7, 0xA60D
        MHI  R4, 0xBD05
        IOR  R4, R4, 0x6931
        ADD  R10, R7, R4
; EXPECT R10 = 0x3C490F3E
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R5, H
; EXPECT R5 = 0xEBBEDBB5
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x8CBF
        IOR  R7, R7, 0xE6C2
        MHI  R6, 0x244C
        IOR  R6, R6, 0xA75C
        ADD  R8, R7, R6
; EXPECT R8 = 0xB10C8E1E
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0xC200
        IOR  R7, R7, 0xFA00
        SUB.uv  R7, R7, -23941
; EXPECT R7 = 0xC2015785
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0xF4F8
        IOR  R3, R3, 0x4BC6
        SBC  R1, R3, 10587
; EXPECT R1 = 0xF4F8226A
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x4E6E
        IOR  R7, R7, 0x43F7
        MHI  R5, 0x11D5
        IOR  R5, R5, 0x13E4
        SUB  R2, R7, R5
; EXPECT R2 = 0x3C993013
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0xF766
        IOR  R10, R10, 0x7759
        ADD.uv  R10, R10, -12327
; EXPECT R10 = 0xF7664732
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x91AB
        IOR  R10, R10, 0xDE05
        MHI  R6, 0xE489
        IOR  R6, R6, 0xBA6B
        ADC  R3, R10, R6
; EXPECT R3 = 0x76359871
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R8, 0x8301
        IOR  R8, R8, 0x3D00
        MHI  R3, 0x07E7
        IOR  R3, R3, 0xF7A4
        SUB  R9, R8, R3
; EXPECT R9 = 0x7B19455C
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R11, 0x0E71
        IOR  R11, R11, 0xAE7C
        MHI  R6, 0x99B9
        IOR  R6, R6, 0x7302
        ADC  R11, R11, R6
; EXPECT R11 = 0xA82B217E
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x08CB
        IOR  R6, R6, 0x5FD0
        MOV  R11, R6
; EXPECT R11 = 0x08CB5FD0
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x1C2C
        IOR  R7, R7, 0xFD27
        MHI  R5, 0x38CA
        IOR  R5, R5, 0x23B1
        ADC  R9, R7, R5
; EXPECT R9 = 0x54F720D8
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0xBF7F
        IOR  R8, R8, 0x4F83
        MHI  R9, 0x29FF
        IOR  R9, R9, 0xB807
        SUB  R1, R8, R9
; EXPECT R1 = 0x957F977C
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0xC344
        IOR  R10, R10, 0x19D3
        MHI  R1, 0x01C0
        IOR  R1, R1, 0xFF02
        ASR  R7, R10, R1
; EXPECT R7 = 0xF0D10674
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x9B67
        IOR  R10, R10, 0x7F6B
        MHI  R1, 0xA7E9
        IOR  R1, R1, 0xDE61
        MUL  R5, R10, R1
; EXPECT R5 = 0x6819118B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x229D1E84

        MHI  R1, 0xEE22
        IOR  R1, R1, 0xC80B
        MHI  R6, 0xEF94
        IOR  R6, R6, 0x35C5
        IOR  R6, R1, R6
; EXPECT R6 = 0xEFB6FDCF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R1, H
; EXPECT R1 = 0x229D1E84
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x2B03
        IOR  R4, R4, 0xF96B
        MHI  R5, 0xA790
        IOR  R5, R5, 0xE5E4
        ANN  R6, R4, R5
; EXPECT R6 = 0x0803180B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x8846
        IOR  R5, R5, 0xC293
        MHI  R9, 0xA38B
        IOR  R9, R9, 0xA7DF
        ADC  R1, R5, R9
; EXPECT R1 = 0x2BD26A72
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R4, 0x754C
        IOR  R4, R4, 0x80FE
        ADD  R7, R4, -42545
; EXPECT R7 = 0x754BDACD
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R6, H
; EXPECT R6 = 0x229D1E84
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0xCAB1
        IOR  R9, R9, 0x71F3
        MHI  R3, 0xF007
        IOR  R3, R3, 0x41F4
        SBC  R4, R9, R3
; EXPECT R4 = 0xDAAA2FFE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x3588
        IOR  R7, R7, 0x04E0
        MOV  R2, R7
; EXPECT R2 = 0x358804E0
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0xA747
        IOR  R11, R11, 0xD9B6
        MHI  R6, 0x1B12
        IOR  R6, R6, 0x967D
        ANN  R3, R11, R6
; EXPECT R3 = 0xA4454982
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x798F
        IOR  R5, R5, 0x988F
        MOV  R5, R5
; EXPECT R5 = 0x798F988F
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x10AD
        IOR  R3, R3, 0x8BBD
        ASR  R8, R3, 24
; EXPECT R8 = 0x00000010
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x596E
        IOR  R5, R5, 0xFB0E
        XOR  R2, R5, -27539
; EXPECT R2 = 0xA6916F63
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0xBF92
        IOR  R1, R1, 0x85F1
        MHI  R3, 0xC9E4
        IOR  R3, R3, 0x14E1
        LSL  R1, R1, R3
; EXPECT R1 = 0x7F250BE2
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0xA488
        IOR  R10, R10, 0x24B1
        MHI  R11, 0x3E40
        IOR  R11, R11, 0xB7A9
        ADC  R4, R10, R11
; EXPECT R4 = 0xE2C8DC5B
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0xB86E
        IOR  R2, R2, 0x4BE7
        AND.uv  R11, R2, -60989
; EXPECT R11 = 0xB86E01C3
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x1EB5
        IOR  R10, R10, 0x6201
        MHI  R5, 0x54EC
        IOR  R5, R5, 0xEE2A
        UDIV  R2, R10, R5
; EXPECT R2 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x1EB56201

        MOV  R6, NZCV
; EXPECT R6 = 0x40000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x4B1B
        IOR  R10, R10, 0xDD87
        IOR  R1, R10, 57794
; EXPECT R1 = 0x4B1BFDC7
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x137F
        IOR  R7, R7, 0xAAF5
        MHI  R6, 0xF46D
        IOR  R6, R6, 0x6255
        ADC  R9, R7, R6
; EXPECT R9 = 0x07ED0D4A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R8, H
; EXPECT R8 = 0x1EB56201
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0xB142
        IOR  R8, R8, 0x4DAE
        MHI  R2, 0xEA86
        IOR  R2, R2, 0x4699
        SBC  R7, R8, R2
; EXPECT R7 = 0xC6BC0714
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x49D9
; EXPECT R7 = 0x49D90000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x8818
        IOR  R2, R2, 0xF2F6
        MHI  R8, 0x8A2C
        IOR  R8, R8, 0x97A0
        UMUL  R7, R2, R8
; EXPECT R7 = 0x252EF3C0
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xC15C34E8

        MOV  R6, NZCV
; EXPECT R6 = 0x20000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x69D4
        IOR  R5, R5, 0x3814
        MHI  R11, 0x278D
        IOR  R11, R11, 0xAFD6
        SBC  R9, R5, R11
; EXPECT R9 = 0x4246883D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0xA909
        IOR  R6, R6, 0xABD5
        MHI  R1, 0x15BE
        IOR  R1, R1, 0xB0B0
        UDIV  R6, R6, R1
; EXPECT R6 = 0x00000007
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x10D2D705

        MHI  R11, 0xE8B0
        IOR  R11, R11, 0x2209
        MHI  R7, 0xCCDE
        IOR  R7, R7, 0xF827
        ASR  R8, R11, R7
; EXPECT R8 = 0xFFD16044
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x4E7A
; EXPECT R9 = 0x4E7A0000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x34CB
        IOR  R9, R9, 0x0F51
        MOV  R8, R9
; EXPECT R8 = 0x34CB0F51
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0xB00B
        IOR  R10, R10, 0x8276
        MHI  R7, 0xA856
        IOR  R7, R7, 0x5ED9
        ANN  R6, R10, R7
; EXPECT R6 = 0x10098026
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x32A6
        IOR  R2, R2, 0xD418
        MOV  R1, R2
; EXPECT R1 = 0x32A6D418
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R10, 59593
; EXPECT R10 = 0x0000E8C9
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0xE99C
        IOR  R8, R8, 0xD724
        MHI  R4, 0x7F5D
        IOR  R4, R4, 0x4E95
        DIV  R11, R8, R4
; EXPECT R11 = 0xFFFFFFFF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x68FA25B9

        MHI  R7, 0xEE0D
        IOR  R7, R7, 0xE385
        ROR  R3, R7, 20
; EXPECT R3 = 0xDE385EE0
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R4, NZCV
; EXPECT R4 = 0x80000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x4B62
        IOR  R2, R2, 0xAE1C
        MHI  R10, 0xDF3A
        IOR  R10, R10, 0xCE15
        ROR  R8, R2, R10
; EXPECT R8 = 0x1570E25B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x4C8E
        IOR  R9, R9, 0xF343
        MHI  R7, 0x4CBB
        IOR  R7, R7, 0x7BB0
        UMUL  R6, R9, R7
; EXPECT R6 = 0xE7196F10
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x16F281A0

        MOV  R11, 50109
; EXPECT R11 = 0x0000C3BD
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R10, NZCV
; EXPECT R10 = 0x00000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x6A0C
        IOR  R3, R3, 0x73C4
        ROR  R5, R3, 1
; EXPECT R5 = 0x350639E2
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0xCDD3
        IOR  R3, R3, 0x269F
        ANN  R5, R3, -64702
; EXPECT R5 = 0x0000249D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x349C
        IOR  R3, R3, 0xAAF5
        ADD  R7, R3, -30382
; EXPECT R7 = 0x349C3447
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x67FD
        IOR  R6, R6, 0x0949
        ASR  R1, R6, 5
; EXPECT R1 = 0x033FE84A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0xD07A
        IOR  R4, R4, 0x6956
        MHI  R3, 0x535E
        IOR  R3, R3, 0x2DF1
        UMUL  R4, R4, R3
; EXPECT R4 = 0x575547F6
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x43E46283

        MHI  R8, 0x7A90
; EXPECT R8 = 0x7A900000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x8279
        IOR  R11, R11, 0xDF2F
        MHI  R10, 0x3417
        IOR  R10, R10, 0x0E53
        ROR  R4, R11, R10
; EXPECT R4 = 0x3BE5F04F
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x9462
        IOR  R2, R2, 0x664A
        ROR  R8, R2, 31
; EXPECT R8 = 0x28C4CC95
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x8A8D
        IOR  R11, R11, 0x029B
        MOV  R10, R11
; EXPECT R10 = 0x8A8D029B
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0x5E3D
        IOR  R9, R9, 0x35E7
        ASR  R10, R9, 27
; EXPECT R10 = 0x0000000B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x8A98
        IOR  R5, R5, 0xC07D
        MHI  R8, 0x6AC1
        IOR  R8, R8, 0xC522
        ADC  R9, R5, R8
; EXPECT R9 = 0xF55A85A0
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0xAC50
        IOR  R5, R5, 0xD586
        ROR  R10, R5, 25
; EXPECT R10 = 0x286AC356
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x0CE1
        IOR  R4, R4, 0x59D4
        MHI  R1, 0x2F67
        IOR  R1, R1, 0x3D3B
        SBC  R7, R4, R1
; EXPECT R7 = 0xDD7A1C99
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R6, 25969
; EXPECT R6 = 0x00006571
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0xD39E
        IOR  R1, R1, 0xBE77
        ADC  R8, R1, 50326
; EXPECT R8 = 0xD39F830E
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0xB95B
        IOR  R7, R7, 0xB425
        MHI  R8, 0x3E41
        IOR  R8, R8, 0xE8E0
        DIV  R3, R7, R8
; EXPECT R3 = 0xFFFFFFFE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x35DF85E5

        MHI  R5, 0xF5DC
        IOR  R5, R5, 0xBD5E
        ROR  R8, R5, 30
; EXPECT R8 = 0xD772F57B
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x563C
        IOR  R7, R7, 0x38E2
        ROR  R11, R7, 0
; EXPECT R11 = 0x563C38E2
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0xFDEE
        IOR  R2, R2, 0x6309
        MHI  R9, 0x1820
        IOR  R9, R9, 0x6C0B
        XOR  R6, R2, R9
; EXPECT R6 = 0xE5CE0F02
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x2DE5
        IOR  R7, R7, 0xFC34
        MHI  R2, 0x3D7F
        IOR  R2, R2, 0xD9B5
        UDIV  R10, R7, R2
; EXPECT R10 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x2DE5FC34

        MHI  R6, 0xF365
        IOR  R6, R6, 0x13D0
        SUB  R8, R6, -59680
; EXPECT R8 = 0xF365FCF0
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0xF383
        IOR  R6, R6, 0x597C
        MHI  R2, 0x0DF0
        IOR  R2, R2, 0x634A
        SBC  R6, R6, R2
; EXPECT R6 = 0xE592F631
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x1BD1
        IOR  R4, R4, 0x8743
        MOV  R4, R4
; EXPECT R4 = 0x1BD18743
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0xEB18
        IOR  R9, R9, 0x6F87
        DIV  R8, R9, 48781
; EXPECT R8 = 0xFFFFE3EA
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x00003BA5

        MHI  R4, 0x76C0
        IOR  R4, R4, 0x46FA
        MOV  R1, R4
; EXPECT R1 = 0x76C046FA
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x991E
        IOR  R1, R1, 0x7DA6
        MHI  R6, 0xC4BD
        IOR  R6, R6, 0x6375
        AND  R8, R1, R6
; EXPECT R8 = 0x801C6124
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0x5253
        IOR  R11, R11, 0x9831
        MHI  R6, 0x60B2
        IOR  R6, R6, 0x5EE1
        UDIV  R1, R11, R6
; EXPECT R1 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x52539831

        MHI  R9, 0x7329
        IOR  R9, R9, 0x5C7C
        MHI  R7, 0x1DF8
        IOR  R7, R7, 0x2EF9
        ADC  R5, R9, R7
; EXPECT R5 = 0x91218B75
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R7, 0x951C
        IOR  R7, R7, 0x1919
        MHI  R10, 0xD9A5
        IOR  R10, R10, 0x1E4F
        SUB  R7, R7, R10
; EXPECT R7 = 0xBB76FACA
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x40EB
        IOR  R10, R10, 0xDD21
        MHI  R9, 0xCEAD
        IOR  R9, R9, 0x8F58
        ADD  R4, R10, R9
; EXPECT R4 = 0x0F996C79
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0xEE26
        IOR  R9, R9, 0x145B
        AND  R7, R9, 11948
; EXPECT R7 = 0x00000408
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0x341C
        IOR  R9, R9, 0x1F46
        IOR  R9, R9, 2981
; EXPECT R9 = 0x341C1FE7
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x3E5B
        IOR  R10, R10, 0x72EA
        MHI  R6, 0x2540
        IOR  R6, R6, 0x0654
        DIV  R3, R10, R6
; EXPECT R3 = 0x00000001
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x191B6C96

        MHI  R3, 0x137F
        IOR  R3, R3, 0x77DD
        SUB.uv  R5, R3, -25922
; EXPECT R5 = 0x137FDD1E
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R4, H
; EXPECT R4 = 0x191B6C96
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x44B7
        IOR  R7, R7, 0xA51D
        ADC  R8, R7, 37695
; EXPECT R8 = 0x44B8385D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x0AF8
        IOR  R7, R7, 0xD588
        MHI  R3, 0xDCA6
        IOR  R3, R3, 0x6515
        AND  R2, R7, R3
; EXPECT R2 = 0x08A04500
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0xCFB9
        IOR  R1, R1, 0x14D8
        LSL  R6, R1, 0
; EXPECT R6 = 0xCFB914D8
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x5F49
        IOR  R1, R1, 0x1806
        AND  R4, R1, -56494
; EXPECT R4 = 0x5F490002
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0xE2E1
        IOR  R8, R8, 0x229F
        MHI  R9, 0xF70B
        IOR  R9, R9, 0xD571
        ADD  R1, R8, R9
; EXPECT R1 = 0xD9ECF810
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0x6A3C
        IOR  R9, R9, 0x1FAE
        MHI  R6, 0x7C2F
        IOR  R6, R6, 0x3F1E
        ANN  R7, R9, R6
; EXPECT R7 = 0x021000A0
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x702E
        IOR  R11, R11, 0x36E2
        MHI  R10, 0xD1DB
        IOR  R10, R10, 0x6F72
        SBC  R6, R11, R10
; EXPECT R6 = 0x9E52C76F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R2, 0x6A16
        IOR  R2, R2, 0x2ABB
        MHI  R6, 0x681D
        IOR  R6, R6, 0x9F48
        ASR  R11, R2, R6
; EXPECT R11 = 0x006A162A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R5, 0xFA46
        IOR  R5, R5, 0x83DA
        MHI  R6, 0x10E8
        IOR  R6, R6, 0x7AC8
        XOR  R5, R5, R6
; EXPECT R5 = 0xEAAEF912
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R11, 0x38B2
        IOR  R11, R11, 0x1D37
        MHI  R3, 0xB96A
        IOR  R3, R3, 0x3D81
        MUL  R8, R11, R3
; EXPECT R8 = 0xDA7CD3B7
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1
; EXPECT H = 0xF05E2144

        MHI  R6, 0x1F06
        IOR  R6, R6, 0x5203
        MHI  R4, 0xABB7
        IOR  R4, R4, 0x59C9
        UMUL  R11, R6, R4
; EXPECT R11 = 0x2F9E6F5B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1
; EXPECT H = 0xF5C91F2B

        MHI  R4, 0xC222
        IOR  R4, R4, 0xD5E3
        MUL  R6, R4, -31300
; EXPECT R6 = 0xD4D101B4
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1
; EXPECT H = 0x00001D8B

        MOV  R5, -36734
; EXPECT R5 = 0xFFFF7082
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R10, 0xEEF2
; EXPECT R10 = 0xEEF20000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R11, 0x1E80
        IOR  R11, R11, 0x7803
        MHI  R7, 0x3984
        IOR  R7, R7, 0x091F
        DIV  R3, R11, R7
; EXPECT R3 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 1
; EXPECT V = 1
; EXPECT H = 0x1E807803

        MHI  R9, 0xA6D7
        IOR  R9, R9, 0x4A26
        AND  R11, R9, -62793
; EXPECT R11 = 0xA6D70A26
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MOV  R11, H
; EXPECT R11 = 0x1E807803
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R1, 0x4911
        IOR  R1, R1, 0x27DE
        MHI  R2, 0x4911
        IOR  R2, R2, 0x3C7F
        SBC  R4, R1, R2
; EXPECT R4 = 0xFFFFEB5E
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0xE1F5
        IOR  R9, R9, 0xD861
        SUB.uv  R8, R9, -447
; EXPECT R8 = 0xE1F5DA1F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x5438
        IOR  R5, R5, 0x1E66
        MHI  R2, 0x1C22
        IOR  R2, R2, 0xB568
        AND  R2, R5, R2
; EXPECT R2 = 0x14201460
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0x27C3
        IOR  R9, R9, 0x9BD8
        IOR  R2, R9, -38661
; EXPECT R2 = 0xFFFFFBFB
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0x599D
        IOR  R9, R9, 0xBBC4
        XOR  R11, R9, 56782
; EXPECT R11 = 0x599D660A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0xE344
        IOR  R7, R7, 0x064F
        MOV  R2, R7
; EXPECT R2 = 0xE344064F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0x5B19
        IOR  R4, R4, 0xA39D
        MOV  R11, R4
; EXPECT R11 = 0x5B19A39D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x70C8
        IOR  R6, R6, 0x9091
        XOR  R7, R6, -22596
; EXPECT R7 = 0x8F37372D
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x5732
        IOR  R2, R2, 0x551D
        MHI  R7, 0xDFEC
        IOR  R7, R7, 0x9C2D
        ADC  R3, R2, R7
; EXPECT R3 = 0x371EF14B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x756D
        IOR  R10, R10, 0xDEDF
        MHI  R3, 0x08D6
        IOR  R3, R3, 0x769A
        ANN  R2, R10, R3
; EXPECT R2 = 0x75298845
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x8B92
; EXPECT R5 = 0x8B920000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0xDB56
; EXPECT R7 = 0xDB560000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0xA838
        IOR  R9, R9, 0x3D72
        MHI  R6, 0xEEDF
        IOR  R6, R6, 0xD56C
        MUL  R4, R9, R6
; EXPECT R4 = 0x4527C618
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x05DF4B7D

        MHI  R9, 0xDF15
        IOR  R9, R9, 0x07AE
        IOR  R5, R9, -16794
; EXPECT R5 = 0xFFFFBFEE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x7D66
        IOR  R11, R11, 0x00DC
        DIV  R6, R11, 11785
; EXPECT R6 = 0x0002B956
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x000008D6

        MHI  R4, 0xD80E
        IOR  R4, R4, 0x4289
        MHI  R3, 0xFE0F
        IOR  R3, R3, 0xD01A
        LSL  R3, R4, R3
; EXPECT R3 = 0x24000000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x8DB7
        IOR  R6, R6, 0x4625
        ASR  R10, R6, 21
; EXPECT R10 = 0xFFFFFC6D
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x992D
        IOR  R10, R10, 0xE312
        LSL  R7, R10, 14
; EXPECT R7 = 0x78C48000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0xA979
        IOR  R10, R10, 0x21C4
        MHI  R5, 0xD768
        IOR  R5, R5, 0x5654
        ANN  R5, R10, R5
; EXPECT R5 = 0x28112180
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0xF1CD
        IOR  R3, R3, 0x5565
        MHI  R7, 0xBFCB
        IOR  R7, R7, 0xC7BF
        SBC  R6, R3, R7
; EXPECT R6 = 0x32018DA5
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x4D99
        IOR  R1, R1, 0x2927
        MHI  R8, 0xAB2D
        IOR  R8, R8, 0x2FE2
        ANN  R7, R1, R8
; EXPECT R7 = 0x44900005
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0xD0BB
        IOR  R7, R7, 0x552C
        MHI  R3, 0x0AF9
        IOR  R3, R3, 0xEB33
        AND  R5, R7, R3
; EXPECT R5 = 0x00B94120
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x1671
        IOR  R7, R7, 0x1D09
        AND.uv  R3, R7, -50842
; EXPECT R3 = 0x16711900
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x8D77
        IOR  R1, R1, 0x421A
        MHI  R2, 0x6F09
        IOR  R2, R2, 0x4802
        DIV  R6, R1, R2
; EXPECT R6 = 0xFFFFFFFE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x6B89D21E

        MHI  R4, 0x7773
        IOR  R4, R4, 0x4F67
        LSL  R8, R4, 28
; EXPECT R8 = 0x70000000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0xDD19
        IOR  R10, R10, 0x7A29
        MHI  R3, 0x0695
        IOR  R3, R3, 0x188C
        ADD  R9, R10, R3
; EXPECT R9 = 0xE3AE92B5
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0xB451
; EXPECT R6 = 0xB4510000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0x63BF
        IOR  R11, R11, 0xA3CE
        MUL  R9, R11, 50320
; EXPECT R9 = 0xD535DBE0
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x00004C96

        MHI  R4, 0x7BD0
        IOR  R4, R4, 0xED01
        MHI  R7, 0xE71F
        IOR  R7, R7, 0x3AD1
        AND  R7, R4, R7
; EXPECT R7 = 0x63102801
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0xB436
        IOR  R11, R11, 0x1F51
        MHI  R7, 0x30C4
        IOR  R7, R7, 0xC047
        ASR  R7, R11, R7
; EXPECT R7 = 0xFF686C3E
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0xE645
        IOR  R10, R10, 0x4B8C
        MHI  R8, 0xA82A
        IOR  R8, R8, 0xE673
        ASR  R2, R10, R8
; EXPECT R2 = 0xFFFFFCC8
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0xB694
        IOR  R9, R9, 0x322C
        SUB  R7, R9, 17222
; EXPECT R7 = 0xB693EEE6
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x547C
        IOR  R7, R7, 0x6C52
        ASR  R1, R7, 28
; EXPECT R1 = 0x00000005
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x0E8C
        IOR  R6, R6, 0x2B0B
        AND  R2, R6, 57401
; EXPECT R2 = 0x00002009
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0xC9D1
        IOR  R11, R11, 0x4697
        MHI  R7, 0x6D7C
        IOR  R7, R7, 0x09F5
        SUB  R3, R11, R7
; EXPECT R3 = 0x5C553CA2
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R11, 0x8946
        IOR  R11, R11, 0x3FFC
        MHI  R6, 0x8DC7
        IOR  R6, R6, 0xC219
        ROR  R1, R11, R6
; EXPECT R1 = 0xA31FFE44
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R11, 0x20B7
        IOR  R11, R11, 0x43A1
        MOV  R5, R11
; EXPECT R5 = 0x20B743A1
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R7, 0x0B1A
        IOR  R7, R7, 0x5E19
        LSL  R7, R7, 4
; EXPECT R7 = 0xB1A5E190
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R11, 0x0026
        IOR  R11, R11, 0xAACC
        MUL  R9, R11, 46201
; EXPECT R9 = 0x425E2A6C
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1
; EXPECT H = 0x0000001B

        MHI  R8, 0x5E68
        IOR  R8, R8, 0x0C47
        MHI  R6, 0x9FD2
        IOR  R6, R6, 0xCADE
        ADD  R7, R8, R6
; EXPECT R7 = 0xFE3AD725
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x05EA
        IOR  R10, R10, 0x97F8
        MHI  R9, 0xA489
        IOR  R9, R9, 0xCC04
        XOR  R2, R10, R9
; EXPECT R2 = 0xA1635BFC
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x8344
        IOR  R5, R5, 0x7DAE
        ROR  R7, R5, 0
; EXPECT R7 = 0x83447DAE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x0A87
        IOR  R9, R9, 0x8441
        MHI  R4, 0x5E91
        IOR  R4, R4, 0xD071
        AND  R4, R9, R4
; EXPECT R4 = 0x0A818041
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x9D6C
        IOR  R5, R5, 0x073D
        AND  R6, R5, 10354
; EXPECT R6 = 0x00000030
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R2, H
; EXPECT R2 = 0x0000001B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x0CCD
        IOR  R10, R10, 0x9C9E
        DIV  R2, R10, 59686
; EXPECT R2 = 0x00000E0E
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x0000C88A

        MHI  R8, 0xA12C
        IOR  R8, R8, 0xF8E2
        ASR  R3, R8, 19
; EXPECT R3 = 0xFFFFF425
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0x2D89
        IOR  R8, R8, 0xB69C
        IOR  R8, R8, -10953
; EXPECT R8 = 0xFFFFF7BF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x285B
        IOR  R5, R5, 0x8518
        MHI  R4, 0x9DF4
        IOR  R4, R4, 0x5AFC
        LSL  R7, R5, R4
; EXPECT R7 = 0x80000000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0x8ABA
        IOR  R11, R11, 0x07F0
        MUL  R5, R11, -55179
; EXPECT R5 = 0x705320B0
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x000062BD

        MHI  R5, 0x7231
        IOR  R5, R5, 0x24C9
        XOR  R8, R5, -13903
; EXPECT R8 = 0x8DCEED78
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x6B6C
        IOR  R5, R5, 0x1615
        MHI  R8, 0x4E9F
        IOR  R8, R8, 0xF262
        UDIV  R4, R5, R8
; EXPECT R4 = 0x00000001
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x1CCC23B3

        MHI  R1, 0x4A8B
        IOR  R1, R1, 0x5DF9
        MUL  R6, R1, -48582
; EXPECT R6 = 0x73D47C6A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0xFFFFC8BD

        MHI  R2, 0xAB6F
        IOR  R2, R2, 0x70A0
        MHI  R10, 0x48E5
        IOR  R10, R10, 0x7DD2
        XOR  R7, R2, R10
; EXPECT R7 = 0xE38A0D72
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x7463
        IOR  R1, R1, 0xA868
        MHI  R6, 0xB36D
        IOR  R6, R6, 0xAA65
        IOR  R9, R1, R6
; EXPECT R9 = 0xF76FAA6D
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0x47F2
        IOR  R11, R11, 0xD5D6
        MHI  R7, 0x24B2
        IOR  R7, R7, 0x9162
        AND  R5, R11, R7
; EXPECT R5 = 0x04B29142
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x2E2B
        IOR  R2, R2, 0x5F11
        MHI  R9, 0x257C
        IOR  R9, R9, 0x8771
        IOR  R9, R2, R9
; EXPECT R9 = 0x2F7FDF71
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x4049
        IOR  R4, R4, 0x323F
        AND.uv  R2, R4, -22460
; EXPECT R2 = 0x40492004
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0xC309
        IOR  R10, R10, 0xC1A5
        MHI  R4, 0x3EA5
        IOR  R4, R4, 0x09C2
        ROR  R9, R10, R4
; EXPECT R9 = 0x70C27069
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x9179
        IOR  R6, R6, 0x90FA
        MHI  R10, 0x1B57
        IOR  R10, R10, 0x4E0F
        ADC  R2, R6, R10
; EXPECT R2 = 0xACD0DF09
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0xA898
        IOR  R6, R6, 0xA218
        SUB  R1, R6, -59180
; EXPECT R1 = 0xA8998944
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0xF717
        IOR  R1, R1, 0x4CFD
        ANN  R5, R1, -10680
; EXPECT R5 = 0x000008B5
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x6BC9
        IOR  R6, R6, 0x8E98
        SUB  R1, R6, -17529
; EXPECT R1 = 0x6BC9D311
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0xCFD0
        IOR  R5, R5, 0x3E40
        MOV  R8, R5
; EXPECT R8 = 0xCFD03E40
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0xAD2B
        IOR  R2, R2, 0x27F5
        ROR  R8, R2, 17
; EXPECT R8 = 0x93FAD695
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0xAEDC
        IOR  R6, R6, 0x2419
        MHI  R9, 0x6243
        IOR  R9, R9, 0xFAF0
        DIV  R1, R6, R9
; EXPECT R1 = 0xFFFFFFFF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x11201F09

        MHI  R5, 0x67F7
        IOR  R5, R5, 0x2557
        ADC  R10, R5, 1441
; EXPECT R10 = 0x67F72AF9
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x36FA
        IOR  R10, R10, 0x2261
        ADC  R4, R10, 4490
; EXPECT R4 = 0x36FA33EB
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x8842
        IOR  R7, R7, 0x47D8
        MHI  R2, 0xCB5C
        IOR  R2, R2, 0xAA46
        ADD  R4, R7, R2
; EXPECT R4 = 0x539EF21E
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R7, 0x2A8A
        IOR  R7, R7, 0x84EC
        MHI  R4, 0xB69B
        IOR  R4, R4, 0x2F0E
        UMUL  R8, R7, R4
; EXPECT R8 = 0x04DE98E8
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1
; EXPECT H = 0xF3CDBF44

        MHI  R7, 0xCD87
        IOR  R7, R7, 0x789D
        MHI  R10, 0xA217
        IOR  R10, R10, 0x6203
        AND  R7, R7, R10
; EXPECT R7 = 0x80076001
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R7, 0x6B65
        IOR  R7, R7, 0x5990
        MHI  R6, 0xE19A
        IOR  R6, R6, 0x2154
        ADD  R7, R7, R6
; EXPECT R7 = 0x4CFF7AE4
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R2, 55045
; EXPECT R2 = 0x0000D705
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0xB76A
        IOR  R2, R2, 0xD707
        MHI  R3, 0x9C42
        IOR  R3, R3, 0xFC2E
        UMUL  R3, R2, R3
; EXPECT R3 = 0xD4AB8742
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xB88A423A

        MHI  R8, 0xD8AB
        IOR  R8, R8, 0x4EF1
        SBC  R8, R8, 43581
; EXPECT R8 = 0xD8AAA4B3
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0xB48B
        IOR  R5, R5, 0x7B39
        MHI  R11, 0x77EF
        IOR  R11, R11, 0xDE80
        SUB  R4, R5, R11
; EXPECT R4 = 0x3C9B9CB9
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R7, 0x711F
        IOR  R7, R7, 0x9D48
        MHI  R5, 0x74C5
        IOR  R5, R5, 0xAF08
        ADC  R5, R7, R5
; EXPECT R5 = 0xE5E54C50
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R8, 0x0205
        IOR  R8, R8, 0xF65D
        MHI  R9, 0xEEEB
        IOR  R9, R9, 0x2BD5
        SBC  R9, R8, R9
; EXPECT R9 = 0x131ACA88
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x326A
        IOR  R6, R6, 0xF792
        MHI  R8, 0x2158
        IOR  R8, R8, 0x5144
        ROR  R2, R6, R8
; EXPECT R2 = 0x2326AF79
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0xA69C
        IOR  R11, R11, 0xC6A2
        DIV  R2, R11, 53482
; EXPECT R2 = 0xFFFF9277
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x000035DC

        MHI  R3, 0x356E
        IOR  R3, R3, 0xCBC9
        ASR  R11, R3, 4
; EXPECT R11 = 0x0356ECBC
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0xCA11
        IOR  R6, R6, 0xB6AE
        MHI  R7, 0xEC79
        IOR  R7, R7, 0xF472
        AND  R5, R6, R7
; EXPECT R5 = 0xC811B422
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x2E33
        IOR  R7, R7, 0xCBDF
        MHI  R9, 0x377B
        IOR  R9, R9, 0xD466
        DIV  R6, R7, R9
; EXPECT R6 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x2E33CBDF

        MHI  R4, 0x7E43
        IOR  R4, R4, 0x75C5
        SUB  R10, R4, 38028
; EXPECT R10 = 0x7E42E139
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x8FAC
        IOR  R1, R1, 0x8909
        IOR  R3, R1, -50805
; EXPECT R3 = 0xFFFFB98B
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R9, NZCV
; EXPECT R9 = 0x80000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0xB114
        IOR  R5, R5, 0x5B8F
        MHI  R2, 0x3B2B
        IOR  R2, R2, 0xE11D
        DIV  R9, R5, R2
; EXPECT R9 = 0xFFFFFFFE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x276C1DC9

        MHI  R3, 0x4309
        IOR  R3, R3, 0x462B
        SUB  R6, R3, 2899
; EXPECT R6 = 0x43093AD8
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x6460
        IOR  R10, R10, 0x6F8D
        IOR  R1, R10, -30406
; EXPECT R1 = 0xFFFFEFBF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0x45A8
        IOR  R11, R11, 0xCC48
        MHI  R7, 0x36F1
        IOR  R7, R7, 0x47EE
        MUL  R8, R11, R7
; EXPECT R8 = 0x135DE2F0
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x0EF34292

        MHI  R10, 0xD15F
        IOR  R10, R10, 0xF759
        MHI  R7, 0x5268
        IOR  R7, R7, 0xF0AC
        IOR  R6, R10, R7
; EXPECT R6 = 0xD37FF7FD
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R1, H
; EXPECT R1 = 0x0EF34292
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x0483
        IOR  R1, R1, 0x909C
        MHI  R8, 0x04D4
        IOR  R8, R8, 0xC0DD
        UMUL  R2, R1, R8
; EXPECT R2 = 0xC338D6AC
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x0015CE9C

        MOV  R3, 7892
; EXPECT R3 = 0x00001ED4
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0xB796
        IOR  R3, R3, 0x6F9B
        ADC  R6, R3, 36385
; EXPECT R6 = 0xB796FDBC
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x56AC
; EXPECT R2 = 0x56AC0000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R1, 16445
; EXPECT R1 = 0x0000403D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0xABFC
        IOR  R9, R9, 0x7EB4
        LSL  R4, R9, 9
; EXPECT R4 = 0xF8FD6800
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0xCA01
        IOR  R5, R5, 0xF6F0
        MHI  R1, 0x0C72
        IOR  R1, R1, 0xC287
        ADC  R4, R5, R1
; EXPECT R4 = 0xD674B977
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0xF9FD
        IOR  R11, R11, 0xF1EF
        MHI  R1, 0x0E02
        IOR  R1, R1, 0xE61F
        IOR  R9, R11, R1
; EXPECT R9 = 0xFFFFF7FF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x4FD6
        IOR  R3, R3, 0x86ED
        MHI  R5, 0x9B2B
        IOR  R5, R5, 0x91B0
        ROR  R7, R3, R5
; EXPECT R7 = 0x86ED4FD6
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0xE77E
        IOR  R11, R11, 0x14A0
        MOV  R7, R11
; EXPECT R7 = 0xE77E14A0
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x9F5C
        IOR  R4, R4, 0x0CAA
        AND  R11, R4, -5335
; EXPECT R11 = 0x9F5C0828
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R8, 19287
; EXPECT R8 = 0x00004B57
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0xA38F
        IOR  R5, R5, 0x9F48
        MHI  R11, 0x75F2
        IOR  R11, R11, 0x6525
        UMUL  R6, R5, R11
; EXPECT R6 = 0xC7A96D68
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x4B5B822F

        MOV  R11, NZCV
; EXPECT R11 = 0x80000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x1C90
        IOR  R1, R1, 0x0A28
        ASR  R1, R1, 26
; EXPECT R1 = 0x00000007
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0xC9F7
        IOR  R1, R1, 0x0D20
        IOR  R11, R1, 20111
; EXPECT R11 = 0xC9F74FAF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x937F
        IOR  R10, R10, 0xF0BD
        AND  R3, R10, -49638
; EXPECT R3 = 0x937F3018
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x5499
        IOR  R2, R2, 0xE672
        ADD  R1, R2, 50973
; EXPECT R1 = 0x549AAD8F
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x1941
        IOR  R7, R7, 0x6DB5
        MHI  R2, 0x2C27
        IOR  R2, R2, 0xA6CE
        UDIV  R3, R7, R2
; EXPECT R3 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x19416DB5

        MHI  R6, 0x37BA
        IOR  R6, R6, 0xB436
        MHI  R7, 0x2271
        IOR  R7, R7, 0x891A
        SUB  R4, R6, R7
; EXPECT R4 = 0x15492B1C
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x8806
        IOR  R4, R4, 0x6F04
        MOV  R10, R4
; EXPECT R10 = 0x88066F04
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x7E34
        IOR  R7, R7, 0xEA30
        SUB.uv  R6, R7, -49269
; EXPECT R6 = 0x7E35AAA5
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0xF009
        IOR  R4, R4, 0x1B66
        LSL  R6, R4, 20
; EXPECT R6 = 0xB6600000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x341A
        IOR  R6, R6, 0xF4B5
        ADD.uv  R7, R6, -36315
; EXPECT R7 = 0x341A66DB
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0xDED9
        IOR  R1, R1, 0x7B13
        MOV  R2, R1
; EXPECT R2 = 0xDED97B13
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x4641
        IOR  R3, R3, 0x26DC
        MHI  R2, 0xB473
        IOR  R2, R2, 0x8A12
        IOR  R5, R3, R2
; EXPECT R5 = 0xF673AEDE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0xE5B0
        IOR  R2, R2, 0x47C0
        MHI  R4, 0x053B
        IOR  R4, R4, 0xAB15
        SBC  R10, R2, R4
; EXPECT R10 = 0xE0749CAA
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x4F1D
        IOR  R9, R9, 0x51CC
        AND.uv  R1, R9, -40913
; EXPECT R1 = 0x4F1D400C
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x0DF3
        IOR  R1, R1, 0x9BC1
        ADC  R10, R1, 23385
; EXPECT R10 = 0x0DF3F71A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x9957
        IOR  R3, R3, 0x6FFD
        ANN  R7, R3, 50251
; EXPECT R7 = 0x99572BB4
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R7, NZCV
; EXPECT R7 = 0x80000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0xEFC9
; EXPECT R1 = 0xEFC90000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x1BAD
        IOR  R6, R6, 0x96AB
        MHI  R2, 0xD467
        IOR  R2, R2, 0x1B3C
        ANN  R10, R6, R2
; EXPECT R10 = 0x0B888483
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0xF8A5
        IOR  R4, R4, 0x3839
        IOR  R4, R4, -36545
; EXPECT R4 = 0xFFFF793F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x423F
        IOR  R5, R5, 0x342F
        LSL  R4, R5, 7
; EXPECT R4 = 0x1F9A1780
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x56B3
        IOR  R6, R6, 0xEE6C
        MUL  R4, R6, -30682
; EXPECT R4 = 0x86F2C408
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0xFFFFD768

        MHI  R8, 0x0F5E
        IOR  R8, R8, 0xD564
        MHI  R3, 0x0924
        IOR  R3, R3, 0x4CBA
        UDIV  R10, R8, R3
; EXPECT R10 = 0x00000001
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x063A88AA

        MHI  R6, 0x66D5
        IOR  R6, R6, 0xA7AF
        ASR  R11, R6, 10
; EXPECT R11 = 0x0019B569
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x68A0
        IOR  R2, R2, 0x2978
        MHI  R7, 0x5F07
        IOR  R7, R7, 0x2BFB
        SBC  R11, R2, R7
; EXPECT R11 = 0x0998FD7D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0xF1C8
        IOR  R3, R3, 0x863A
        MHI  R7, 0x9E47
        IOR  R7, R7, 0x5C19
        LSL  R2, R3, R7
; EXPECT R2 = 0x74000000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0xFE65
        IOR  R3, R3, 0x82AD
        MUL  R3, R3, 14172
; EXPECT R3 = 0x3B8E212C
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0xFFFFFFA7

        MHI  R1, 0x8415
        IOR  R1, R1, 0xCD2B
        SBC  R5, R1, 57014
; EXPECT R5 = 0x8414EE75
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x66A3
        IOR  R6, R6, 0x7A03
        LSL  R5, R6, 2
; EXPECT R5 = 0x9A8DE80C
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x8BD5
        IOR  R4, R4, 0x9CC5
        MHI  R11, 0x4D42
        IOR  R11, R11, 0xDCAA
        XOR  R6, R4, R11
; EXPECT R6 = 0xC697406F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0xCA25
        IOR  R3, R3, 0x2CC3
        MOV  R8, R3
; EXPECT R8 = 0xCA252CC3
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x4C51
        IOR  R4, R4, 0xC0EE
        MHI  R8, 0x5F62
        IOR  R8, R8, 0x6AD2
        DIV  R6, R4, R8
; EXPECT R6 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x4C51C0EE

        MHI  R3, 0x2FBF
        IOR  R3, R3, 0x5924
        ROR  R9, R3, 16
; EXPECT R9 = 0x59242FBF
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0xAE8A
        IOR  R11, R11, 0x4F18
        MHI  R2, 0xF626
        IOR  R2, R2, 0x74DF
        MUL  R4, R11, R2
; EXPECT R4 = 0x83E1C5E8
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x03225C40

        MHI  R3, 0x17A9
        IOR  R3, R3, 0x895F
        MOV  R8, R3
; EXPECT R8 = 0x17A9895F
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x0652
        IOR  R3, R3, 0xB741
        ADC  R9, R3, 37122
; EXPECT R9 = 0x06534843
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0xA62E
        IOR  R3, R3, 0xD014
        MHI  R4, 0x2B43
        IOR  R4, R4, 0xBD87
        IOR  R3, R3, R4
; EXPECT R3 = 0xAF6FFD97
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0xB8CC
        IOR  R8, R8, 0xCC62
        MHI  R5, 0x35A8
        IOR  R5, R5, 0xCC38
        MUL  R6, R8, R5
; EXPECT R6 = 0x09FACD70
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0xF11373EA

        MHI  R9, 0xCE86
        IOR  R9, R9, 0xDE35
        DIV  R3, R9, 41957
; EXPECT R3 = 0xFFFFB2B9
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x000033B8

        MHI  R6, 0x4363
        IOR  R6, R6, 0xED11
        MHI  R11, 0xD355
        IOR  R11, R11, 0xFFA9
        SBC  R5, R6, R11
; EXPECT R5 = 0x700DED68
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0xD365
        IOR  R7, R7, 0xBEBF
        MHI  R4, 0x19DB
        IOR  R4, R4, 0xED0D
        MUL  R11, R7, R4
; EXPECT R11 = 0xC22682B3
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xFB7E9E5D

        MHI  R3, 0x446F
        IOR  R3, R3, 0xCE89
        IOR  R6, R3, 41240
; EXPECT R6 = 0x446FEF99
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x8953
        IOR  R5, R5, 0x2AF3
        MOV  R10, R5
; EXPECT R10 = 0x89532AF3
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x32EC
        IOR  R6, R6, 0x6802
        MHI  R7, 0xE127
        IOR  R7, R7, 0xD420
        ANN  R7, R6, R7
; EXPECT R7 = 0x12C82802
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0x2AC8
        IOR  R4, R4, 0xC418
        SUB  R3, R4, -52513
; EXPECT R3 = 0x2AC99139
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R5, NZCV
; EXPECT R5 = 0x20000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x6C65
        IOR  R11, R11, 0x0395
        SUB.uv  R11, R11, -28812
; EXPECT R11 = 0x6C657420
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x34CD
        IOR  R3, R3, 0xDF90
        MOV  R3, R3
; EXPECT R3 = 0x34CDDF90
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0xD163
        IOR  R4, R4, 0x8318
        XOR  R9, R4, 4428
; EXPECT R9 = 0xD1639254
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x37DC
        IOR  R11, R11, 0x629E
        AND  R4, R11, -15178
; EXPECT R4 = 0x37DC4096
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0xDE91
        IOR  R10, R10, 0xB8BA
        MHI  R8, 0xDE21
        IOR  R8, R8, 0x47B6
        MUL  R6, R10, R8
; EXPECT R6 = 0xC1CEEA3C
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x046C4CE2

        MHI  R9, 0xD96D
        IOR  R9, R9, 0xBC00
        SUB.uv  R10, R9, -752
; EXPECT R10 = 0xD96DBEEF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x9051
        IOR  R11, R11, 0xA103
        MHI  R9, 0xBB6A
        IOR  R9, R9, 0xDD04
        SBC  R2, R11, R9
; EXPECT R2 = 0xD4E6C3FE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R3, 49946
; EXPECT R3 = 0x0000C31A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x15D5
        IOR  R6, R6, 0x5096
        SBC  R5, R6, 24600
; EXPECT R5 = 0x15D4F07D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x8AB7
        IOR  R5, R5, 0xE36C
        MOV  R11, R5
; EXPECT R11 = 0x8AB7E36C
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0xEE87
        IOR  R3, R3, 0x7A7D
        AND  R1, R3, -51013
; EXPECT R1 = 0xEE873839
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x1F97
        IOR  R1, R1, 0x6B87
        SBC  R10, R1, 8272
; EXPECT R10 = 0x1F974B37
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0xB356
        IOR  R8, R8, 0xECC9
        MUL  R11, R8, -49531
; EXPECT R11 = 0x4CB8B26D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x000039F0

        MHI  R1, 0xD066
        IOR  R1, R1, 0xB2AA
        AND.uv  R6, R1, -37634
; EXPECT R6 = 0xD06620AA
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0xC909
        IOR  R7, R7, 0x55F0
        SUB.uv  R9, R7, -40835
; EXPECT R9 = 0xC909F573
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R9, H
; EXPECT R9 = 0x000039F0
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x0ADF
        IOR  R6, R6, 0x1B6F
        DIV  R6, R6, 16985
; EXPECT R6 = 0x000029F2
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x0000224D

        MOV  R2, NZCV
; EXPECT R2 = 0x20000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0xBAE6
        IOR  R11, R11, 0x6A87
        XOR  R11, R11, 9752
; EXPECT R11 = 0xBAE64C9F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x34B8
        IOR  R6, R6, 0x7979
        MHI  R4, 0xDAEE
        IOR  R4, R4, 0x352F
        MUL  R5, R6, R4
; EXPECT R5 = 0xD7825A37
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xF85DAC6C

        MHI  R5, 0x8BC8
        IOR  R5, R5, 0x493D
        ANN  R10, R5, -58855
; EXPECT R10 = 0x00004124
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R4, -37595
; EXPECT R4 = 0xFFFF6D25
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0xD84C
        IOR  R4, R4, 0x0EAF
        ASR  R3, R4, 30
; EXPECT R3 = 0xFFFFFFFF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0x2DA9
        IOR  R1, R1, 0xBDDA
        LSL  R11, R1, 7
; EXPECT R11 = 0xD4DEED00
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x2BF9
        IOR  R6, R6, 0xACF2
        ASR  R8, R6, 5
; EXPECT R8 = 0x015FCD67
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0xBF22
        IOR  R11, R11, 0x6AF6
        MHI  R5, 0x9EF0
        IOR  R5, R5, 0x19BE
        ADD  R5, R11, R5
; EXPECT R5 = 0x5E1284B4
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R9, 0x5489
        IOR  R9, R9, 0xEAD4
        MHI  R2, 0xCCB3
        IOR  R2, R2, 0x6140
        LSL  R1, R9, R2
; EXPECT R1 = 0x5489EAD4
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R9, 0xF32C
        IOR  R9, R9, 0xA33E
        MHI  R5, 0xAB1E
        IOR  R5, R5, 0x55CB
        UMUL  R2, R9, R5
; EXPECT R2 = 0x31DD082A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1
; EXPECT H = 0xAF5EFE86

        MHI  R5, 0x7E0C
        IOR  R5, R5, 0x1DBF
        SUB  R9, R5, -58426
; EXPECT R9 = 0x7E0D01F9
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x748C
        IOR  R7, R7, 0x3DCF
        ADD.uv  R11, R7, -26940
; EXPECT R11 = 0x748BD494
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0x5233
        IOR  R4, R4, 0xB722
        MHI  R5, 0xAE81
        IOR  R5, R5, 0x430D
        ASR  R7, R4, R5
; EXPECT R7 = 0x0002919D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x1118
        IOR  R10, R10, 0x809C
        MHI  R7, 0x5949
        IOR  R7, R7, 0x6AC9
        UMUL  R9, R10, R7
; EXPECT R9 = 0x79F9927C
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x05F66BD4

        MHI  R10, 0x4479
        IOR  R10, R10, 0x9327
        MHI  R1, 0x0CEB
        IOR  R1, R1, 0xDE3B
        UDIV  R7, R10, R1
; EXPECT R7 = 0x00000005
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x03DE3C00

        MHI  R9, 0xFAD6
        IOR  R9, R9, 0xC4C7
        AND.uv  R2, R9, -53163
; EXPECT R2 = 0xFAD60045
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0xEB88
        IOR  R1, R1, 0x9F18
        ADD  R11, R1, -47619
; EXPECT R11 = 0xEB87E515
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0xCABF
        IOR  R11, R11, 0x27EC
        MHI  R7, 0x09BF
        IOR  R7, R7, 0x2056
        ADD  R6, R11, R7
; EXPECT R6 = 0xD47E4842
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x22B9
        IOR  R9, R9, 0x5AA8
        SBC  R10, R9, 45991
; EXPECT R10 = 0x22B8A701
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x9F37
; EXPECT R10 = 0x9F370000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x9FBC
        IOR  R1, R1, 0x699A
        MHI  R3, 0xEB27
        IOR  R3, R3, 0xF67D
        ASR  R11, R1, R3
; EXPECT R11 = 0xFFFFFFFC
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R2, 40878
; EXPECT R2 = 0x00009FAE
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0xDB34
        IOR  R5, R5, 0x8895
        IOR  R1, R5, -17895
; EXPECT R1 = 0xFFFFBA9D
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x93F6
        IOR  R5, R5, 0x6458
        MHI  R7, 0xDA71
        IOR  R7, R7, 0x4F97
        ROR  R2, R5, R7
; EXPECT R2 = 0xECC8B127
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x8CB7
        IOR  R6, R6, 0xA38A
        ANN  R4, R6, 36069
; EXPECT R4 = 0x8CB7230A
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x475E
        IOR  R10, R10, 0xCD50
        SUB  R7, R10, 19005
; EXPECT R7 = 0x475E8313
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0xDC1C
        IOR  R9, R9, 0x7CDD
        SUB  R1, R9, 5705
; EXPECT R1 = 0xDC1C6694
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R5, H
; EXPECT R5 = 0x03DE3C00
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R2, -37007
; EXPECT R2 = 0xFFFF6F71
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x3E6D
        IOR  R3, R3, 0x3E4B
        ROR  R1, R3, 14
; EXPECT R1 = 0xF92CF9B4
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0xEB7C
        IOR  R3, R3, 0x8C54
        MHI  R8, 0x588C
        IOR  R8, R8, 0x25BD
        SBC  R1, R3, R8
; EXPECT R1 = 0x92F06697
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x8775
        IOR  R9, R9, 0xD9EF
        MHI  R8, 0xBBEB
        IOR  R8, R8, 0xEC8B
        AND  R11, R9, R8
; EXPECT R11 = 0x8361C88B
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x2BAF
        IOR  R3, R3, 0xF464
        DIV  R2, R3, 15776
; EXPECT R2 = 0x0000B57B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x00003884

        MHI  R6, 0x8F1F
        IOR  R6, R6, 0x8815
        LSL  R6, R6, 4
; EXPECT R6 = 0xF1F88150
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0x8970
        IOR  R11, R11, 0x2ECE
        MHI  R4, 0xDFB0
        IOR  R4, R4, 0xE727
        IOR  R3, R11, R4
; EXPECT R3 = 0xDFF0EFEF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0xA7AF
        IOR  R2, R2, 0xEBB8
        MHI  R6, 0x3DF0
        IOR  R6, R6, 0xDDC6
        DIV  R8, R2, R6
; EXPECT R8 = 0xFFFFFFFE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x2391A744

        MHI  R10, 0xF5F3
        IOR  R10, R10, 0x9600
        AND.uv  R4, R10, -32966
; EXPECT R4 = 0xF5F31600
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x0CB4
        IOR  R2, R2, 0xC037
        LSL  R11, R2, 9
; EXPECT R11 = 0x69806E00
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0x1BFF
        IOR  R1, R1, 0x6266
        LSL  R11, R1, 17
; EXPECT R11 = 0xC4CC0000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0x0756
        IOR  R8, R8, 0x926E
        ADC  R11, R8, 48485
; EXPECT R11 = 0x07574FD3
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0xC2F8
        IOR  R1, R1, 0x224B
        DIV  R11, R1, 31095
; EXPECT R11 = 0xFFFF7F5F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x00000622

        MHI  R6, 0x5E2F
        IOR  R6, R6, 0xCA61
        AND  R10, R6, 20570
; EXPECT R10 = 0x00004040
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0xDA7E
        IOR  R1, R1, 0x05E4
        DIV  R9, R1, 50169
; EXPECT R9 = 0xFFFFCF00
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x0000AEE4

        MHI  R11, 0x0C27
        IOR  R11, R11, 0x95DA
        MHI  R3, 0x0421
        IOR  R3, R3, 0xACC8
        DIV  R4, R11, R3
; EXPECT R4 = 0x00000002
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x03E43C4A

        MHI  R5, 0x5254
        IOR  R5, R5, 0x7A65
        DIV  R9, R5, 47250
; EXPECT R9 = 0x00007231
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x00002273

        MOV  R5, H
; EXPECT R5 = 0x00002273
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0xD9F1
        IOR  R7, R7, 0xA41A
        MHI  R4, 0x5083
        IOR  R4, R4, 0x6B82
        ANN  R1, R7, R4
; EXPECT R1 = 0x89708418
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0x9B20
        IOR  R10, R10, 0xCBF6
        AND.uv  R2, R10, -7571
; EXPECT R2 = 0x9B20C264
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0xEBE9
        IOR  R7, R7, 0xF101
        MHI  R6, 0x2DBB
        IOR  R6, R6, 0xA0B5
        DIV  R3, R7, R6
; EXPECT R3 = 0xFFFFFFFF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x19A591B6

        MHI  R5, 0xCB91
        IOR  R5, R5, 0x93CC
        MOV  R6, R5
; EXPECT R6 = 0xCB9193CC
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x3A13
        IOR  R4, R4, 0x335E
        MHI  R9, 0xD288
        IOR  R9, R9, 0xBBA2
        LSL  R2, R4, R9
; EXPECT R2 = 0xE84CCD78
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x1BC8
        IOR  R7, R7, 0xB3EA
        MHI  R2, 0xE784
        IOR  R2, R2, 0xC833
        ADC  R11, R7, R2
; EXPECT R11 = 0x034D7C1D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0xCF03
        IOR  R9, R9, 0x611F
        MHI  R11, 0x7C63
        IOR  R11, R11, 0xCE9F
        MUL  R3, R9, R11
; EXPECT R3 = 0xDE3D4441
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xE83289CF

        MHI  R11, 0x17E8
        IOR  R11, R11, 0x8748
        MHI  R2, 0x9752
        IOR  R2, R2, 0x1B22
        IOR  R11, R11, R2
; EXPECT R11 = 0x97FA9F6A
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x88FC
        IOR  R7, R7, 0xECA0
        MHI  R6, 0x1DDF
        IOR  R6, R6, 0x805C
        DIV  R8, R7, R6
; EXPECT R8 = 0xFFFFFFFC
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x007AEE10

        MOV  R6, -56773
; EXPECT R6 = 0xFFFF223B
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x662E
        IOR  R2, R2, 0xBE60
        MUL  R2, R2, -19515
; EXPECT R2 = 0x92B59FE0
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xFFFFE192

        MOV  R5, 30715
; EXPECT R5 = 0x000077FB
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0xC2E4
        IOR  R8, R8, 0x450D
        MHI  R2, 0x024A
        IOR  R2, R2, 0x6ED4
        ROR  R7, R8, R2
; EXPECT R7 = 0x4450DC2E
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x53BB
        IOR  R6, R6, 0x380F
        SUB  R11, R6, -58512
; EXPECT R11 = 0x53BC1C9F
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x1FB7
        IOR  R3, R3, 0xD6D0
        MHI  R6, 0x45EC
        IOR  R6, R6, 0xAB77
        LSL  R10, R3, R6
; EXPECT R10 = 0x68000000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x427D
        IOR  R5, R5, 0x11B5
        MHI  R9, 0xB5AB
        IOR  R9, R9, 0x2ABD
        ASR  R6, R5, R9
; EXPECT R6 = 0x00000002
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0xF249
        IOR  R10, R10, 0xFE4E
        MHI  R11, 0xED8A
        IOR  R11, R11, 0x85F9
        AND  R2, R10, R11
; EXPECT R2 = 0xE0088448
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0x840D
        IOR  R8, R8, 0xA5B5
        MHI  R10, 0xB285
        IOR  R10, R10, 0xC31C
        IOR  R8, R8, R10
; EXPECT R8 = 0xB68DE7BD
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0x0FFC
        IOR  R1, R1, 0x9F83
        ASR  R9, R1, 10
; EXPECT R9 = 0x0003FF27
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0x2488
        IOR  R9, R9, 0x2FA2
        MHI  R5, 0x5264
        IOR  R5, R5, 0x957E
        DIV  R6, R9, R5
; EXPECT R6 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x24882FA2

        MHI  R8, 0xBE8E
        IOR  R8, R8, 0xB3CC
        SUB.uv  R9, R8, -38908
; EXPECT R9 = 0xBE8F4BC7
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x4332
        IOR  R10, R10, 0x74B5
        MHI  R1, 0x24D8
        IOR  R1, R1, 0xCE27
        XOR  R3, R10, R1
; EXPECT R3 = 0x67EABA92
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0xA70C
        IOR  R6, R6, 0xCA64
        MHI  R4, 0x52B8
        IOR  R4, R4, 0x419E
        UDIV  R10, R6, R4
; EXPECT R10 = 0x00000002
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x019C4728

        MHI  R4, 0x11BE
        IOR  R4, R4, 0x7BB8
        MHI  R8, 0x2986
        IOR  R8, R8, 0x0045
        ASR  R10, R4, R8
; EXPECT R10 = 0x008DF3DD
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0x54FA
        IOR  R9, R9, 0xA6A7
        MHI  R2, 0xE89E
        IOR  R2, R2, 0x5DBA
        ADC  R9, R9, R2
; EXPECT R9 = 0x3D990462
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0xC343
        IOR  R6, R6, 0x9B6F
        MHI  R4, 0xFC2E
        IOR  R4, R4, 0xBE6F
        ANN  R10, R6, R4
; EXPECT R10 = 0x03410100
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0xE66D
        IOR  R4, R4, 0xCBF0
        SUB.uv  R5, R4, -17534
; EXPECT R5 = 0xE66E106D
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0xAA43
        IOR  R11, R11, 0x637D
        MOV  R8, R11
; EXPECT R8 = 0xAA43637D
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x77FE
        IOR  R3, R3, 0x8818
        MHI  R6, 0x2131
        IOR  R6, R6, 0xF5C5
        DIV  R10, R3, R6
; EXPECT R10 = 0x00000003
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x1468A6C9

        MHI  R8, 0xCEAC
        IOR  R8, R8, 0x8815
        AND  R5, R8, -8045
; EXPECT R5 = 0xCEAC8011
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0xB323
        IOR  R9, R9, 0x8C87
        MHI  R8, 0xC498
        IOR  R8, R8, 0x19A7
        IOR  R11, R9, R8
; EXPECT R11 = 0xF7BB9DA7
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x8F37
        IOR  R2, R2, 0xBD62
        MHI  R11, 0x3BD9
        IOR  R11, R11, 0x9FB7
        SBC  R10, R2, R11
; EXPECT R10 = 0x535E1DAA
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R10, 0x423C
        IOR  R10, R10, 0xBADA
        XOR  R2, R10, 34336
; EXPECT R2 = 0x423C3CFA
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R10, 0x23D0
        IOR  R10, R10, 0x2ACE
        MUL  R10, R10, 62879
; EXPECT R10 = 0x7741BBF2
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1
; EXPECT H = 0x0000225C

        MHI  R8, 0x7321
        IOR  R8, R8, 0x3A4F
        SUB.uv  R10, R8, -23732
; EXPECT R10 = 0x73219703
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0xE937
; EXPECT R7 = 0xE9370000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x2957
        IOR  R2, R2, 0x389E
        MHI  R11, 0x354F
        IOR  R11, R11, 0xA7E5
        UMUL  R7, R2, R11
; EXPECT R7 = 0x0FB6B756
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x089BEBC0

        MOV  R5, -15825
; EXPECT R5 = 0xFFFFC22F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x2244
        IOR  R5, R5, 0x12D4
        MHI  R4, 0x335F
        IOR  R4, R4, 0x6E86
        AND  R5, R5, R4
; EXPECT R5 = 0x22440284
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R3, H
; EXPECT R3 = 0x089BEBC0
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x21A5
        IOR  R7, R7, 0xE089
        MUL  R5, R7, 6440
; EXPECT R5 = 0x74D87668
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x0000034E

        MHI  R9, 0xD7FD
        IOR  R9, R9, 0x1867
        MHI  R8, 0x85DF
        IOR  R8, R8, 0xC765
        UMUL  R1, R9, R8
; EXPECT R1 = 0xB98BB1A3
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x98F632F9

        MHI  R3, 0x47C5
        IOR  R3, R3, 0x641D
        ADD  R8, R3, 42198
; EXPECT R8 = 0x47C608F3
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0xCC1E
        IOR  R2, R2, 0x066A
        MHI  R10, 0x6EDF
        IOR  R10, R10, 0xAAB1
        ASR  R10, R2, R10
; EXPECT R10 = 0xFFFFE60F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x534A
        IOR  R9, R9, 0x9302
        XOR  R5, R9, -55894
; EXPECT R5 = 0xACB5B6A8
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0xE754
        IOR  R2, R2, 0x3A58
        MHI  R6, 0x2417
        IOR  R6, R6, 0x1287
        UDIV  R2, R2, R6
; EXPECT R2 = 0x00000006
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x0EC9CB2E

        MHI  R10, 0x5EED
        IOR  R10, R10, 0x1E5A
        ASR  R3, R10, 19
; EXPECT R3 = 0x00000BDD
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x4504
        IOR  R5, R5, 0x76B4
        MUL  R10, R5, -53174
; EXPECT R10 = 0x52D81008
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0xFFFFC800

        MHI  R4, 0x8ED2
        IOR  R4, R4, 0xFDC1
        AND  R3, R4, -18457
; EXPECT R3 = 0x8ED2B5C1
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0xBA61
        IOR  R8, R8, 0x3960
        MHI  R5, 0x6758
        IOR  R5, R5, 0xFC0B
        LSL  R10, R8, R5
; EXPECT R10 = 0x09CB0000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0x129F
        IOR  R8, R8, 0xBAA0
        MHI  R6, 0xA91A
        IOR  R6, R6, 0x0462
        XOR  R8, R8, R6
; EXPECT R8 = 0xBB85BEC2
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R11, -49070
; EXPECT R11 = 0xFFFF4052
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0xFB8B
        IOR  R7, R7, 0x4500
        ASR  R11, R7, 16
; EXPECT R11 = 0xFFFFFB8B
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0x2E8A
        IOR  R8, R8, 0xAEDE
        MHI  R2, 0x7793
        IOR  R2, R2, 0x5F92
        SBC  R7, R8, R2
; EXPECT R7 = 0xB6F74F4C
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0xD626
        IOR  R4, R4, 0xD634
        MHI  R6, 0x9D35
        IOR  R6, R6, 0x4673
        AND  R11, R4, R6
; EXPECT R11 = 0x94244630
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0xC45F
        IOR  R4, R4, 0xD100
        MHI  R3, 0x7444
        IOR  R3, R3, 0x881C
        UMUL  R1, R4, R3
; EXPECT R1 = 0xE582DC00
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x592FFC8F

        MHI  R8, 0x4848
        IOR  R8, R8, 0x3246
        DIV  R7, R8, 42188
; EXPECT R7 = 0x00007048
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x000098E6

        MHI  R4, 0x3BB4
        IOR  R4, R4, 0x41F4
        ANN  R6, R4, 17981
; EXPECT R6 = 0x3BB401C0
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0x5CC8
        IOR  R1, R1, 0xCDB8
        ADC  R6, R1, 57599
; EXPECT R6 = 0x5CC9AEB8
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R10, NZCV
; EXPECT R10 = 0x00000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x585F
        IOR  R6, R6, 0xFBA5
        ADD  R3, R6, 57575
; EXPECT R3 = 0x5860DC8C
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0xDCD4
        IOR  R2, R2, 0x53F3
        XOR  R3, R2, 32993
; EXPECT R3 = 0xDCD4D312
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x9BFB
        IOR  R5, R5, 0xA659
        MHI  R4, 0x3551
        IOR  R4, R4, 0x19A4
        IOR  R11, R5, R4
; EXPECT R11 = 0xBFFBBFFD
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x1E8C
        IOR  R3, R3, 0x84C5
        SBC  R8, R3, 48808
; EXPECT R8 = 0x1E8BC61D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0xF22A
; EXPECT R4 = 0xF22A0000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x69FF
        IOR  R6, R6, 0x86EF
        MHI  R5, 0x1F14
        IOR  R5, R5, 0xE246
        ASR  R6, R6, R5
; EXPECT R6 = 0x01A7FE1B
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0xB970
        IOR  R8, R8, 0x8B03
        SBC  R4, R8, 40418
; EXPECT R4 = 0xB96FED21
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R1, H
; EXPECT R1 = 0x000098E6
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x1D68
        IOR  R6, R6, 0x3C5A
        XOR  R5, R6, -35758
; EXPECT R5 = 0xE2974808
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x15BB
        IOR  R9, R9, 0x8EEB
        SUB  R2, R9, 17391
; EXPECT R2 = 0x15BB4AFC
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0xAE5A
        IOR  R6, R6, 0x1844
        DIV  R2, R6, 25303
; EXPECT R2 = 0xFFFF2C87
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x000004E3

        MHI  R1, 0x39FC
        IOR  R1, R1, 0xCE8D
        MHI  R11, 0x5D28
        IOR  R11, R11, 0xFE6A
        DIV  R9, R1, R11
; EXPECT R9 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x39FCCE8D

        MHI  R5, 0x93A7
        IOR  R5, R5, 0x9CD9
        MHI  R4, 0xCD25
        IOR  R4, R4, 0xDCC7
        XOR  R3, R5, R4
; EXPECT R3 = 0x5E82401E
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R8, H
; EXPECT R8 = 0x39FCCE8D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0xCC2D
        IOR  R10, R10, 0x7F12
        MHI  R8, 0xEE44
        IOR  R8, R8, 0x5F61
        IOR  R2, R10, R8
; EXPECT R2 = 0xEE6D7F73
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0x5CDE
        IOR  R8, R8, 0x40B2
        XOR  R6, R8, 21869
; EXPECT R6 = 0x5CDE15DF
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R7, NZCV
; EXPECT R7 = 0x00000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0xA15E
        IOR  R4, R4, 0x4B4F
        MHI  R1, 0x4B98
        IOR  R1, R1, 0xE3FE
        LSL  R11, R4, R1
; EXPECT R11 = 0xC0000000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0x3573
        IOR  R8, R8, 0x1453
        MHI  R2, 0x5923
        IOR  R2, R2, 0x9ED8
        AND  R5, R8, R2
; EXPECT R5 = 0x11231450
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0xA870
        IOR  R6, R6, 0x58FC
        MHI  R11, 0xEC03
        IOR  R11, R11, 0xD316
        IOR  R4, R6, R11
; EXPECT R4 = 0xEC73DBFE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0x3E94
        IOR  R11, R11, 0x5DC3
        XOR  R5, R11, -55954
; EXPECT R5 = 0xC16B78AD
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R1, 0xAA96
        IOR  R1, R1, 0x5FC5
        MHI  R6, 0xC4B1
        IOR  R6, R6, 0x8F9F
        AND  R3, R1, R6
; EXPECT R3 = 0x80900F85
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x3A21
        IOR  R4, R4, 0x2786
        SBC  R9, R4, 29481
; EXPECT R9 = 0x3A20B45D
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0xB8FF
; EXPECT R9 = 0xB8FF0000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0xBD3B
        IOR  R3, R3, 0x8ED0
        ADD  R11, R3, -40749
; EXPECT R11 = 0xBD3AEFA3
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x4026
        IOR  R10, R10, 0x5399
        MHI  R3, 0x4855
        IOR  R3, R3, 0xCABB
        MUL  R1, R10, R3
; EXPECT R1 = 0xE3C2CAC3
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x12204709

        MHI  R2, 0x5FF3
        IOR  R2, R2, 0xA8C0
        MHI  R7, 0xDEB5
        IOR  R7, R7, 0xDFFC
        XOR  R4, R2, R7
; EXPECT R4 = 0x8146773C
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R10, -2538
; EXPECT R10 = 0xFFFFF616
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x37F2
        IOR  R6, R6, 0xD434
        SBC  R3, R6, 375
; EXPECT R3 = 0x37F2D2BC
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MOV  R6, NZCV
; EXPECT R6 = 0x00000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x49E0
        IOR  R6, R6, 0xE899
        MHI  R11, 0x1BF5
        IOR  R11, R11, 0xAEA0
        ANN  R4, R6, R11
; EXPECT R4 = 0x40004019
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R6, 0x0FFA
; EXPECT R6 = 0x0FFA0000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R2, 0x3BF5
        IOR  R2, R2, 0xB725
        MHI  R9, 0x9C9D
        IOR  R9, R9, 0xE15D
        SBC  R4, R2, R9
; EXPECT R4 = 0x9F57D5C8
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R10, 0x4C21
        IOR  R10, R10, 0xFD2E
        IOR  R4, R10, 57544
; EXPECT R4 = 0x4C21FDEE
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R4, 0x7B6A
        IOR  R4, R4, 0x7809
        MHI  R2, 0x1DB3
        IOR  R2, R2, 0xB461
        AND  R6, R4, R2
; EXPECT R6 = 0x19223001
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R6, 0x9469
        IOR  R6, R6, 0x5925
        MHI  R2, 0xFEDC
        IOR  R2, R2, 0xA7D6
        ADD  R10, R6, R2
; EXPECT R10 = 0x934600FB
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x118B
        IOR  R3, R3, 0x5692
        ADD.uv  R8, R3, -6562
; EXPECT R8 = 0x118B3CF1
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0xC801
        IOR  R1, R1, 0x49B8
        MHI  R3, 0x4B47
        IOR  R3, R3, 0xB515
        ASR  R6, R1, R3
; EXPECT R6 = 0xFFFFFE40
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x205B
        IOR  R6, R6, 0xA73C
        MHI  R8, 0xB0B2
        IOR  R8, R8, 0x95F7
        AND  R11, R6, R8
; EXPECT R11 = 0x20128534
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x9520
        IOR  R3, R3, 0x5956
        MHI  R11, 0xCCCD
        IOR  R11, R11, 0xDA10
        SUB  R10, R3, R11
; EXPECT R10 = 0xC8527F46
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0xA4A6
        IOR  R9, R9, 0x07F6
        MHI  R1, 0x63C3
        IOR  R1, R1, 0x112C
        DIV  R8, R9, R1
; EXPECT R8 = 0xFFFFFFFF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x08691922

        MHI  R6, 0x2B87
        IOR  R6, R6, 0x1C0E
        IOR  R9, R6, 24162
; EXPECT R9 = 0x2B875E6E
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x849A
        IOR  R11, R11, 0x7C63
        AND  R7, R11, 61187
; EXPECT R7 = 0x00006C03
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0xCE04
        IOR  R4, R4, 0x8454
        MHI  R1, 0x057A
        IOR  R1, R1, 0x5A7A
        ASR  R8, R4, R1
; EXPECT R8 = 0xFFFFFFF3
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0xD645
        IOR  R2, R2, 0x730D
        MHI  R7, 0x61DB
        IOR  R7, R7, 0x391F
        ADD  R4, R2, R7
; EXPECT R4 = 0x3820AC2C
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0x6584
        IOR  R8, R8, 0x31E3
        MHI  R4, 0xA30B
        IOR  R4, R4, 0x7D67
        LSL  R3, R8, R4
; EXPECT R3 = 0xC218F180
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0x5274
        IOR  R1, R1, 0xCA19
        XOR  R3, R1, 61865
; EXPECT R3 = 0x52743BB0
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0xAB18
        IOR  R5, R5, 0xDF2E
        AND  R2, R5, 36821
; EXPECT R2 = 0x00008F04
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R5, -1108
; EXPECT R5 = 0xFFFFFBAC
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x0362
        IOR  R2, R2, 0xA717
        ROR  R11, R2, 5
; EXPECT R11 = 0xB81B1538
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x8C4E
        IOR  R6, R6, 0x8B32
        MHI  R10, 0x4467
        IOR  R10, R10, 0xE5CA
        LSL  R2, R6, R10
; EXPECT R2 = 0x3A2CC800
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0xE5B8
        IOR  R6, R6, 0xE131
        MHI  R5, 0x2159
        IOR  R5, R5, 0x6EF4
        ASR  R3, R6, R5
; EXPECT R3 = 0xFFFFFE5B
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x2539
        IOR  R11, R11, 0x8D2D
        MHI  R8, 0x2950
        IOR  R8, R8, 0xC6D9
        UMUL  R4, R11, R8
; EXPECT R4 = 0x64097925
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x0601F682

        MHI  R3, 0xECC4
        IOR  R3, R3, 0xE496
        AND.uv  R10, R3, -47791
; EXPECT R10 = 0xECC44410
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0x1B88
        IOR  R7, R7, 0x2CE5
        MHI  R2, 0x7669
        IOR  R2, R2, 0x072F
        IOR  R5, R7, R2
; EXPECT R5 = 0x7FE92FEF
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0xA427
        IOR  R6, R6, 0x7EDA
        MOV  R9, R6
; EXPECT R9 = 0xA4277EDA
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0xBEE7
        IOR  R10, R10, 0xFF85
        MHI  R5, 0x5309
        IOR  R5, R5, 0x63DB
        LSL  R11, R10, R5
; EXPECT R11 = 0x28000000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0xBE52
        IOR  R4, R4, 0x9F6A
        MHI  R8, 0x18D3
        IOR  R8, R8, 0x6177
        ROR  R4, R4, R8
; EXPECT R4 = 0xA53ED57C
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0xDFB5
        IOR  R11, R11, 0xD43D
        ASR  R9, R11, 16
; EXPECT R9 = 0xFFFFDFB5
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0xA444
        IOR  R4, R4, 0x32EE
        AND.uv  R1, R4, -5349
; EXPECT R1 = 0xA444220A
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0xFA7A
        IOR  R1, R1, 0x2157
        XOR  R6, R1, 16650
; EXPECT R6 = 0xFA7A605D
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R3, NZCV
; EXPECT R3 = 0xA0000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0xB5E0
        IOR  R2, R2, 0x6F19
        MHI  R8, 0x6378
        IOR  R8, R8, 0x2CE6
        IOR  R2, R2, R8
; EXPECT R2 = 0xF7F86FFF
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0x8B0A
        IOR  R8, R8, 0xF20F
        MHI  R10, 0xEBA1
        IOR  R10, R10, 0xE3B1
        ROR  R3, R8, R10
; EXPECT R3 = 0x7907C585
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0x0C0E
        IOR  R8, R8, 0x19D2
        MHI  R1, 0x1A80
        IOR  R1, R1, 0x05F7
        MUL  R1, R8, R1
; EXPECT R1 = 0x251C039E
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x013F75F4

        MHI  R6, 0x8DEE
        IOR  R6, R6, 0x6D86
        DIV  R4, R6, 37013
; EXPECT R4 = 0xFFFF3607
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x00000B73

        MHI  R11, 0x8ECD
        IOR  R11, R11, 0x3B44
        SUB  R4, R11, -21999
; EXPECT R4 = 0x8ECD9133
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x6F92
        IOR  R5, R5, 0xBE38
        MOV  R3, R5
; EXPECT R3 = 0x6F92BE38
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0x9F57
        IOR  R4, R4, 0x9638
        MHI  R5, 0x0522
        IOR  R5, R5, 0xE444
        DIV  R7, R4, R5
; EXPECT R7 = 0xFFFFFFED
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x00EE8744

        MHI  R4, 0xD54A
        IOR  R4, R4, 0x54ED
        MHI  R10, 0x1B4A
        IOR  R10, R10, 0x1558
        ADD  R2, R4, R10
; EXPECT R2 = 0xF0946A45
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R11, 0xEB7B
        IOR  R11, R11, 0x7F3B
        MHI  R8, 0xECF8
        IOR  R8, R8, 0x70D9
        ADD  R1, R11, R8
; EXPECT R1 = 0xD873F014
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R9, NZCV
; EXPECT R9 = 0xA0000053
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0xB857
        IOR  R11, R11, 0x0A1F
        LSL  R9, R11, 18
; EXPECT R9 = 0x287C0000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0x472C
        IOR  R4, R4, 0xEEF2
        MHI  R3, 0x5FBD
        IOR  R3, R3, 0x96A5
        ADD  R6, R4, R3
; EXPECT R6 = 0xA6EA8597
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R5, 0xFDF0
        IOR  R5, R5, 0x4845
        XOR  R2, R5, 11407
; EXPECT R2 = 0xFDF064CA
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R1, 0xC94A
        IOR  R1, R1, 0xC149
        MHI  R4, 0xD98B
        IOR  R4, R4, 0xB724
        LSL  R5, R1, R4
; EXPECT R5 = 0x94AC1490
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R9, 0xD73B
        IOR  R9, R9, 0x217C
        MHI  R10, 0x6CD8
        IOR  R10, R10, 0x0847
        ANN  R9, R9, R10
; EXPECT R9 = 0x93232138
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R11, 0x4608
        IOR  R11, R11, 0x2EE7
        MOV  R1, R11
; EXPECT R1 = 0x46082EE7
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MOV  R4, -44617
; EXPECT R4 = 0xFFFF51B7
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1

        MHI  R8, 0xA9BB
        IOR  R8, R8, 0xDA2E
        MHI  R7, 0x2AB9
        IOR  R7, R7, 0x46F9
        MUL  R9, R8, R7
; EXPECT R9 = 0xAC9DCABE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1
; EXPECT H = 0xF19A62A1

        MHI  R6, 0xE5BD
        IOR  R6, R6, 0x2034
        MHI  R1, 0x63D6
        IOR  R1, R1, 0x1D7D
        UMUL  R3, R6, R1
; EXPECT R3 = 0xA1769D64
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 1
; EXPECT H = 0x59984A03

        MHI  R7, 0x976D
        IOR  R7, R7, 0x7F2C
        MHI  R10, 0xB316
        IOR  R10, R10, 0x16E3
        SUB  R3, R7, R10
; EXPECT R3 = 0xE4576849
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x6CC3
        IOR  R5, R5, 0x5E7F
        AND.uv  R8, R5, -57487
; EXPECT R8 = 0x6CC31E71
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0x26B0
        IOR  R1, R1, 0xDB80
        LSL  R6, R1, 12
; EXPECT R6 = 0x0DB80000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x6E9A
        IOR  R2, R2, 0x13FF
        IOR  R3, R2, 7102
; EXPECT R3 = 0x6E9A1BFF
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x7DB6
        IOR  R11, R11, 0xC3EE
        MHI  R10, 0xB53C
        IOR  R10, R10, 0x12E7
        ROR  R10, R11, R10
; EXPECT R10 = 0xDCFB6D87
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x14F2
        IOR  R2, R2, 0x2C6E
        MHI  R5, 0xAAFA
        IOR  R5, R5, 0xB6BD
        ASR  R11, R2, R5
; EXPECT R11 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x3267
        IOR  R5, R5, 0x7A38
        MHI  R8, 0x7BE4
        IOR  R8, R8, 0x5D73
        ROR  R8, R5, R8
; EXPECT R8 = 0xEF47064C
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x3687
        IOR  R3, R3, 0x608A
        MOV  R4, R3
; EXPECT R4 = 0x3687608A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0xD925
        IOR  R5, R5, 0x11F0
        MHI  R3, 0x4710
        IOR  R3, R3, 0xD607
        UDIV  R2, R5, R3
; EXPECT R2 = 0x00000003
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x03F28FDB

        MHI  R8, 0x80DA
        IOR  R8, R8, 0xE827
        ADD  R8, R8, -21325
; EXPECT R8 = 0x80DA94DA
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x77EA
        IOR  R6, R6, 0xE6EC
        MHI  R4, 0x8D11
        IOR  R4, R4, 0x36BD
        ROR  R11, R6, R4
; EXPECT R11 = 0xBF573763
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0x664A
        IOR  R5, R5, 0x687E
        MHI  R1, 0x4498
        IOR  R1, R1, 0x333F
        UMUL  R5, R5, R1
; EXPECT R5 = 0x81F0D102
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x1B689469

        MHI  R7, 0xDB23
        IOR  R7, R7, 0x6C64
        MHI  R10, 0x2F21
        IOR  R10, R10, 0x70A0
        UDIV  R10, R7, R10
; EXPECT R10 = 0x00000004
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x1E9DA9E4

        MHI  R4, 0x2CBB
        IOR  R4, R4, 0x4050
        AND.uv  R1, R4, -30560
; EXPECT R1 = 0x2CBB0000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0xA86E
        IOR  R3, R3, 0x58B9
        MHI  R8, 0x2BA6
        IOR  R8, R8, 0x6D4F
        DIV  R1, R3, R8
; EXPECT R1 = 0xFFFFFFFD
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x2B61A0A6

        MHI  R7, 0xB067
        IOR  R7, R7, 0x8995
        MHI  R11, 0xDBBE
        IOR  R11, R11, 0x2FC0
        SUB  R6, R7, R11
; EXPECT R6 = 0xD4A959D5
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0xE6CF
        IOR  R1, R1, 0xCF10
        MHI  R6, 0x52C4
        IOR  R6, R6, 0x1B85
        UDIV  R5, R1, R6
; EXPECT R5 = 0x00000002
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x41479806

        MOV  R6, 27753
; EXPECT R6 = 0x00006C69
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x2810
        IOR  R2, R2, 0x8CF3
        XOR  R11, R2, 19669
; EXPECT R11 = 0x2810C026
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0xDAA5
        IOR  R8, R8, 0x336A
        ADD  R8, R8, -10530
; EXPECT R8 = 0xDAA50A48
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x2242
        IOR  R2, R2, 0x6AAD
        MHI  R9, 0xD1F1
        IOR  R9, R9, 0x0C02
        ADC  R6, R2, R9
; EXPECT R6 = 0xF43376B0
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R8, 0x62D9
        IOR  R8, R8, 0x421E
        SUB  R3, R8, -21310
; EXPECT R3 = 0x62D9955C
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0x4F82
        IOR  R1, R1, 0x1498
        MHI  R7, 0xF7B5
        IOR  R7, R7, 0xF9D2
        SUB  R11, R1, R7
; EXPECT R11 = 0x57CC1AC6
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R8, 0x1CB6
        IOR  R8, R8, 0xF16C
        MHI  R10, 0x7216
        IOR  R10, R10, 0x17E7
        ROR  R6, R8, R10
; EXPECT R6 = 0xD8396DE2
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0xBDF6
        IOR  R5, R5, 0xCDE2
        MHI  R7, 0x7857
        IOR  R7, R7, 0x8C47
        IOR  R9, R5, R7
; EXPECT R9 = 0xFDF7CDE7
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x13EB
; EXPECT R10 = 0x13EB0000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0xFB81
        IOR  R5, R5, 0xF6EB
        MHI  R10, 0x9BDB
        IOR  R10, R10, 0x0811
        XOR  R5, R5, R10
; EXPECT R5 = 0x605AFEFA
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R11, 0x23EE
        IOR  R11, R11, 0x9C2C
        ASR  R2, R11, 11
; EXPECT R2 = 0x00047DD3
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0x32D8
        IOR  R9, R9, 0x9098
        DIV  R7, R9, 25798
; EXPECT R7 = 0x0000812A
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0x0000421C

        MOV  R8, -31834
; EXPECT R8 = 0xFFFF83A6
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R5, 0xCB60
; EXPECT R5 = 0xCB600000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0x50CB
        IOR  R4, R4, 0x63B1
        MHI  R11, 0xDE39
        IOR  R11, R11, 0xAFCA
        SUB  R3, R4, R11
; EXPECT R3 = 0x7291B3E7
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x6A52
        IOR  R2, R2, 0x24DD
        MHI  R11, 0xA2F0
        IOR  R11, R11, 0x8D77
        ADD  R3, R2, R11
; EXPECT R3 = 0x0D42B254
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R7, 0xBBBC
        IOR  R7, R7, 0xD6C4
        MHI  R5, 0xFD2C
        IOR  R5, R5, 0x2943
        UMUL  R9, R7, R5
; EXPECT R9 = 0xFE81994C
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xFDED2C32

        MHI  R10, 0x192E
        IOR  R10, R10, 0x1F5F
        MHI  R8, 0xC76D
        IOR  R8, R8, 0xC218
        AND  R8, R10, R8
; EXPECT R8 = 0x012C0218
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0xEBF9
        IOR  R10, R10, 0x0A10
        MHI  R7, 0x037C
        IOR  R7, R7, 0x833B
        MUL  R1, R10, R7
; EXPECT R1 = 0xE24B81B0
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xFFBA2D7A

        MHI  R3, 0x66B2
        IOR  R3, R3, 0x22E2
        SBC  R11, R3, 6014
; EXPECT R11 = 0x66B20B63
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0x797E
        IOR  R5, R5, 0x20A8
        SUB  R5, R5, -25808
; EXPECT R5 = 0x797E8578
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x412E
        IOR  R3, R3, 0xAF03
        MOV  R1, R3
; EXPECT R1 = 0x412EAF03
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x85F6
        IOR  R6, R6, 0x5ADB
        MUL  R10, R6, 30416
; EXPECT R10 = 0x660AC3F0
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xFFFFC75C

        MHI  R4, 0xA89F
        IOR  R4, R4, 0x7B7A
        AND  R1, R4, -48819
; EXPECT R1 = 0xA89F4148
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x0C5B
        IOR  R10, R10, 0x42E3
        MHI  R9, 0x0FFB
        IOR  R9, R9, 0x64A6
        ROR  R2, R10, R9
; EXPECT R2 = 0x8C316D0B
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x4DF4
        IOR  R3, R3, 0xC379
        SUB  R4, R3, -2623
; EXPECT R4 = 0x4DF4CDB8
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0xC727
        IOR  R9, R9, 0xDC51
        IOR  R1, R9, -25517
; EXPECT R1 = 0xFFFFDC53
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R9, 0xDFC2
        IOR  R9, R9, 0xF25F
        MHI  R6, 0x2959
        IOR  R6, R6, 0x8E7A
        IOR  R7, R9, R6
; EXPECT R7 = 0xFFDBFE7F
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0x80F5
        IOR  R3, R3, 0xE5DD
        ASR  R7, R3, 11
; EXPECT R7 = 0xFFF01EBC
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MOV  R10, H
; EXPECT R10 = 0xFFFFC75C
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0x02D1
        IOR  R10, R10, 0x762C
        ASR  R9, R10, 29
; EXPECT R9 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 1
; EXPECT V = 0

        MHI  R10, 0xCE06
        IOR  R10, R10, 0x525E
        MUL  R9, R10, 26714
; EXPECT R9 = 0xFFAF250C
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xFFFFEBA0

        MHI  R3, 0xAB46
        IOR  R3, R3, 0xE792
        MHI  R8, 0xB1C9
        IOR  R8, R8, 0x6927
        SBC  R3, R3, R8
; EXPECT R3 = 0xF97D7E6A
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R1, 0x96AC
        IOR  R1, R1, 0x3522
        XOR  R5, R1, 49170
; EXPECT R5 = 0x96ACF530
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R3, 0xB17D
        IOR  R3, R3, 0x2C56
        IOR  R2, R3, -55890
; EXPECT R2 = 0xFFFF2DFE
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R2, 0x31D0
        IOR  R2, R2, 0x193E
        MUL  R1, R2, -26424
; EXPECT R1 = 0x60528870
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xFFFFEBEA

        MHI  R1, 0xDD3E
        IOR  R1, R1, 0x2C0B
        MHI  R8, 0xE44E
        IOR  R8, R8, 0x53D5
        UMUL  R4, R1, R8
; EXPECT R4 = 0x745C3627
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0
; EXPECT H = 0xE810E493

        MHI  R5, 0xEE7F
        IOR  R5, R5, 0xDF6E
        ANN  R10, R5, -28794
; EXPECT R10 = 0x00005068
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0x2EC8
        IOR  R4, R4, 0x4214
        ADC  R2, R4, 43532
; EXPECT R2 = 0x2EC8EC21
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R4, 0x99B4
; EXPECT R4 = 0x99B40000
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0x574A
        IOR  R7, R7, 0x8230
        MHI  R6, 0x776F
        IOR  R6, R6, 0x9342
        MUL  R11, R7, R6
; EXPECT R11 = 0x0CC72060
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x28B9AE09

        MHI  R9, 0x8089
        IOR  R9, R9, 0x4EB5
        ADC  R7, R9, 17000
; EXPECT R7 = 0x8089911D
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R9, 0x5C9F
        IOR  R9, R9, 0x31CE
        MHI  R5, 0x37EF
        IOR  R5, R5, 0xFC26
        ANN  R7, R9, R5
; EXPECT R7 = 0x481001C8
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R7, 0xA7AE
        IOR  R7, R7, 0xC368
        MHI  R10, 0x53BE
        IOR  R10, R10, 0x2413
        UDIV  R3, R7, R10
; EXPECT R3 = 0x00000002
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x00327B42

        MHI  R1, 0x542C
        IOR  R1, R1, 0xA78E
        ADD  R2, R1, -25509
; EXPECT R2 = 0x542C43E9
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R6, 0x8D13
        IOR  R6, R6, 0xFFA5
        MHI  R11, 0x0EE7
        IOR  R11, R11, 0x4319
        IOR  R3, R6, R11
; EXPECT R3 = 0x8FF7FFBD
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 0

        MHI  R4, 0x2EB8
        IOR  R4, R4, 0x06C7
        SBC  R10, R4, 49445
; EXPECT R10 = 0x2EB745A1
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R10, 0xE07E
        IOR  R10, R10, 0x98BF
        MHI  R2, 0xA8E4
        IOR  R2, R2, 0xF2F4
        MUL  R11, R10, R2
; EXPECT R11 = 0x072A240C
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x0AB84E58

        MOV  R8, H
; EXPECT R8 = 0x0AB84E58
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R3, 0x730D
        IOR  R3, R3, 0x7084
        DIV  R9, R3, 56809
; EXPECT R9 = 0x000084BA
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x0000113A

        MOV  R11, NZCV
; EXPECT R11 = 0x00000053
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0

        MHI  R5, 0xE6C6
        IOR  R5, R5, 0x67BB
        MUL  R6, R5, -398
; EXPECT R6 = 0x378ABB46
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 0
; EXPECT V = 0
; EXPECT H = 0x00000027

        MHI  R5, 0xB8ED
        IOR  R5, R5, 0x500E
        MHI  R9, 0x8D89
        IOR  R9, R9, 0x5468
        ADD  R10, R5, R9
; EXPECT R10 = 0x4676A476
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R8, 0x364E
; EXPECT R8 = 0x364E0000
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R4, 0x83E4
        IOR  R4, R4, 0x837B
        ASR  R10, R4, 28
; EXPECT R10 = 0xFFFFFFF8
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R6, 0x40D3
        IOR  R6, R6, 0x2906
        MHI  R2, 0x46B0
        IOR  R2, R2, 0x4BE5
        AND  R5, R6, R2
; EXPECT R5 = 0x40900904
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R8, 0x4AD4
        IOR  R8, R8, 0x9C33
        MHI  R9, 0x72A0
        IOR  R9, R9, 0x510B
        XOR  R4, R8, R9
; EXPECT R4 = 0x3874CD38
; EXPECT N = 0
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        MHI  R10, 0x2553
        IOR  R10, R10, 0xB7E1
        MHI  R3, 0xE192
        IOR  R3, R3, 0x71CB
        XOR  R3, R10, R3
; EXPECT R3 = 0xC4C1C62A
; EXPECT N = 1
; EXPECT Z = 0
; EXPECT C = 1
; EXPECT V = 1

        HALT
