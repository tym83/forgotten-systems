/*
 * Ядро рабочего потока: машина RISC5 живёт здесь, страница — только рисует.
 *
 * Зачем поток. Модель RTL считает непрерывно и в главном потоке съедает кадр
 * целиком: прокрутка страницы, в которую встроена машина, начинает дёргаться.
 * В отдельном потоке она не мешает ничему.
 *
 * ⚠ SharedArrayBuffer здесь НЕ используется, сознательно (дизайн v0.2).
 * Он потребовал бы заголовков COOP/COEP, а GitHub Pages заголовков не ставит
 * вовсе — и страницу нельзя было бы встроить в чужой блог. Кадр уезжает
 * обычным postMessage с передачей владения: 96 КБ за O(1), без копии.
 *
 * Кадровый буфер отдаётся СЫРЫМ, по биту на точку. Разворачивать его в RGBA
 * здесь нельзя: это 3 МБ на кадр вместо 96 КБ. Разворот стоит 0.33 мс на
 * главном потоке (измерено) — дешевле пересылки в тридцать раз.
 *
 * Логика вынесена из worker.js, чтобы её можно было проверить в node: там
 * `self` нет, а протокол проверять надо.
 */
import { Machine } from './machine.js';
import { LABS } from './labs.js';

/**
 * Собирает обработчик сообщений. `post(msg, transfer)` — как postMessage.
 * Возвращает async-функцию, которой скармливают приходящие сообщения.
 */
export function createHandler(post) {
  let m = null;
  // Состояние лабораторных по номеру: их шаги накапливают его между проверками.
  const state = {};
  // Буферы под кадры ходят по кругу: страница возвращает отрисованный обратно
  // сообщением `recycle`. Без этого на каждый кадр выделяется 96 КБ, и сборщик
  // мусора просыпается шестьдесят раз в секунду.
  const pool = [];

  function frame(extra) {
    const fb = m.fb();
    const buf = pool.pop() || new ArrayBuffer(fb.length * 4);
    new Uint32Array(buf).set(fb);
    // Контрольная сумма экрана идёт вместе с кадром: по ней страница
    // показывает единственное, что человеку важно, — рисует машина или замерла.
    post({ t: 'frame', buf, insns: m.insns, cycles: m.cycles, pc: m.pc,
           crc: m.fbCrc(), ...extra }, [buf]);
  }

  return async function handle(msg) {
    switch (msg.t) {
      case 'init':
        m = await Machine.create(new Uint32Array(msg.prom), new Uint8Array(msg.img),
                                 msg.variant || 'base');
        post({ t: 'ready', variant: m.variant });
        return;

      case 'run':
        // Кадр запрашивает страница, а не поток сам: пока вкладка скрыта или
        // машина вне экрана, запросов нет — и поток ничего не жжёт.
        m.run(msg.quota | 0);
        frame();
        return;

      case 'key':   m.key(msg.code | 0); return;
      case 'mouse': m.mouse(msg.x | 0, msg.y | 0, msg.btn | 0); return;

      // Аккорд из двух кнопок: между нажатиями машине нужно дать ход, иначе
      // система не увидит, с какой кнопки щелчок начался.
      case 'chord':
        m.mouse(msg.x | 0, msg.y | 0, msg.first | 0);
        m.run(msg.gap | 0 || 20000);
        m.mouse(msg.x | 0, msg.y | 0, msg.then | 0);
        return;

      // ── лабораторные ──────────────────────────────────────────────────────
      // Проверка задания читает регистры, память и экран машины, поэтому
      // исполняется ЗДЕСЬ, рядом с машиной. Иначе страница тянула бы через
      // границу потока всё состояние целиком на каждый щелчок.
      case 'check': {
        const lab = LABS.find(l => l.id === msg.lab);
        const step = lab && lab.steps[msg.step];
        if (!step) { post({ t: 'check', id: msg.id, ok: false, msg: 'нет такого шага' }); return; }
        state[msg.lab] ??= {};
        let r;
        try {
          r = step.check(m, { state: state[msg.lab], answer: msg.answer || '' });
        } catch (e) {
          r = { ok: false, msg: String(e && e.message || e) };
        }
        post({ t: 'check', id: msg.id, ok: !!r.ok, msg: r.msg || '' });
        return;
      }

      // Состояние лабораторной живёт рядом с машиной: шаги опираются на то,
      // что запомнил предыдущий, а машина у них общая.
      case 'forget':
        state[msg.lab] = {};
        return;

      case 'poke':
        m.poke(msg.adr >>> 0, msg.val >>> 0);
        return;

      case 'reset':
        m.reset();
        frame({ reset: true });
        return;

      case 'recycle':
        if (pool.length < 3) pool.push(msg.buf);
        return;

      // Для лабораторных и проверок: заглянуть внутрь машины.
      case 'peek':
        post({ t: 'peek', id: msg.id, regs: Array.from({ length: 16 }, (_, i) => m.reg(i)),
               flags: m.flags(), h: m.h(), pc: m.pc, insns: m.insns, crc: m.fbCrc(),
               // Слово по адресу — для лабораторных, где человек пишет в память
               // и должен увидеть, что именно туда легло.
               word: msg.adr === undefined ? undefined : m.ram(msg.adr >>> 0) });
        return;

      default:
        post({ t: 'error', message: `неизвестное сообщение: ${msg.t}` });
    }
  };
}
