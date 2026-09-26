// Проверка протокола рабочего потока без браузера.
//
// Смысл: страница и поток разговаривают сообщениями, и разойтись они могут
// молча — картинка просто перестанет обновляться. Здесь та же логика (её ядро
// вынесено из worker.js именно ради этого) гоняется в node на настоящей машине.
import fs from 'node:fs';
import { createHandler } from './worker-core.js';

const prom = fs.readFileSync('prom_sd.mem', 'utf8').trim().split('\n').map(l => parseInt(l, 16));
const img = new Uint8Array(fs.readFileSync('oberon.dsk'));

let bad = 0;
const say = (ok, s) => { console.log(`  ${ok ? '✅' : '❌'} ${s}`); if (!ok) bad++; };

const out = [];
const transfers = [];
const handle = createHandler((msg, t) => { out.push(msg); transfers.push(t || null); });
const last = t => [...out].reverse().find(m => m.t === t);

await handle({ t: 'init', prom: new Uint32Array(prom).buffer, img: img.buffer });
say(!!last('ready'), 'машина поднимается по сообщению init');

// ── кадры ───────────────────────────────────────────────────────────────────
await handle({ t: 'run', quota: 100000 });
const first = last('frame');
say(!!first && first.buf.byteLength === 96 * 1024, 'кадр приходит сырым буфером на 96 КБ');
say(transfers[out.indexOf(first)]?.[0] === first.buf, 'буфер кадра отдаётся с передачей владения');

const before = first.insns;
await handle({ t: 'run', quota: 100000 });
say(last('frame').insns > before, 'инструкции считаются от кадра к кадру');

// ── буферы ходят по кругу ───────────────────────────────────────────────────
const recycled = last('frame').buf;
await handle({ t: 'recycle', buf: recycled });
await handle({ t: 'run', quota: 1000 });
say(last('frame').buf === recycled, 'возвращённый буфер переиспользуется, а не выделяется заново');

// ── система действительно грузится ──────────────────────────────────────────
for (let i = 0; i < 14; i++) {
  await handle({ t: 'recycle', buf: last('frame').buf });
  await handle({ t: 'run', quota: 1000000 });
}
const fb = new Uint32Array(last('frame').buf);
let ink = 0;
for (const w of fb) ink += (w === 0 ? 0 : 1);
say(ink > 500, `на экране есть изображение (${ink} непустых слов из ${fb.length})`);

// ── ввод ────────────────────────────────────────────────────────────────────
const insBefore = last('frame').insns;
await handle({ t: 'chord', x: 100, y: 100, first: 4, then: 5, gap: 50000 });
await handle({ t: 'recycle', buf: last('frame').buf });
await handle({ t: 'run', quota: 1000 });
say(last('frame').insns - insBefore > 50000, 'аккорд даёт машине ход между двумя нажатиями');

await handle({ t: 'key', code: 0x1C });
await handle({ t: 'mouse', x: 10, y: 10, btn: 0 });
say(!last('error'), 'клавиатура и мышь принимаются');

// ── откат ───────────────────────────────────────────────────────────────────
const runFor = last('frame').insns;
await handle({ t: 'reset' });
const after = last('frame');
say(after.reset === true && after.insns < runFor, `откат возвращает машину в начало (${runFor} → ${after.insns})`);

// ── неизвестное сообщение ───────────────────────────────────────────────────
await handle({ t: 'таких-не-бывает' });
say(!!last('error'), 'неизвестное сообщение не проглатывается молча');

// ── лабораторные считаются рядом с машиной ───────────────────────────────────
// Проверка задания читает регистры, память и экран. Если бы она исполнялась на
// странице, через границу потока пришлось бы тянуть всё состояние целиком.
await handle({ t: 'check', id: 10, lab: 1, step: 0 });
const early = last('check');
say(early && early.ok === false, 'на пустой машине первый шаг лабы 1 не засчитан');

for (let i = 0; i < 14; i++) {
  await handle({ t: 'recycle', buf: last('frame').buf });
  await handle({ t: 'run', quota: 1000000 });
}
await handle({ t: 'check', id: 11, lab: 1, step: 0 });
const grown = last('check');
say(grown && grown.ok === true, `после загрузки засчитан: ${grown && grown.msg}`);

await handle({ t: 'poke', adr: 0x200, val: 0xC0FFEE });
await handle({ t: 'peek', id: 12, adr: 0x200 });
say((last('peek').word >>> 0) === 0xC0FFEE,
    `записанное слово читается обратно: ${(last('peek').word >>> 0).toString(16).toUpperCase()}`);

// ── второе железо ────────────────────────────────────────────────────────────
// Ядро с аппаратной проверкой границ обязано гонять ту же систему побитово
// так же: расширение системы команд, которое меняет поведение старого кода, —
// не расширение, а другая машина.
const out2 = [];
const handle2 = createHandler(msg => out2.push(msg));
const last2 = t => [...out2].reverse().find(m => m.t === t);
await handle2({ t: 'init', variant: 'chk', prom: new Uint32Array(prom).buffer, img: img.buffer });
say(last2('ready')?.variant === 'chk', 'поток поднимает выбранный вариант железа');
for (let i = 0; i < 15; i++) {
  await handle2({ t: 'run', quota: 1000000 });
  await handle2({ t: 'recycle', buf: last2('frame').buf });
}
await handle({ t: 'peek', id: 1 });
await handle2({ t: 'peek', id: 2 });
// Базовая машина к этому месту уже откачена, поэтому гоняем её столько же.
const outA = [];
const handleA = createHandler(m => outA.push(m));
const lastA = t => [...outA].reverse().find(m => m.t === t);
await handleA({ t: 'init', prom: new Uint32Array(prom).buffer, img: img.buffer });
for (let i = 0; i < 15; i++) {
  await handleA({ t: 'run', quota: 1000000 });
  await handleA({ t: 'recycle', buf: lastA('frame').buf });
}
await handleA({ t: 'peek', id: 3 });
const a = lastA('peek'), c = last2('peek');
say(a.crc === c.crc && a.insns === c.insns,
    `оба ядра грузят систему одинаково: CRC ${(a.crc >>> 0).toString(16).toUpperCase()}, ${a.insns} инструкций`);

console.log(bad ? `\n❌ протокол потока: ${bad} расхождений` : '\n✅ протокол рабочего потока цел');
process.exit(bad ? 1 : 0);
