; T1.19 — семантический дифференциал (СГЕНЕРИРОВАН tools/gen_alu_diff.py).
; Зерно 20260923, случаев 900. Ожидания посчитаны моделью tools/alu_model.py,
; написанной по RISC5.v независимо от ассемблера. Проверяются результат и флаги.

        MHI  R7, 0x2E33
        IOR  R7, R7, 0xCBDF
        MHI  R9, 0x377B
        IOR  R9, R9, 0xD466
        DIV  R6, R7, R9
; EXPECT R6 = 0x00000000
; EXPECT N = 0
; EXPECT Z = 1
; EXPECT C = 0
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
