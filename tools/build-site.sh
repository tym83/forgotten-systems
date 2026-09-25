#!/usr/bin/env bash
#
# Сборка статического сайта серии в _site/.
#
# Один источник на каждый файл:
#   site/**       — страницы серии (свои, правятся руками)
#   impl/web/**   — лаборатория, методичка и собранная машина
#
# ⚠ Копий impl/web/ в site/oberon/ больше нет, и заводить их нельзя. Такая
# копия однажды устарела молча: методичку и лабораторию перевели на английский,
# а на сайте осталась прежняя версия, и /oberon/book/en/ отдавал 404. Два
# места, из которых обновляется одно, — та же ловушка, что и во всём остальном
# в этом репозитории, только тихая: страницы-то открывались.
#
# impl/web/index.html — страница запуска машины; на сайте она лежит как
# run.html, потому что /oberon/ занят страницей проекта из site/.
#
# Использование: tools/build-site.sh [каталог-назначения]
set -euo pipefail
cd "$(dirname "$0")/.."
out=${1:-_site}

# Файлы разработки в раздачу не едут: прогон лабораторных и генератор методички.
DEV='\.mjs$|(^|/)mkbook\.py$'

# copy_tree <откуда> <куда> [regex исключений]
copy_tree() {
  local src=$1 dst=$2 skip=${3:-} rel
  ( cd "$src" && find . -type f ) | sed 's|^\./||' | sort | while read -r rel; do
    if [ -n "$skip" ] && printf '%s\n' "$rel" | grep -Eq "$skip"; then continue; fi
    mkdir -p "$dst/$(dirname "$rel")"
    cp "$src/$rel" "$dst/$rel"
  done
}

mkdir -p "$out/oberon"
copy_tree site "$out" '^oberon/'
cp site/oberon/index.html "$out/oberon/index.html"
copy_tree impl/web "$out/oberon" "$DEV|^index\.html$"
cp impl/web/index.html "$out/oberon/run.html"

# Обязательный состав. Пустой файл — тоже отсутствие: собранный wasm умеет
# получиться нулевым, и один раз уже получился.
need="index.html style.css ru/index.html ru/oberon/index.html
      oberon/index.html oberon/run.html oberon/lab.html oberon/embed.html
      oberon/i18n.js oberon/labs.js oberon/labs.en.js
      oberon/machine.js oberon/oberonfs.js
      oberon/risc5.js oberon/risc5.wasm oberon/oberon.dsk oberon/oberon.dsk.gz
      oberon/prom_sd.mem oberon/embed.js oberon/worker.js oberon/worker-core.js
      oberon/book/index.html oberon/book/en/index.html"
miss=0
for f in $need; do
  if [ -s "$out/$f" ]; then printf '  ✅ %s\n' "$f"; else printf '  ❌ нет или пусто: %s\n' "$f"; miss=1; fi
done
[ "$miss" = 0 ] || { echo "сайт неполный"; exit 1; }

# Проверка местных ссылок. Именно её отсутствие дало живой 404: страницы
# раскладывались, а /oberon/book/en/ вёл в пустоту.
python3 - "$out" <<'PY'
import os, re, sys, urllib.parse
root = sys.argv[1]
ref = re.compile(r'(?:href|src)\s*=\s*["\']([^"\']+)["\']', re.I)
bad = []
for dirpath, _, files in os.walk(root):
    for name in files:
        if not name.endswith('.html'):
            continue
        path = os.path.join(dirpath, name)
        with open(path, encoding='utf-8', errors='replace') as fh:
            text = fh.read()
        for raw in ref.findall(text):
            if re.match(r'^(https?:|mailto:|data:|#|//)', raw):
                continue
            # Адрес, собираемый на месте (`book/${LANG...}`), проверить нечем.
            if '${' in raw or '{{' in raw:
                continue
            target = urllib.parse.unquote(raw.split('#')[0].split('?')[0])
            if not target:
                continue
            base = root if target.startswith('/') else dirpath
            dest = os.path.normpath(os.path.join(base, target.lstrip('/')))
            if os.path.isdir(dest):
                dest = os.path.join(dest, 'index.html')
            if not os.path.exists(dest):
                bad.append(f"{os.path.relpath(path, root)} → {raw}")
if bad:
    print("  ❌ битые местные ссылки:")
    for b in bad:
        print("    " + b)
    sys.exit(1)
print("  ✅ местные ссылки")
PY

echo "  сайт собран в $out/ ($(find "$out" -type f | wc -l | tr -d ' ') файлов)"
