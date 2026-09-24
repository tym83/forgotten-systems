/* SPDX-License-Identifier: GPL-2.0-or-later */

/*
 * Деление вынесено в помощника: железо считает его последовательно и,
 * главное, кладёт остаток в H. Знаковое деление у Вирта округляет ВНИЗ,
 * а не к нулю, как в C, — это видно в нашей модели АЛУ и проверено сверкой.
 */
DEF_HELPER_FLAGS_3(div, TCG_CALL_NO_RWG, i32, env, i32, i32)
DEF_HELPER_FLAGS_3(udiv, TCG_CALL_NO_RWG, i32, env, i32, i32)

/* Отказ вместо тихо неверного результата, пока плавающая точка не написана. */
DEF_HELPER_FLAGS_2(unimplemented, TCG_CALL_NO_WG, void, env, i32)
