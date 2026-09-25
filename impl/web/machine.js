// Переиспользуемая обвязка машины RISC5 для браузера.
//
// Выделена из index.html, чтобы лаборатории не переписывали заново отрисовку,
// ввод и цикл. Всё, что лаборатории нужно для ПРОВЕРКИ задания, доступно здесь
// же: регистры, флаги, память, кадровый буфер и образ диска.
//
// Кадровый буфер хранится снизу вверх (VID.v: vidadr = Org + {3'b0, ~vcnt, hword}),
// поэтому строки при отрисовке переворачиваются.

import OberonRISC5 from './risc5.js';

const W = 1024, H = 768;

// Модификатор, дающий среднюю кнопку. Клавиша физически одна, но называется
// по-разному: на маке на ней написано Option, и подсказка «Alt» там сбивает —
// человек ищет несуществующую клавишу. Ctrl в этой роли не годится вообще:
// macOS превращает Ctrl+щелчок в правую кнопку ещё до страницы.
const MAC = (() => {
  if (typeof navigator === 'undefined') return false;
  const n = navigator;
  return /Mac|iPhone|iPad|iPod/.test(
    (n.userAgentData && n.userAgentData.platform) || n.platform || n.userAgent || '');
})();

export const ALT_LABEL = MAC ? '\u2325 Option' : 'Alt';

/** Проставить подпись модификатора во все метки .k-alt внутри узла. */
export function labelAltKeys(root) {
  const r = root || (typeof document === 'undefined' ? null : document);
  if (!r) return;
  for (const el of r.querySelectorAll('.k-alt')) el.textContent = ALT_LABEL;
}


// Скан-коды PS/2, набор 2. Ровно те, что понимает Input.Mod.
export const PS2 = {
  KeyA:0x1C,KeyB:0x32,KeyC:0x21,KeyD:0x23,KeyE:0x24,KeyF:0x2B,KeyG:0x34,KeyH:0x33,
  KeyI:0x43,KeyJ:0x3B,KeyK:0x42,KeyL:0x4B,KeyM:0x3A,KeyN:0x31,KeyO:0x44,KeyP:0x4D,
  KeyQ:0x15,KeyR:0x2D,KeyS:0x1B,KeyT:0x2C,KeyU:0x3C,KeyV:0x2A,KeyW:0x1D,KeyX:0x22,
  KeyY:0x35,KeyZ:0x1A,
  Digit1:0x16,Digit2:0x1E,Digit3:0x26,Digit4:0x25,Digit5:0x2E,Digit6:0x36,
  Digit7:0x3D,Digit8:0x3E,Digit9:0x46,Digit0:0x45,
  Minus:0x4E,Equal:0x55,BracketLeft:0x54,BracketRight:0x5B,Backslash:0x5D,
  Semicolon:0x4C,Quote:0x52,Backquote:0x0E,Comma:0x41,Period:0x49,Slash:0x4A,
  Space:0x29,Enter:0x5A,Backspace:0x66,Tab:0x0D,Escape:0x76,
  ShiftLeft:0x12,ShiftRight:0x59,ControlLeft:0x14,ControlRight:0x14,
};

// Строка -> скан-коды с обрамлением Shift, как это делает клавиатура.
export function typeCodes(text) {
  // ⚠ Здесь была ошибка: таблица цифр начиналась с ')', из-за чего SHIFTED[0]
  // отображалось в несуществующий код, и закрывающая скобка просто не
  // набиралась. Текст сохранялся молча искажённым — проверка «файл существует»
  // такое пропускает. Сдвиг над цифрами: 0->) 1->! 2->@ ... 9->(
  const SHIFTED = ')!@#$%^&*(', DIG = '0123456789';
  const out = []; let shift = false;
  const push = (c, need) => {
    if (need && !shift) { out.push(0x12); shift = true; }
    else if (!need && shift) { out.push(0xF0, 0x12); shift = false; }
    out.push(c, 0xF0, c);
  };
  for (const ch of text) {
    if (ch >= 'a' && ch <= 'z') push(PS2['Key' + ch.toUpperCase()], false);
    else if (ch >= 'A' && ch <= 'Z') push(PS2['Key' + ch], true);
    else if (ch >= '0' && ch <= '9') push(PS2['Digit' + ch], false);
    else if (SHIFTED.includes(ch)) push(PS2['Digit' + DIG[SHIFTED.indexOf(ch)]], true);
    else {
      const map = {' ':['Space',0],'\n':['Enter',0],'\r':['Enter',0],'.':['Period',0],
        ',':['Comma',0],'/':['Slash',0],';':['Semicolon',0],"'":['Quote',0],
        '[':['BracketLeft',0],']':['BracketRight',0],'\\':['Backslash',0],
        '-':['Minus',0],'=':['Equal',0],'`':['Backquote',0],
        '~':['Backquote',1],'_':['Minus',1],'+':['Equal',1],':':['Semicolon',1],
        '"':['Quote',1],'<':['Comma',1],'>':['Period',1],'?':['Slash',1],
        '{':['BracketLeft',1],'}':['BracketRight',1],'|':['Backslash',1]};
      const m = map[ch];
      if (!m) throw new Error(`нет скан-кода для ${JSON.stringify(ch)}`);
      push(PS2[m[0]], !!m[1]);
    }
  }
  if (shift) out.push(0xF0, 0x12);
  return out;
}

export class Machine {
  static async create(prom, img) {
    const M = await OberonRISC5();
    const m = new Machine();
    m.M = M; m.prom = prom; m.img = img;
    m._load();
    return m;
  }

  _load() {
    const M = this.M;
    if (this.pP) { M._free(this.pP); M._free(this.pI); }
    this.pP = M._malloc(this.prom.length * 4);
    M.HEAPU8.set(new Uint8Array(this.prom.buffer), this.pP);
    this.pI = M._malloc(this.img.length);
    M.HEAPU8.set(this.img, this.pI);
    M._soc_init(this.pP, this.prom.length, this.pI, this.img.length);
    this.fbPtr = M._soc_framebuffer();
    this.fbN = M._soc_fb_words();
  }

  /** Полный откат: машина и образ диска возвращаются в исходное состояние. */
  reset() { this._load(); }

  run(n) { return this.M._soc_run(n | 0); }

  get insns()  { return this.M._soc_insns(); }
  get cycles() { return this.M._soc_cycles(); }
  get pc()     { return this.M._soc_pc(); }

  reg(i)   { return this.M._soc_reg(i) >>> 0; }
  flags()  { return this.M._soc_flags() >>> 0; }
  h()      { return this.M._soc_h() >>> 0; }
  ram(a)   { return this.M._soc_ram(a >>> 0) >>> 0; }
  poke(a, v) { this.M._soc_poke(a >>> 0, v >>> 0); }
  fbCrc()  { return this.M._soc_fb_crc() >>> 0; }
  disk(off){ return this.M._soc_disk_word(off >>> 0) >>> 0; }
  diskSize(){ return this.M._soc_disk_size() >>> 0; }

  key(code) { this.M._soc_key(code | 0); }
  mouse(x, y, b) { this.M._soc_mouse(x | 0, y | 0, b | 0); }

  /** Набрать текст. Между символами нужен ход машины: очередь конечна. */
  type(text, step = 4000) {
    for (const c of typeCodes(text)) { this.key(c); this.run(step); }
  }

  /** Щёлкнуть в точке экрана. y задаётся как на картинке, сверху вниз. */
  click(x, y, button = 2, hold = 150000) {
    this.mouse(x, 767 - y, 0); this.run(hold);
    this.mouse(x, 767 - y, button); this.run(hold);
    this.mouse(x, 767 - y, 0); this.run(hold);
  }

  fb() {
    const M = this.M;
    return new Uint32Array(M.HEAPU32.buffer, this.fbPtr, this.fbN);
  }

  /** Сколько чёрных точек в прямоугольнике. Нужен проверкам: «появился вьюер». */
  ink(x0, y0, x1, y1) {
    const fb = this.fb(); let n = 0;
    for (let y = y0; y < y1; y++) {
      const row = (767 - y) * 32;
      for (let x = x0; x < x1; x++)
        if ((fb[row + (x >> 5)] >>> (x & 31)) & 1) n++;
    }
    return n;
  }
}

/**
 * Развёртка кадрового буфера на канву. Отдельно от машины: в неё приезжает
 * СЫРОЙ буфер, по биту на точку, откуда угодно — из машины в этом же потоке
 * или из рабочего потока сообщением.
 */
export function makeRenderer(canvas) {
  const ctx = canvas.getContext('2d', { alpha: false });
  const img = ctx.createImageData(W, H);
  const px = new Uint32Array(img.data.buffer);
  const LUT = new Uint32Array(256 * 8);
  for (let b = 0; b < 256; b++)
    for (let k = 0; k < 8; k++)
      LUT[b * 8 + k] = (b >> k) & 1 ? 0xFF000000 : 0xFFFFFFFF;   // 1 — чёрный

  // Кадровый буфер хранится СНИЗУ ВВЕРХ (VID.v: vidadr = Org + {3'b0, ~vcnt, hword}),
  // поэтому строки при отрисовке переворачиваются.
  return function draw(fb) {
    for (let y = 0; y < H; y++) {
      const src = (767 - y) * 32, dst = y * W;
      for (let w = 0; w < 32; w++) {
        const v = fb[src + w], o = dst + w * 32;
        for (let byte = 0; byte < 4; byte++) {
          const t = ((v >>> (byte * 8)) & 0xFF) * 8, q = o + byte * 8;
          px[q]=LUT[t]; px[q+1]=LUT[t+1]; px[q+2]=LUT[t+2]; px[q+3]=LUT[t+3];
          px[q+4]=LUT[t+4]; px[q+5]=LUT[t+5]; px[q+6]=LUT[t+6]; px[q+7]=LUT[t+7];
        }
      }
    }
    ctx.putImageData(img, 0, 0);
  };
}

/**
 * Мышь и клавиатура канвы. Ввод уходит в `sink` — им может быть машина в этом
 * же потоке или рабочий поток за `postMessage`. Координаты отдаются уже в
 * системе Оберона (снизу вверх).
 *
 * sink: { mouse(x, y, btn), key(code), chord(x, y, first, then) }
 */
export function bindInput(canvas, sink) {
  let mx = 512, my = 384, btn = 0;
  const push = () => sink.mouse(mx, 767 - my, btn);
  // Какой кнопкой Оберона считать физическую левую. 4 — левая, 2 — средняя,
  // 1 — правая (нумерация Input.Mod).
  //
  // ⚠ Без этого переключателя часть системы недоступна на ноутбуке. Выделение
  // текста в Обероне — это ПРОТЯЖКА правой кнопкой, а на трекпаде мака правой
  // протяжки не существует: два пальца там означают прокрутку. Значит нельзя
  // ни выделить, ни, например, сменить шрифт через Edit.ChangeFont — команда
  // работает по выделению.
  let forced = 4;

  const btnsFrom = e => {
    // Источник истины — e.buttons: Оберону нужно ОДНОВРЕМЕННОЕ состояние
    // трёх кнопок для межкнопочных щелчков.
    let b = 0;
    if (e.buttons & 1) b |= (e.altKey ? 2 : forced);  // Alt всегда даёт среднюю
    if (e.buttons & 4) b |= 2;                        // настоящая средняя
    if (e.buttons & 2) b |= 1;                        // настоящая правая
    return b;
  };
  // ⚠ Межкнопочный щелчок. Часть системы требует НАЖАТЬ ДВЕ КНОПКИ СРАЗУ:
  // например вторая отметка в рисовалке ставится левой, к которой добавили
  // правую (GraphicFrames.Edit: ветка k1 = {2, 0}). Без второй отметки
  // Rectangles.Make и Curves.MakeCircle молча ничего не делают.
  //
  // На трекпаде двух кнопок сразу не нажать, поэтому аккорд собирается здесь:
  // с Shift сначала подаётся левая, машина успевает её увидеть, и только потом
  // добавляется правая. Порядок важен — система смотрит, с чего щелчок начался.
  let chord = false;
  canvas.addEventListener('mousemove', e => {
    const r = canvas.getBoundingClientRect();
    mx = Math.round((e.clientX - r.left) * W / r.width);
    my = Math.round((e.clientY - r.top) * H / r.height);
    if (chord && (e.buttons & 1)) { push(); return; }   // аккорд держим, двигаем только точку
    chord = false; btn = btnsFrom(e); push();
  });
  canvas.addEventListener('mousedown', e => {
    e.preventDefault();
    if (e.shiftKey && !e.altKey && (e.buttons & 1)) {
      chord = true; btn = 4 | 1;
      sink.chord(mx, 767 - my, 4, 4 | 1);   // сперва левая, затем к ней правая
      return;
    }
    chord = false; btn = btnsFrom(e); push();
  });
  addEventListener('mouseup', e => { chord = false; btn = btnsFrom(e); push(); });
  canvas.addEventListener('contextmenu', e => e.preventDefault());
  canvas.addEventListener('auxclick', e => e.preventDefault());

  // ⚠ Обработчики висят на всём окне, а не на канве, и глушили КАЖДОЕ нажатие,
  // код которого есть в таблице PS/2. Отсюда два следствия, найденных на живом
  // сайте: не работало копирование (Cmd/Ctrl+C), и — хуже — нельзя было вписать
  // адрес в поля лабораторной, то есть задание с записью в память не делалось
  // вовсе. Проверки лабораторных этого не ловили: они дёргают машину напрямую,
  // минуя DOM.
  //
  // Клавиатура уходит машине, только если человек не печатает в поле ввода и не
  // держит системный модификатор. Оберону ни Cmd, ни Ctrl для ввода не нужны.
  function typingElsewhere(e) {
    const t = e.target;
    if (!t) return false;
    if (t.isContentEditable) return true;
    const tag = t.tagName;
    return tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT';
  }
  function keyGoesToBrowser(e) {
    return e.metaKey || e.ctrlKey || typingElsewhere(e);
  }
  addEventListener('keydown', e => {
    if (keyGoesToBrowser(e)) return;
    const c = PS2[e.code]; if (c === undefined) return;
    e.preventDefault(); sink.key(c);
  });
  addEventListener('keyup', e => {
    if (keyGoesToBrowser(e)) return;
    const c = PS2[e.code]; if (c === undefined) return;
    e.preventDefault(); sink.key(0xF0); sink.key(c);
  });

  return { setButton(b) { forced = b; } };
}

/** Отрисовка кадрового буфера на канву и подключение мыши с клавиатурой. */
export function attach(machine, canvas) {
  const render = makeRenderer(canvas);
  const draw = () => render(machine.fb());
  const input = bindInput(canvas, {
    mouse: (x, y, b) => machine.mouse(x, y, b),
    key: c => machine.key(c),
    chord: (x, y, first, then) => {
      machine.mouse(x, y, first); machine.run(20000); machine.mouse(x, y, then);
    },
  });
  machine.setButton = b => input.setButton(b);

  let raf = 0, running = false;
  const QUOTA = 70000;      // ~4.2 МГц при 60 кадрах; без квоты вкладка жрёт ядро
  function frame() {
    if (!running) return;
    machine.run(QUOTA);
    draw();
    raf = requestAnimationFrame(frame);
  }
  return {
    draw,
    start() { if (!running) { running = true; frame(); } },
    stop() { running = false; cancelAnimationFrame(raf); },
    get running() { return running; },
  };
}
