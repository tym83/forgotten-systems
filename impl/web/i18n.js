/*
 * Выбор языка для лабораторий и оболочки.
 *
 * По умолчанию английский: это то, что увидит человек, пришедший со стороны.
 * Русский включается явно — переключателем или `?lang=ru` в адресе, и выбор
 * запоминается.
 *
 * Тексты хранятся объектами `{en, ru}`. Обычная строка тоже допустима: она
 * считается одинаковой на всех языках. Это позволяет переводить постепенно и
 * не ломать то, что ещё не переведено.
 */
export const LANGS = { en: 'English', ru: 'Русский' };

const KEY = 'paleo.lang';

function pick() {
  // Вне браузера (безголовый прогон лабораторных в node) выбирать нечем и не
  // из чего: `location` там нет вовсе, и обращение к нему валит весь набор
  // тестов ещё до первой проверки.
  if (typeof location === 'undefined') return 'en';
  const q = new URLSearchParams(location.search).get('lang');
  if (q && q in LANGS) return q;
  try {
    const s = localStorage.getItem(KEY);
    if (s && s in LANGS) return s;
  } catch { /* приватный режим — просто берём язык по умолчанию */ }
  return 'en';
}

export let LANG = pick();

export function setLang(code) {
  if (!(code in LANGS)) return;
  LANG = code;
  try { localStorage.setItem(KEY, code); } catch { /* не беда */ }
  location.reload();
}

/**
 * Достаёт текст на текущем языке.
 * Если перевода нет — отдаёт английский, потом русский, потом что есть.
 */
export function t(v) {
  if (v == null) return '';
  if (typeof v === 'string') return v;
  return v[LANG] ?? v.en ?? v.ru ?? '';
}

/** Перевод всех подписей в разметке: <span data-i18n-en="..." data-i18n-ru="..."> */
export function applyMarkup(root = document) {
  // Язык документа и заголовок вкладки. На самой странице их не видно, поэтому
  // они и оставались русскими, когда языком по умолчанию стал английский, —
  // а видит их закладка, превью ссылки в мессенджере, поиск и экранная читалка.
  if (typeof document !== 'undefined' && (root === document || root === document.documentElement)) {
    document.documentElement.lang = LANG;
  }
  root.querySelectorAll('[data-i18n-' + LANG + ']').forEach(el => {
    el.innerHTML = el.getAttribute('data-i18n-' + LANG);
  });
  root.querySelectorAll('[data-i18n-ph-' + LANG + ']').forEach(el => {
    el.placeholder = el.getAttribute('data-i18n-ph-' + LANG);
  });
}
