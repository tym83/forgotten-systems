// Сборка страниц: что скрипт ищет в разметке — там и есть.
//
// Эти поломки браузер не показывает ошибкой: страница открывается, а кнопка
// молча ничего не делает. Уже стоило двух заходов отладки — `data-i18n-en` на
// <label>, который съедал вложенный <select>, и переезд лаборатории на
// компонент, где часть узлов сменила имена.
import fs from 'node:fs';
import path from 'node:path';

const PAGES = ['lab.html', 'index.html', 'checks.html', 'embed.html'];
let bad = 0;
const say = (ok, s) => { console.log(`  ${ok ? '✅' : '❌'} ${s}`); if (!ok) bad++; };

for (const page of PAGES) {
  const src = fs.readFileSync(page, 'utf8');
  const ids = new Set([...src.matchAll(/\sid="([^"]+)"/g)].map(m => m[1]));

  // 1. Каждый узел, который ищет скрипт, должен быть в разметке.
  const used = new Set([...src.matchAll(/\$\('([^']+)'\)|getElementById\('([^']+)'\)/g)]
    .map(m => m[1] || m[2]));
  const missing = [...used].filter(id => !ids.has(id));
  say(missing.length === 0,
      `${page}: все узлы на месте (${used.size} использованных)` +
      (missing.length ? ` — нет: ${missing.join(', ')}` : ''));

  // 2. Перевод разметкой заменяет содержимое ЦЕЛИКОМ. Значит на элементе с
  //    вложенным управляющим узлом его быть не может — иначе перевод его съест.
  const swallow = [...src.matchAll(/<(label|div)\b[^>]*\sdata-i18n-[a-z]{2}="[^"]*"[^>]*>([\s\S]*?)<\/\1>/g)]
    .filter(m => /<(select|input|button|canvas|oberon-machine)\b/.test(m[2]));
  say(swallow.length === 0,
      `${page}: перевод не проглатывает управляющие узлы` +
      (swallow.length ? ` — ${swallow.length} шт.` : ''));

  // 3. Импорты модулей ведут в существующие файлы.
  const imports = [...src.matchAll(/from\s+'(\.\/[^']+)'|import\s+'(\.\/[^']+)'/g)]
    .map(m => m[1] || m[2]);
  const lost = imports.filter(f => !fs.existsSync(path.resolve(f)));
  say(lost.length === 0,
      `${page}: импорты на месте (${imports.length})` + (lost.length ? ` — нет: ${lost.join(', ')}` : ''));
}

console.log(bad ? `\n❌ разметка страниц: ${bad} расхождений` : '\n✅ разметка страниц и скрипты сходятся');
process.exit(bad ? 1 : 0);
