#!/bin/sh
# Компилирует модули Оберона и запускает команду.
#
# Исходники приходят только на чтение (это ConfigMap), поэтому копируем их к
# себе: компилятор кладёт .rsc и .smb рядом с .Mod.
#
#   oberon-run <Модуль.Mod> [ещё.Mod ...] -- <Модуль.Команда> [аргументы]
#
# Без «--» всё считается модулями, и после сборки запускается первая команда
# вида <Первый>.Go, если она есть.
set -e
SRC=${SRCDIR:-/src}
LIB=/opt/oberon
export NOREBO_PATH="$PWD:$LIB/Norebo:$LIB/Oberon:$LIB/build2"

[ -d "$SRC" ] && cp -f "$SRC"/*.Mod . 2>/dev/null || true

mods=""
cmd=""
seen_sep=0
for a in "$@"; do
  if [ "$a" = "--" ]; then seen_sep=1; continue; fi
  if [ "$seen_sep" = 1 ]; then cmd="$cmd $a"; else mods="$mods $a"; fi
done
[ -n "$mods" ] || mods=$(ls *.Mod 2>/dev/null | tr '\n' ' ')

if [ -n "$mods" ]; then
  # Ключ /s разрешает компилятору обновить символьный файл.
  args=""
  for m in $mods; do args="$args $m/s"; done
  # shellcheck disable=SC2086
  norebo ORP.Compile $args
fi

if [ -z "$cmd" ]; then
  first=$(echo $mods | awk '{print $1}' | sed 's/\.Mod$//')
  [ -n "$first" ] && cmd="$first.Go"
fi
[ -n "$cmd" ] || { echo "нечего запускать: не задана команда"; exit 2; }
# shellcheck disable=SC2086
exec norebo $cmd
