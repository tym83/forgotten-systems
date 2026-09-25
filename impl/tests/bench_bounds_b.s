; ПОРОЖДЁННЫЙ ФАЙЛ — правится tools/gen_bounds_bench.py, не руками.
;
; Индексация массива в цикле, 1000000 итераций, предел 64.
; Конфигурация B: проверка границ программная (SUB + BCC)
        B    start
handler:                       ; ловушка: сюда не должны попасть ни разу
        MOV  R7, 0x0BAD
        ST   R7, R0, 260
spin:   B    spin
start:
        MOV  R0, 0
        MOV  R1, 0             ; индекс
        MOV  R2, 0x1000        ; база массива
        MOV  R4, 0             ; накопитель
        MOV  R5, 0             ; счётчик итераций
        MHI  R5, 0x000F
        IOR  R5, R5, 0x4240
        MOV  R12, 0            ; MT — адрес обработчика ловушек
        MHI  R12, 0x00FF
        IOR  R12, R12, 0xE004
loop:
        SUB  R11, R1, 64    ; Cmp: индекс - предел, только ради флагов
        BCC  handler           ; беззнаковое i >= lim -> ловушка
        LSL  R10, R1, 2        ; адрес элемента
        ADD  R10, R2, R10
        LD   R3, R10, 0
        ADD  R4, R4, R3        ; полезная работа
        ADD  R1, R1, 1         ; следующий индекс, с заворотом
        AND  R1, R1, 63
        SUB  R5, R5, 1
        BNE  loop
        MOV  R6, 0xB0DE
        ST   R6, R0, 256
done:   B    done
