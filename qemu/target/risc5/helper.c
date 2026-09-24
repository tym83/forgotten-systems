/*
 * Помощники RISC5: деление и явный отказ на ненаписанном.
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
#include "qemu/osdep.h"
#include "qemu/log.h"
#include "cpu.h"
#include "exec/helper-proto.h"
#include "accel/tcg/cpu-loop.h"

/*
 * Знаковое деление у Вирта округляет ВНИЗ, а не к нулю, как принято в C:
 * остаток всегда неотрицателен. Компилятор Оберона на это опирается, поэтому
 * округление к нулю здесь дало бы расхождение на отрицательных числах.
 *
 * Делитель железо рассчитывает на положительный (Divider.v); при нуле или
 * отрицательном его поведение не определено. Мы выбираем определённое:
 * возвращаем нули и пишем в журнал, чтобы расхождение было видно, а не
 * проявилось потом как загадочный результат.
 */
uint32_t HELPER(div)(CPURISC5State *env, uint32_t b, uint32_t c)
{
    int32_t x = (int32_t)b, y = (int32_t)c, q, r;

    if (y <= 0) {
        qemu_log_mask(LOG_GUEST_ERROR,
                      "RISC5: DIV на делитель %d — в железе не определено\n", y);
        env->h = 0;
        return 0;
    }

    q = x / y;
    r = x % y;
    if (r < 0) {          /* приводим к округлению вниз */
        q -= 1;
        r += y;
    }
    env->h = (uint32_t)r;
    return (uint32_t)q;
}

uint32_t HELPER(udiv)(CPURISC5State *env, uint32_t b, uint32_t c)
{
    if (c == 0) {
        qemu_log_mask(LOG_GUEST_ERROR, "RISC5: UDIV на ноль\n");
        env->h = 0;
        return 0;
    }
    env->h = b % c;
    return b / c;
}

void HELPER(unimplemented)(CPURISC5State *env, uint32_t what)
{
    CPUState *cs = env_cpu(env);

    qemu_log_mask(LOG_UNIMP, "RISC5: не написано, код %08x\n", what);
    cs->exception_index = EXCP_RESET;
    cpu_loop_exit(cs);
}
