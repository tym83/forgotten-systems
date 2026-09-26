/*
 * Центральный номер: во сколько обходится проверка границ массива.
 *
 * Одно и то же тело цикла, собранное двумя способами (tools/gen_bounds_bench.py):
 *   B — как эмитит компилятор сегодня: SUB + BCC, две команды на индексацию
 *   E — то же одной командой CHKS, которую понимает железо с расширением
 *
 * Программа кладётся в ПЗУ и исполняется со сброса, поэтому ни системы, ни
 * образа диска для замера не нужно — только модель процессора.
 *
 * Модуль один на страницу и на node: число, посчитанное в проверке, обязано
 * совпадать с числом, которое видит читатель.
 */

/**
 * Гоняет программу РОВНО `budget` инструкций и возвращает счётчики.
 *
 * ⚠ Не «до конца программы»: момент окончания ловится с точностью до шага, и
 * в числа попадает холостой хвост. На первой попытке из-за этого разница между
 * конфигурациями вышла вдесятеро больше настоящей. Цикл длиннее бюджета, а
 * сделанные итерации читаются из счётчика в регистре.
 */
export async function runBench(factory, prom, params) {
  const M = await factory();
  const pP = M._malloc(prom.length * 4);
  M.HEAPU8.set(new Uint8Array(prom.buffer, prom.byteOffset, prom.length * 4), pP);
  // Диска нет: программа к нему не обращается.
  const pI = M._malloc(1024);
  M._soc_init(pP, prom.length, pI, 1024);
  M._free(pP); M._free(pI);

  M._soc_run(params.budget);
  const left = M._soc_reg(params.counter) >>> 0;
  return {
    cycles: M._soc_cycles(), insns: M._soc_insns(),
    iterations: params.iterations - left,
    trapped: (M._soc_ram(params.done + 4) >>> 0) === 0xBAD,
  };
}

/** Раскладка результата: во что обходится одна проверка. */
export function perCheck(b, e) {
  // Работа одна и та же, бюджет инструкций один и тот же — значит сравнивать
  // надо СТОИМОСТЬ ИТЕРАЦИИ, а не сумму: за один бюджет конфигурации успевают
  // разное число итераций.
  const bc = b.cycles / b.iterations, ec = e.cycles / e.iterations;
  const bi = b.insns / b.iterations, ei = e.insns / e.iterations;
  return {
    cyclesB: bc, cyclesE: ec, insnsB: bi, insnsE: ei,
    cyclesPer: bc - ec, insnsPer: bi - ei,
    percent: ((bc - ec) / bc) * 100,
  };
}
