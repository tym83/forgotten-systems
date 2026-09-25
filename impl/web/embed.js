/*
 * <oberon-machine> — машина Вирта, которую можно вставить в любую страницу.
 *
 *   <script type="module" src="https://…/embed.js"></script>
 *   <oberon-machine base="https://…/" autostart></oberon-machine>
 *
 * Требований к принимающей странице нет: ни заголовков, ни сборки, ни
 * фреймворка. Это осознанное ограничение дизайна — SharedArrayBuffer потребовал
 * бы COOP/COEP, а GitHub Pages заголовков не ставит вовсе, и тогда встроить
 * машину в чужой блог стало бы нельзя.
 *
 * Атрибуты:
 *   base       откуда брать risc5.js, prom_sd.mem и образ диска (по умолчанию —
 *              каталог этого файла)
 *   autostart  запускать сразу, не дожидаясь щелчка
 *   quota      тактов на кадр (по умолчанию 70000 ≈ 4.2 МГц при 60 кадрах)
 *   start-label подпись кнопки запуска (по умолчанию английская)
 *   variant    какое железо: `base` (сток) или `chk` (с аппаратной проверкой
 *              границ массива). Меняется на лету — машина поднимается заново
 *   width      ширина канвы в CSS (по умолчанию 100%)
 *
 * Свойства и события: `.start()`, `.stop()`, `.reset()`, `.setButton(n)`,
 * `.poke(адрес, значение)`, `.check(лаба, шаг, ответ)` — последнее исполняется
 * рядом с машиной, в потоке, и возвращает обещание;
 * события: `oberon-ready`, `oberon-frame` (раз в полсекунды, с темпом),
 * `oberon-buttons` (состояние кнопок мыши), `oberon-error`.
 */
import { makeRenderer, bindInput } from './machine.js';

const HERE = new URL('.', import.meta.url);

/**
 * Образ диска: сначала пробуем сжатый, потом обычный. Распакованное кладём в
 * Cache API — иначе мегабайт тянется заново на каждый заход, а GitHub Pages
 * отдаёт его без brotli и с коротким max-age.
 */
async function loadDisk(base) {
  const key = new URL('oberon.dsk', base).href;
  let cache = null;
  try { cache = await caches.open('oberon-v1'); } catch { /* приватный режим */ }
  if (cache) {
    const hit = await cache.match(key);
    if (hit) return new Uint8Array(await hit.arrayBuffer());
  }
  let bytes;
  const gz = await fetch(new URL('oberon.dsk.gz', base)).catch(() => null);
  if (gz && gz.ok && typeof DecompressionStream === 'function') {
    const stream = gz.body.pipeThrough(new DecompressionStream('gzip'));
    bytes = new Uint8Array(await new Response(stream).arrayBuffer());
  } else {
    bytes = new Uint8Array(await (await fetch(new URL('oberon.dsk', base))).arrayBuffer());
  }
  if (cache) { try { await cache.put(key, new Response(bytes)); } catch { /* квота */ } }
  return bytes;
}

async function loadProm(base) {
  const text = await (await fetch(new URL('prom_sd.mem', base))).text();
  return new Uint32Array(text.trim().split('\n').map(l => parseInt(l, 16)));
}

class OberonMachine extends HTMLElement {
  // Подпись кнопки может приехать позже разметки: страница узнаёт свой язык
  // уже после того, как элемент поднялся.
  static observedAttributes = ['start-label', 'variant'];
  attributeChangedCallback(name, old, value) {
    if (name === 'start-label' && this._button) this._button.textContent = value;
    // Смена железа = новая машина. Поток поднимается заново, образ грузится из
    // кэша, так что переключение стоит доли секунды.
    if (name === 'variant' && old !== null && old !== value && this._worker) this._reboot();
  }

  async _reboot() {
    const wasRunning = this._running;
    this.stop();
    this._worker.terminate();
    this._worker = null; this._ready = false; this._pending = false;
    this._t0 = 0;
    await this._boot();
    if (wasRunning) this.start();
  }

  connectedCallback() {
    if (this._built) return;
    this._built = true;
    const root = this.attachShadow({ mode: 'open' });
    root.innerHTML = `
      <style>
        :host { display:block; position:relative; }
        canvas { display:block; width:${this.getAttribute('width') || '100%'};
                 max-width:100%; height:auto; aspect-ratio:1024/768;
                 background:#fff; image-rendering:pixelated; cursor:crosshair; }
        .veil { position:absolute; inset:0; display:flex; align-items:center;
                justify-content:center; background:#1b1b1bcc; color:#ddd;
                font:14px/1.4 system-ui,sans-serif; cursor:pointer; text-align:center; }
        .veil[hidden] { display:none; }
        button { font:inherit; background:#2b2b2b; color:#ddd; border:1px solid #444;
                 border-radius:6px; padding:8px 14px; cursor:pointer; }
      </style>
      <canvas width="1024" height="768"></canvas>
      <div class="veil"><button part="start"></button></div>`;
    this._canvas = root.querySelector('canvas');
    this._veil = root.querySelector('.veil');
    // Подпись кнопки — снаружи: компонент встраивается в чужую страницу и не
    // знает её языка. По умолчанию английский, как и везде в проекте.
    this._button = root.querySelector('button');
    this._button.textContent = this.getAttribute('start-label') || 'Start the machine';
    this._veil.onclick = () => this.start();
    this._draw = makeRenderer(this._canvas);
    this._quota = +(this.getAttribute('quota') || 70000);
    this._base = new URL(this.getAttribute('base') || '.', HERE);
    this._running = false;
    this._raf = 0;
    this._askId = 0;
    this._waiting = new Map();

    // Машина не обязана считать, пока её не видно: вкладка скрыта или элемент
    // ушёл за край окна. Модель RTL не умеет простаивать и жжёт ядро ровно.
    this._visible = true;
    if (typeof IntersectionObserver === 'function') {
      new IntersectionObserver(([e]) => {
        this._visible = e.isIntersecting;
        if (this._running) this._kick();
      }, { threshold: 0 }).observe(this);
    }
    document.addEventListener('visibilitychange', () => { if (this._running) this._kick(); });

    this._input = bindInput(this._canvas, {
      mouse: (x, y, btn) => {
        this._send({ t: 'mouse', x, y, btn });
        // Наружу — чтобы страница могла подсветить нажатые кнопки: на трекпаде
        // человеку иначе не видно, какую из трёх кнопок Оберона он подаёт.
        if (btn !== this._btn) {
          this._btn = btn;
          this.dispatchEvent(new CustomEvent('oberon-buttons', { detail: btn }));
        }
      },
      key: code => this._send({ t: 'key', code }),
      chord: (x, y, first, then) => {
        this._send({ t: 'chord', x, y, first, then });
        this._btn = then;
        this.dispatchEvent(new CustomEvent('oberon-buttons', { detail: then }));
      },
    });

    if (this.hasAttribute('autostart')) this.start();
  }

  async _boot() {
    if (this._worker) return;
    this._worker = new Worker(new URL('worker.js', HERE), { type: 'module' });
    this._worker.onmessage = e => this._onMessage(e.data);
    const [prom, img] = await Promise.all([loadProm(this._base), loadDisk(this._base)]);
    // Образы уезжают с передачей владения: копировать мегабайт незачем.
    this._worker.postMessage({ t: 'init', variant: this.getAttribute('variant') || 'base',
                              prom: prom.buffer, img: img.buffer },
                             [prom.buffer, img.buffer]);
  }

  _onMessage(msg) {
    if (msg.t === 'ready') {
      this._ready = true;
      this.dispatchEvent(new CustomEvent('oberon-ready'));
      this._kick();
      return;
    }
    if (msg.t === 'frame') {
      const fb = new Uint32Array(msg.buf);
      this._draw(fb);
      // Буфер возвращаем потоку: на кадр их нужно всего два.
      this._worker.postMessage({ t: 'recycle', buf: msg.buf }, [msg.buf]);
      this._pending = false;
      this._stat(msg);
      this._kick();
      return;
    }
    if (msg.t === 'check') {
      const resolve = this._waiting.get(msg.id);
      if (resolve) { this._waiting.delete(msg.id); resolve(msg); }
      return;
    }
    if (msg.t === 'error') {
      this.dispatchEvent(new CustomEvent('oberon-error', { detail: msg.message }));
      console.error('[oberon]', msg.message);
    }
  }

  _stat(msg) {
    const now = performance.now();
    if (!this._t0) { this._t0 = now; this._c0 = msg.cycles; return; }
    if (now - this._t0 < 500) return;
    const mhz = (msg.cycles - this._c0) / (now - this._t0) / 1000;
    this._t0 = now; this._c0 = msg.cycles;
    this.dispatchEvent(new CustomEvent('oberon-frame', {
      detail: { insns: msg.insns, mhz, pc: msg.pc, crc: msg.crc } }));
  }

  _send(msg) { if (this._worker && this._ready) this._worker.postMessage(msg); }

  /**
   * Запрос с ответом. Нужен там, где странице недостаточно кадра: проверка
   * задания читает состояние машины, а машина живёт в потоке.
   */
  _ask(msg) {
    return new Promise(resolve => {
      const id = ++this._askId;
      this._waiting.set(id, resolve);
      this._send({ ...msg, id });
    });
  }

  /** Проверить шаг лабораторной. Считает поток, рядом с машиной. */
  check(lab, step, answer) { return this._ask({ t: 'check', lab, step, answer }); }

  /** Забыть накопленное состояние лабораторной. */
  forget(lab) { this._send({ t: 'forget', lab }); }

  /** Записать слово в память машины. */
  poke(adr, val) { this._send({ t: 'poke', adr, val }); }

  /** Просит у потока следующий кадр — если есть кому смотреть. */
  _kick() {
    cancelAnimationFrame(this._raf);
    if (!this._running || !this._ready || this._pending) return;
    if (document.hidden || !this._visible) return;
    this._raf = requestAnimationFrame(() => {
      this._pending = true;
      this._worker.postMessage({ t: 'run', quota: this._quota });
    });
  }

  start() {
    this._veil.hidden = true;
    this._running = true;
    this._boot().then(() => this._kick());
  }
  stop() { this._running = false; cancelAnimationFrame(this._raf); }
  reset() { this._send({ t: 'reset' }); }
  setButton(n) { this._input.setButton(+n); }
  get running() { return this._running; }
}

customElements.define('oberon-machine', OberonMachine);
export { OberonMachine };
