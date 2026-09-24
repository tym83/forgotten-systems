/*
 * Трансляция команд RISC5 в TCG.
 *
 * Семантика взята не из описаний, а из RISC5.v, и продублирована независимой
 * моделью АЛУ (impl/tools/alu_model.py), сверенной с железом на 4650
 * проверках. Там, где поведение неочевидно, в комментарии стоит строка
 * исходника железа.
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
#include "qemu/osdep.h"
#include "cpu.h"
#include "tcg/tcg-op.h"
#include "exec/helper-proto.h"
#include "exec/helper-gen.h"
#include "exec/translator.h"
#include "exec/translation-block.h"
#include "exec/target_page.h"

#define HELPER_H "helper.h"
#include "exec/helper-info.c.inc"
#undef  HELPER_H

static TCGv cpu_pc;
static TCGv cpu_r[RISC5_NUM_REGS];
static TCGv cpu_n, cpu_z, cpu_c, cpu_v, cpu_h;

#define R5_OFFS(x) offsetof(CPURISC5State, x)

typedef struct DisasContext {
    DisasContextBase base;
    uint32_t opcode;
    /* Счётчик следующей команды, В СЛОВАХ — как в железе. */
    uint32_t npc_w;
} DisasContext;

/*
 * Декодер порождается из insn.decode. Он объявляет и типы аргументов arg_*,
 * и прототипы trans_*, поэтому включается здесь: после типа DisasContext, на
 * который ссылается, и до определений самих функций разбора.
 */
#include "decode-insn.c.inc"

void risc5_cpu_tcg_init(void)
{
    int i;

    cpu_pc = tcg_global_mem_new_i32(tcg_env, R5_OFFS(pc_w), "pc_w");
    cpu_n  = tcg_global_mem_new_i32(tcg_env, R5_OFFS(sr_n), "N");
    cpu_z  = tcg_global_mem_new_i32(tcg_env, R5_OFFS(sr_z), "Z");
    cpu_c  = tcg_global_mem_new_i32(tcg_env, R5_OFFS(sr_c), "C");
    cpu_v  = tcg_global_mem_new_i32(tcg_env, R5_OFFS(sr_v), "V");
    cpu_h  = tcg_global_mem_new_i32(tcg_env, R5_OFFS(h), "H");

    for (i = 0; i < RISC5_NUM_REGS; i++) {
        char name[8];
        snprintf(name, sizeof(name), "R%d", i);
        cpu_r[i] = tcg_global_mem_new_i32(tcg_env, R5_OFFS(r[i]), name);
    }
}

/*
 * Второй операнд. RISC5.v:143 — C1 = q ? {{16{v}}, imm} : C0, то есть в
 * форме с непосредственным бит v заодно задаёт заполнение старшей половины.
 * Это не отдельный признак «знаковости», а именно тот же бит.
 */
static TCGv read_c1(bool q, unsigned v, unsigned c, uint32_t imm)
{
    if (!q) {
        return cpu_r[c];
    }
    return tcg_constant_i32(v ? (0xFFFF0000u | imm) : imm);
}

/* N и Z обновляются любой операцией АЛУ, C и V — только сложением и вычитанием. */
static void gen_logic_flags(TCGv res)
{
    tcg_gen_shri_i32(cpu_n, res, 31);
    tcg_gen_setcondi_i32(TCG_COND_EQ, cpu_z, res, 0);
}

/*
 * Перенос и переполнение по формулам самого железа (RISC5.v:206-212).
 * Они несимметричны и не совпадают с обычными: переписаны буква в букву,
 * потому что именно на них опирается компилятор Оберона.
 *   sa = результат[31], sb = B[31], sc = C1[31]
 */
static void gen_addsub_flags(TCGv res, TCGv b, TCGv c1, bool sub)
{
    TCGv sa = tcg_temp_new_i32(), sb = tcg_temp_new_i32();
    TCGv sc = tcg_temp_new_i32();
    TCGv t0 = tcg_temp_new_i32(), t1 = tcg_temp_new_i32();
    TCGv t2 = tcg_temp_new_i32();

    tcg_gen_shri_i32(sa, res, 31);
    tcg_gen_shri_i32(sb, b, 31);
    tcg_gen_shri_i32(sc, c1, 31);

    /* Общая для обеих операций часть: (~sb & sc & ~sa) | (sb & sc & sa) */
    tcg_gen_xori_i32(t0, sb, 1);
    tcg_gen_and_i32(t0, t0, sc);
    tcg_gen_xori_i32(t1, sa, 1);
    tcg_gen_and_i32(t0, t0, t1);        /* ~sb & sc & ~sa */

    tcg_gen_and_i32(t1, sb, sc);
    tcg_gen_and_i32(t1, t1, sa);        /* sb & sc & sa */
    tcg_gen_or_i32(t0, t0, t1);

    if (!sub) {
        tcg_gen_xori_i32(t1, sa, 1);
        tcg_gen_and_i32(t1, t1, sb);    /* sb & ~sa */
    } else {
        tcg_gen_xori_i32(t1, sb, 1);
        tcg_gen_and_i32(t1, t1, sa);    /* ~sb & sa */
    }
    tcg_gen_or_i32(cpu_c, t0, t1);

    if (!sub) {
        /* V = (sa & ~sb & ~sc) | (~sa & sb & sc) */
        tcg_gen_xori_i32(t0, sb, 1);
        tcg_gen_xori_i32(t1, sc, 1);
        tcg_gen_and_i32(t0, t0, t1);
        tcg_gen_and_i32(t0, t0, sa);
        tcg_gen_xori_i32(t1, sa, 1);
        tcg_gen_and_i32(t2, sb, sc);
        tcg_gen_and_i32(t1, t1, t2);
    } else {
        /* V = (sa & ~sb & sc) | (~sa & sb & ~sc) */
        tcg_gen_xori_i32(t0, sb, 1);
        tcg_gen_and_i32(t0, t0, sc);
        tcg_gen_and_i32(t0, t0, sa);
        tcg_gen_xori_i32(t1, sa, 1);
        tcg_gen_xori_i32(t2, sc, 1);
        tcg_gen_and_i32(t2, sb, t2);
        tcg_gen_and_i32(t1, t1, t2);
    }
    tcg_gen_or_i32(cpu_v, t0, t1);

    gen_logic_flags(res);
}

/*
 * Умножение. Здесь живёт находка 11: команда, названная UMUL, на деле
 * перемножает БЕЗЗНАКОВОЕ на ЗНАКОВОЕ. Второй сомножитель знаковый всегда,
 * бит u управляет только первым.
 */
static void gen_mul(TCGv dst, TCGv b, TCGv c1, bool unsigned_b)
{
    TCGv_i64 x = tcg_temp_new_i64(), y = tcg_temp_new_i64();
    TCGv_i64 p = tcg_temp_new_i64();
    TCGv hi = tcg_temp_new_i32();

    if (unsigned_b) {
        tcg_gen_extu_i32_i64(x, b);
    } else {
        tcg_gen_ext_i32_i64(x, b);
    }
    tcg_gen_ext_i32_i64(y, c1);
    tcg_gen_mul_i64(p, x, y);
    tcg_gen_extr_i64_i32(dst, hi, p);
    tcg_gen_mov_i32(cpu_h, hi);
}

static void gen_alu(DisasContext *ctx, unsigned a, unsigned b, unsigned op,
                    unsigned u, unsigned v, bool q, unsigned c, uint32_t imm)
{
    TCGv c1 = read_c1(q, v, c, imm);
    TCGv res = tcg_temp_new_i32();
    TCGv sh;

    switch (op) {
    case 0: /* MOV во всех видах — RISC5.v:156 */
        if (q) {
            if (u) {
                tcg_gen_movi_i32(res, imm << 16);      /* MHI */
            } else {
                tcg_gen_mov_i32(res, c1);
            }
        } else if (!u) {
            tcg_gen_mov_i32(res, cpu_r[c]);
        } else if (!v) {
            tcg_gen_mov_i32(res, cpu_h);
        } else {
            /*
             * Чтение флагов даёт не четыре бита, а {N,Z,C,V, 20 нулей, 0x53}.
             * Младший байт — подпись версии ядра, система её проверяет.
             */
            TCGv t = tcg_temp_new_i32();
            tcg_gen_shli_i32(res, cpu_n, 31);
            tcg_gen_shli_i32(t, cpu_z, 30);
            tcg_gen_or_i32(res, res, t);
            tcg_gen_shli_i32(t, cpu_c, 29);
            tcg_gen_or_i32(res, res, t);
            tcg_gen_shli_i32(t, cpu_v, 28);
            tcg_gen_or_i32(res, res, t);
            tcg_gen_ori_i32(res, res, RISC5_NZCV_TAG);
        }
        break;

    /* Сдвиги берут только пять младших бит счётчика. */
    case 1:
        sh = tcg_temp_new_i32();
        tcg_gen_andi_i32(sh, c1, 31);
        tcg_gen_shl_i32(res, cpu_r[b], sh);
        break;
    case 2:
        sh = tcg_temp_new_i32();
        tcg_gen_andi_i32(sh, c1, 31);
        tcg_gen_sar_i32(res, cpu_r[b], sh);
        break;
    case 3:
        sh = tcg_temp_new_i32();
        tcg_gen_andi_i32(sh, c1, 31);
        tcg_gen_rotr_i32(res, cpu_r[b], sh);
        break;

    case 4: tcg_gen_and_i32(res, cpu_r[b], c1); break;
    case 5: tcg_gen_andc_i32(res, cpu_r[b], c1); break;   /* ANN: B & ~C1 */
    case 6: tcg_gen_or_i32(res, cpu_r[b], c1); break;
    case 7: tcg_gen_xor_i32(res, cpu_r[b], c1); break;

    case 8: /* ADD, при u=1 — с переносом */
        tcg_gen_add_i32(res, cpu_r[b], c1);
        if (u) {
            tcg_gen_add_i32(res, res, cpu_c);
        }
        gen_addsub_flags(res, cpu_r[b], c1, false);
        tcg_gen_mov_i32(cpu_r[a], res);
        return;
    case 9: /* SUB, при u=1 — с заёмом */
        tcg_gen_sub_i32(res, cpu_r[b], c1);
        if (u) {
            tcg_gen_sub_i32(res, res, cpu_c);
        }
        gen_addsub_flags(res, cpu_r[b], c1, true);
        tcg_gen_mov_i32(cpu_r[a], res);
        return;

    case 10: gen_mul(res, cpu_r[b], c1, u != 0); break;
    case 11:
        if (u) {
            gen_helper_udiv(res, tcg_env, cpu_r[b], c1);
        } else {
            gen_helper_div(res, tcg_env, cpu_r[b], c1);
        }
        break;

    default:
        /*
         * Плавающая точка (12..15) ещё не написана. Молча возвращать мусор
         * нельзя: тихо неверный результат хуже отказа.
         */
        gen_helper_unimplemented(tcg_env, tcg_constant_i32(op));
        ctx->base.is_jmp = DISAS_NORETURN;
        return;
    }

    gen_logic_flags(res);
    tcg_gen_mov_i32(cpu_r[a], res);
}

static bool trans_F0_rrr(DisasContext *ctx, arg_F0_rrr *r)
{
    gen_alu(ctx, r->a, r->b, r->op, r->u, r->v, false, r->c, 0);
    return true;
}

static bool trans_F1_rri(DisasContext *ctx, arg_F1_rri *r)
{
    gen_alu(ctx, r->a, r->b, r->op, r->u, r->v, true, 0, r->imm);
    return true;
}

/*
 * Обращение к памяти. Смещение знаковое, двадцать бит. Байтовая форма
 * (v=1) читает и пишет младший байт.
 */
static bool trans_F2_mem(DisasContext *ctx, arg_F2_mem *r)
{
    TCGv addr = tcg_temp_new_i32();
    int32_t off = sextract32(r->off, 0, 20);

    tcg_gen_addi_i32(addr, cpu_r[r->b], off);

    if (!r->u) {
        tcg_gen_qemu_ld_i32(cpu_r[r->a], addr, 0, r->v ? MO_UB : MO_TEUL);
    } else {
        tcg_gen_qemu_st_i32(cpu_r[r->a], addr, 0, r->v ? MO_UB : MO_TEUL);
    }
    return true;
}

/*
 * Условия перехода. Порядок ровно как в железе; старший бит поля
 * отрицает условие.
 */
static void gen_cond(TCGv dst, unsigned cond)
{
    TCGv t = tcg_temp_new_i32();

    switch (cond & 7) {
    case 0: tcg_gen_mov_i32(dst, cpu_n); break;                    /* MI */
    case 1: tcg_gen_mov_i32(dst, cpu_z); break;                    /* EQ */
    case 2: tcg_gen_mov_i32(dst, cpu_c); break;                    /* CS */
    case 3: tcg_gen_mov_i32(dst, cpu_v); break;                    /* VS */
    case 4: tcg_gen_or_i32(dst, cpu_c, cpu_z); break;              /* LS */
    case 5: tcg_gen_xor_i32(dst, cpu_n, cpu_v); break;             /* LT */
    case 6:                                                        /* LE */
        tcg_gen_xor_i32(t, cpu_n, cpu_v);
        tcg_gen_or_i32(dst, t, cpu_z);
        break;
    default: tcg_gen_movi_i32(dst, 1); break;                      /* всегда */
    }
    if (cond & 8) {
        tcg_gen_xori_i32(dst, dst, 1);
    }
}

static bool trans_F3_reg(DisasContext *ctx, arg_F3_reg *r)
{
    /* Здесь же прячется RTI: BR & ~u & ~v & IR[4] (RISC5.v:98). */
    TCGLabel *skip = gen_new_label();
    TCGv cond = tcg_temp_new_i32();

    gen_cond(cond, r->cond);
    tcg_gen_brcondi_i32(TCG_COND_EQ, cond, 0, skip);

    if (r->v) {                                   /* со ссылкой возврата */
        tcg_gen_movi_i32(cpu_r[RISC5_REG_LNK], ctx->npc_w * 4);
    }
    /* Адрес перехода лежит в регистре БАЙТОВЫЙ, счётчик считает слова. */
    tcg_gen_shri_i32(cpu_pc, cpu_r[r->c], 2);
    tcg_gen_exit_tb(NULL, 0);

    gen_set_label(skip);
    return true;
}

static bool trans_F3_disp(DisasContext *ctx, arg_F3_disp *r)
{
    TCGLabel *skip = gen_new_label();
    TCGv cond = tcg_temp_new_i32();
    uint32_t target_w;

    gen_cond(cond, r->cond);
    tcg_gen_brcondi_i32(TCG_COND_EQ, cond, 0, skip);

    if (r->v) {
        tcg_gen_movi_i32(cpu_r[RISC5_REG_LNK], ctx->npc_w * 4);
    }
    /*
     * Смещение считается в СЛОВАХ от следующей команды. ORG.Mod излучает
     * двадцать четыре бита, железо читает двадцать два — расхождение
     * записано находкой 24; берём то, что делает железо.
     */
    target_w = (ctx->npc_w + sextract32(r->disp, 0, 22)) & 0x3FFFFF;
    tcg_gen_movi_i32(cpu_pc, target_w);
    tcg_gen_exit_tb(NULL, 0);

    gen_set_label(skip);
    return true;
}

static void risc5_tr_init_disas_context(DisasContextBase *dcbase, CPUState *cs)
{
    DisasContext *ctx = container_of(dcbase, DisasContext, base);
    ctx->npc_w = ctx->base.pc_first / 4;
}

static void risc5_tr_tb_start(DisasContextBase *db, CPUState *cs)
{
}

static void risc5_tr_insn_start(DisasContextBase *dcbase, CPUState *cs)
{
    DisasContext *ctx = container_of(dcbase, DisasContext, base);
    tcg_gen_insn_start(ctx->npc_w, 0, 0);
}

static void risc5_tr_translate_insn(DisasContextBase *dcbase, CPUState *cs)
{
    DisasContext *ctx = container_of(dcbase, DisasContext, base);

    ctx->opcode = translator_ldl(cpu_env(cs), &ctx->base, ctx->base.pc_next);
    ctx->base.pc_next += 4;
    ctx->npc_w = ctx->base.pc_next / 4;

    /*
     * Счётчик обновляем ДО разбора: переход со ссылкой возврата кладёт в
     * R15 адрес следующей команды, и он должен быть уже посчитан.
     */
    if (!decode_insn(ctx, ctx->opcode)) {
        gen_helper_unimplemented(tcg_env, tcg_constant_i32(ctx->opcode));
        ctx->base.is_jmp = DISAS_NORETURN;
    }
}

static void risc5_tr_tb_stop(DisasContextBase *dcbase, CPUState *cs)
{
    DisasContext *ctx = container_of(dcbase, DisasContext, base);

    if (ctx->base.is_jmp == DISAS_NORETURN) {
        return;
    }
    tcg_gen_movi_i32(cpu_pc, ctx->npc_w);
    tcg_gen_exit_tb(NULL, 0);
}

static const TranslatorOps risc5_tr_ops = {
    .init_disas_context = risc5_tr_init_disas_context,
    .tb_start           = risc5_tr_tb_start,
    .insn_start         = risc5_tr_insn_start,
    .translate_insn     = risc5_tr_translate_insn,
    .tb_stop            = risc5_tr_tb_stop,
};

void risc5_cpu_translate_code(CPUState *cs, TranslationBlock *tb,
                              int *max_insns, vaddr pc, void *host_pc)
{
    DisasContext ctx = { };
    translator_loop(cs, tb, max_insns, pc, host_pc, &risc5_tr_ops, &ctx.base,
                    TCG_TYPE_VA);
}
