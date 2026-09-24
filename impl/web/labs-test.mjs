// Безголовая проверка лабораторий: каждая обязана переходить из «не сделано»
// в «сделано» от предусмотренных действий. Лаборатория, проверка которой
// всегда зелёная или всегда красная, бесполезна и должна ломать сборку.
import fs from 'node:fs';
import { Machine } from './machine.js';
import { LABS } from './labs.js';
import { OberonFS, readText } from './oberonfs.js';

const prom = new Uint32Array(
  fs.readFileSync('prom_sd.mem', 'utf8').trim().split('\n').map(l => parseInt(l, 16)));
const img = new Uint8Array(fs.readFileSync('oberon.dsk'));

let bad = 0;
const say = (ok, s) => { console.log(`    ${ok ? '✅' : '❌'} ${s}`); if (!ok) bad++; };

async function lab(id, script) {
  const L = LABS.find(l => l.id === id);
  const m = await Machine.create(prom, img);
  console.log(`\n  Лаба ${L.id} «${L.title}» (${L.level})`);
  await script(m, L);
  return m;
}

// ── Лаба 1: смотреть ────────────────────────────────────────────────────────
await lab(1, async (m, L) => {
  say(!L.steps[0].check(m).ok, 'шаг 1 до загрузки — не пройден');
  for (let i = 0; i < 12; i++) m.run(1e6);
  const r1 = L.steps[0].check(m); say(r1.ok, 'шаг 1 после загрузки: ' + r1.msg);
  say(!L.steps[1].check(m).ok, 'шаг 2 до щелчка — не пройден');
  m.click(700, 461, 2);                       // средний щелчок по System.ShowModules
  for (let i = 0; i < 4; i++) m.run(1e6);
  const r2 = L.steps[1].check(m); say(r2.ok, 'шаг 2 после щелчка: ' + r2.msg);
});

// ── Лаба 4: ломать ──────────────────────────────────────────────────────────
await lab(4, async (m, L) => {
  for (let i = 0; i < 12; i++) m.run(1e6);
  say(!L.steps[0].check(m).ok, 'шаг 1 до порчи — не пройден');
  m.poke(0xE7F00, 0xFFFFFFFF);
  const r1 = L.steps[0].check(m); say(r1.ok, 'шаг 1 после порчи экрана: ' + r1.msg);
  say(!L.steps[1].check(m).ok, 'шаг 2 до порчи кода — не пройден');
  m.poke(m.pc, 0xE7FFFFFF);          // переход на самого себя по текущему адресу
  const r2 = L.steps[1].check(m); say(r2.ok, 'шаг 2 после порчи кода: ' + r2.msg);
  m.reset();
  for (let i = 0; i < 12; i++) m.run(1e6);
  say(m.fbCrc() === 0xB5DFC933, 'откат вернул машину в исходное состояние');
});

// ── Лаба 7: строить ─────────────────────────────────────────────────────────
await lab(7, async (m, L) => {
  for (let i = 0; i < 12; i++) m.run(1e6);
  const r1 = L.steps[0].check(m); say(r1.ok, 'шаг 1: ' + r1.msg);
  say(!L.steps[1].check(m).ok, 'шаг 2 до пересборки — не пройден');
  m.click(700, 620, 4);                       // левый щелчок: курсор в конец текста
  m.type('ORP.Compile Math.Mod/s ~');
  m.run(2e6);
  m.click(690, 569, 2);                       // средний щелчок по набранной команде
  for (let i = 0; i < 40; i++) m.run(1e6);
  const r2 = L.steps[1].check(m); say(r2.ok, 'шаг 2 после пересборки: ' + r2.msg);
});

// ── Лаба 5: измерять ────────────────────────────────────────────────────────
await lab(5, async (m, L) => {
  const ctx = { state: {}, answer: '' };
  say(!L.steps[0].check(m, ctx).ok, 'шаг 1 до загрузки — не пройден');
  for (let i = 0; i < 12; i++) m.run(1e6);
  say(L.steps[0].check(m, ctx).ok, 'шаг 1: отсчёт зафиксирован');
  ctx.answer = 'мусор';
  say(!L.steps[1].check(m, ctx).ok, 'шаг 2 с нечисловым ответом — не пройден');
  ctx.answer = '9.99';
  say(!L.steps[1].check(m, ctx).ok, 'шаг 2 с неверным числом — не пройден');
  ctx.answer = (m.cycles / m.insns).toFixed(2);
  const r2 = L.steps[1].check(m, ctx); say(r2.ok, 'шаг 2: ' + r2.msg);
  say(!L.steps[2].check(m, ctx).ok, 'шаг 3 до компиляции — не пройден');
  m.click(700, 620, 4); m.type('ORP.Compile Math.Mod/s ~'); m.run(2e6);
  m.click(690, 569, 2);
  for (let i = 0; i < 45; i++) m.run(1e6);
  ctx.answer = ((m.cycles - ctx.state.c0) / (m.insns - ctx.state.i0)).toFixed(2);
  const r3 = L.steps[2].check(m, ctx); say(r3.ok, 'шаг 3: ' + r3.msg);
});

// ── Лаба 6: куча внутри команды ─────────────────────────────────────────────
await lab(6, async (m, L) => {
  for (let i = 0; i < 12; i++) m.run(1e6);
  m.click(700, 620, 4);
  m.type('ORP.Compile ORS.Mod/s ORB.Mod/s ORG.Mod/s ORP.Mod/s PIO.Mod/s ~');
  m.run(2e6);
  m.click(690, 569, 2);
  for (let i = 0; i < 220; i++) m.run(1e6);
  const r1 = L.steps[0].check(m, {}); say(r1.ok, 'шаг 1: ' + r1.msg);
  say(!L.steps[1].check(m, {}).ok, 'шаг 2 до отдельной сборки — не пройден');
  m.type('\n');                                   // перевод строки
  m.type('ORP.Compile PIO.Mod/s ~'); m.run(2e6);
  m.click(690, 581, 2);
  for (let i = 0; i < 40; i++) m.run(1e6);
  const r2 = L.steps[1].check(m, {}); say(r2.ok, 'шаг 2: ' + r2.msg);
});

// ── Лаба 8: два поколения ───────────────────────────────────────────────────
await lab(8, async (m, L) => {
  const ctx = { state: {}, answer: '' };
  for (let i = 0; i < 12; i++) m.run(1e6);
  say(!L.steps[0].check(m, ctx).ok, 'шаг 1 до сборки — не пройден');
  m.click(700, 620, 4);
  m.type('ORP.Compile ORS.Mod/s ~'); m.type('\n');
  m.type('System.Free ORP ORG ORB ORS ~'); m.type('\n');
  m.type('ORP.Compile ORS.Mod/s ~'); m.run(2e6);
  m.click(690, 569, 2);
  for (let i = 0; i < 60; i++) m.run(1e6);
  const r1 = L.steps[0].check(m, ctx); say(r1.ok, 'шаг 1: ' + r1.msg);
  say(L.steps[1].check(m, ctx).ok, 'шаг 2: выгрузка объявлена');
  say(!L.steps[2].check(m, ctx).ok, 'шаг 3 до второй сборки — не пройден');
  m.click(685, 581, 2);                            // System.Free
  for (let i = 0; i < 10; i++) m.run(1e6);
  m.click(690, 593, 2);                            // вторая сборка
  for (let i = 0; i < 70; i++) m.run(1e6);
  const r3 = L.steps[2].check(m, ctx); say(r3.ok, 'шаг 3: ' + r3.msg);
});

// Набор текста через настоящий редактор. Проверяется сквозным кругом:
// строка -> скан-коды -> Оберон -> файл на диске -> обратно. Ловит класс
// ошибок, из-за которого текст сохраняется молча искажённым (так уже было:
// не набиралась закрывающая скобка, а файл при этом исправно создавался).
const EDIT = { open: [680, 569], area: [100, 60], store: [345, 6] };
async function makeFile(m, name, src) {
  m.click(700, 620, 4); m.type(`Edit.Open ${name} ~`); m.run(2e6);
  m.click(...EDIT.open, 2); for (let i = 0; i < 8; i++) m.run(1e6);
  m.click(...EDIT.area, 4); m.run(500000);
  m.type(src, 6000); m.run(2e6);
  m.click(...EDIT.store, 2); for (let i = 0; i < 10; i++) m.run(1e6);
}

// ── Лаба 2: первый свой модуль ──────────────────────────────────────────────
const HELLO = 'MODULE Hello;\n  VAR n*: INTEGER;\n  PROCEDURE Add*(x: INTEGER);\n  BEGIN n := n + x\n  END Add;\nBEGIN n := 0\nEND Hello.\n';
await lab(2, async (m, L) => {
  for (let i = 0; i < 12; i++) m.run(1e6);
  say(!L.steps[0].check(m, {}).ok, 'шаг 1 до набора — не пройден');
  await makeFile(m, 'Hello.Mod', HELLO);
  const r1 = L.steps[0].check(m, {}); say(r1.ok, 'шаг 1: ' + r1.msg);
  const back = readText(new OberonFS(m).read(new OberonFS(m).files().get('Hello.Mod')));
  say(back.trim() === HELLO.trim(), 'набранный текст совпал с исходником посимвольно');
  say(!L.steps[1].check(m, {}).ok, 'шаг 2 до компиляции — не пройден');
  m.click(700, 620, 4); m.type('\nORP.Compile Hello.Mod ~'); m.run(2e6);
  m.click(690, 581, 2); for (let i = 0; i < 25; i++) m.run(1e6);
  const r2 = L.steps[1].check(m, {}); say(r2.ok, 'шаг 2: ' + r2.msg);
});

// ── Лаба 3: ключ интерфейса ─────────────────────────────────────────────────
await lab(3, async (m, L) => {
  const c = { state: {} };
  for (let i = 0; i < 12; i++) m.run(1e6);
  const r1 = L.steps[0].check(m, c); say(r1.ok, 'шаг 1: ' + r1.msg);
  say(!L.steps[1].check(m, c).ok, 'шаг 2 до пересборки — не пройден');
  m.click(700, 620, 4); m.type('ORP.Compile Blink.Mod/s ~'); m.run(2e6);
  m.click(690, 569, 2); for (let i = 0; i < 30; i++) m.run(1e6);
  const r2 = L.steps[1].check(m, c); say(r2.ok, 'шаг 2: ' + r2.msg);
  const r3 = L.steps[2].check(m, c); say(r3.ok, 'шаг 3: ' + r3.msg);
});

// ── Лаба 9: внутри кодогенератора ───────────────────────────────────────────
const IDX = 'MODULE\nIdx;\n  VAR a: ARRAY 100 OF INTEGER;\n  PROCEDURE Sum*(n: INTEGER): INTEGER;\n    VAR i, s: INTEGER;\n  BEGIN s := 0; i := 0;\n    WHILE i < n DO s := s + a[i]; INC(i) END;\n    RETURN s\n  END Sum;\nEND Idx.\n';
await lab(9, async (m, L) => {
  const c = { state: {} };
  for (let i = 0; i < 12; i++) m.run(1e6);
  say(!L.steps[0].check(m, c).ok, 'шаг 1 до сборки — не пройден');
  await makeFile(m, 'Idx.Mod', IDX);
  m.click(700, 620, 4); m.type('\nORP.Compile Idx.Mod/s ~'); m.run(2e6);
  m.click(690, 581, 2); for (let i = 0; i < 25; i++) m.run(1e6);
  const r1 = L.steps[0].check(m, c); say(r1.ok, 'шаг 1: ' + r1.msg);
  say(!L.steps[1].check(m, c).ok, 'шаг 2 до звёздочки — не пройден');
  m.click(20, 37, 4); m.run(500000); m.type('*', 6000); m.run(1e6);
  m.click(...EDIT.store, 2); for (let i = 0; i < 8; i++) m.run(1e6);
  m.click(690, 581, 2); for (let i = 0; i < 30; i++) m.run(1e6);
  const r2 = L.steps[1].check(m, c); say(r2.ok, 'шаг 2: ' + r2.msg);
});

// ── статическая проверка страницы-оболочки ──────────────────────────────────
// Браузер здесь не поднять, поэтому хотя бы убеждаемся, что разметка и скрипт
// не разошлись: каждый getElementById должен находить свой элемент, а каждый
// импорт — существующий файл. Это ловит самую частую поломку — переименование.
{
  console.log('\n  Страница lab.html');
  const html = fs.readFileSync('lab.html', 'utf8');
  const ids = new Set([...html.matchAll(/id="([^"]+)"/g)].map(m => m[1]));
  const used = new Set([...html.matchAll(/\$\('([^']+)'\)/g)].map(m => m[1]));
  const missing = [...used].filter(x => !ids.has(x));
  say(missing.length === 0, missing.length
    ? `в разметке нет элементов: ${missing.join(', ')}`
    : `все ${used.size} обращений к элементам находят свой id`);
  const imports = [...html.matchAll(/from '(\.[^']+)'/g)].map(m => m[1]);
  const lost = imports.filter(f => !fs.existsSync(f));
  say(lost.length === 0, lost.length ? `нет файлов: ${lost.join(', ')}` : `импорты на месте: ${imports.join(', ')}`);
  const labIds = LABS.map(l => l.id);
  say(new Set(labIds).size === labIds.length, `номера лабораторий уникальны: ${labIds.join(', ')}`);
  for (const L of LABS) {
    const bads = L.steps.filter(s => typeof s.check !== 'function' || !s.text);
    say(bads.length === 0, `лаба ${L.id}: ${L.steps.length} шагов, у каждого есть текст и проверка`);
    // Ссылка на главу методички, которой нет, выглядит рабочей — поэтому проверяем.
    const lost = (L.read || []).filter(([f]) => !fs.existsSync('book/' + f));
    say(lost.length === 0, lost.length
      ? `лаба ${L.id}: нет глав ${lost.map(x => x[0]).join(', ')}`
      : `лаба ${L.id}: ссылки на методичку ведут в существующие главы`);
  }
}

console.log(bad ? `\n❌ провалов: ${bad}` : '\n✅ все лаборатории проходят свой сценарий');
process.exit(bad ? 1 : 0);
