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

/**
 * Собирает обработчик сообщений. `post(msg, transfer)` — как postMessage.
 * Возвращает async-функцию, которой скармливают приходящие сообщения.
 */
export function createHandler(post) {
  let m = null;
  // Буферы под кадры ходят по кругу: страница возвращает отрисованный обратно
  // сообщением `recycle`. Без этого на каждый кадр выделяется 96 КБ, и сборщик
  // мусора просыпается шестьдесят раз в секунду.
  const pool = [];

  function frame(extra) {
    const fb = m.fb();
    const buf = pool.pop() || new ArrayBuffer(fb.length * 4);
    new Uint32Array(buf).set(fb);
    post({ t: 'frame', buf, insns: m.insns, cycles: m.cycles, pc: m.pc, ...extra }, [buf]);
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
               flags: m.flags(), h: m.h(), pc: m.pc, insns: m.insns, crc: m.fbCrc() });
        return;

      default:
        post({ t: 'error', message: `неизвестное сообщение: ${msg.t}` });
    }
  };
}
