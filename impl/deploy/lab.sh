#!/bin/sh
# Запуск лабораторной как пакетного задания: на входе — правка, на выходе вердикт.
#
# Правка подаётся каталогом /work: файлы оттуда накладываются поверх дерева.
# Так лабораторная не требует ни гита, ни сети — только том с изменёнными файлами.
set -e
cd /lab

apply() {
  [ -d /work ] || return 0
  found=0
  # Скобки обязательны: без них -o перехватывает -type f, и find отдаёт лишнее.
  for f in $(cd /work && find . -type f \( -name '*.v' -o -name '*.s' \
             -o -name '*.Mod' -o -name '*.py' -o -name '*.cpp' -o -name '*.h' \) 2>/dev/null); do
    mkdir -p "$(dirname "$f")"
    cp "/work/$f" "$f"
    echo "  наложено: $f"
    found=1
  done
  [ $found -eq 1 ] || echo "  правок в /work нет — прогон на исходном дереве"
}

case "${1:-help}" in
  help)
    cat <<'TXT'
Лабораторные на хосте. Использование:

  lab check        полная проверка: тесты, загрузка системы, дифференциальный
                   стенд, самораскрутка, пересборка системы
  lab isa          лабораторная 11: своя команда в процессоре.
                   Положите изменённые rtl/*.v и tests/*.s в /work
  lab compiler     лабораторная 10: своя встроенная процедура.
                   Положите изменённый ext/norebo/... или *.Mod в /work
  lab shell        оболочка внутри образа

Правки подаются томом: -v "$PWD/mywork:/work"
TXT
    ;;
  check)   apply; exec make check ;;
  isa)
    apply
    echo; echo "── проверка команд процессора ──"
    make test
    echo; echo "── эквивалентность декодера ──"
    make equiv
    ;;
  compiler)
    apply
    echo; echo "── самораскрутка компилятора на RTL ──"
    exec make selfhost
    ;;
  shell)   shift; exec /bin/sh "$@" ;;
  *)       echo "неизвестная команда: $1" >&2; exit 2 ;;
esac
