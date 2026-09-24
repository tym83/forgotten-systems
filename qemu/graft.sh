#!/bin/sh
# Вживляет цель RISC5 в дерево QEMU.
#
# Цели у QEMU вкомпилированы: недостаточно положить файлы, надо ещё
# заявить цель в четырёх местах. Поэтому это скрипт, а не список шагов в
# голове — иначе сборка невоспроизводима.
#
#   graft.sh <каталог-с-деревом-qemu>
set -eu
Q="${1:?укажите каталог с деревом QEMU}"
HERE=$(cd "$(dirname "$0")" && pwd)

cp -a "$HERE/target/risc5"               "$Q/target/"
cp -a "$HERE/hw/risc5"                   "$Q/hw/"
cp    "$HERE/configs/targets/risc5-softmmu.mak" "$Q/configs/targets/"
cp -a "$HERE/configs/devices/risc5-softmmu"     "$Q/configs/devices/"

add_once() {  # файл, что искать, чем заменить
  grep -q "$3" "$1" || sed -i.bak "s|$2|$3\\n$2|" "$1"
  rm -f "$1.bak"
}

add_once "$Q/target/meson.build" "subdir('riscv')"      "subdir('risc5')"
add_once "$Q/target/Kconfig"     "source riscv/Kconfig"  "source risc5/Kconfig"
add_once "$Q/hw/meson.build"     "subdir('riscv')"       "subdir('risc5')"
add_once "$Q/hw/Kconfig"         "source riscv/Kconfig"  "source risc5/Kconfig"

# Перечень целей в QAPI — иначе target-info не соберётся.
grep -q "'risc5'" "$Q/qapi/machine.json" || \
  sed -i.bak "s|'ppc64', 'riscv32'|'ppc64', 'risc5', 'riscv32'|" "$Q/qapi/machine.json"
rm -f "$Q/qapi/machine.json.bak"

echo "цель risc5 вживлена в $Q"
