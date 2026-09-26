#!/bin/sh
# Сборка образа virt-launcher с машиной RISC5.
#
#   kubevirt/build.sh <образ:тег> [аргументы docker build...]
#
# Коммит QEMU берётся из qemu/Makefile — того же места, откуда его берут
# проверки. Иначе в кластер уезжает не та машина, что сверена с RTL.
set -eu
ROOT=$(cd "$(dirname "$0")/.." && pwd)
IMAGE="${1:?укажите образ:тег}"; shift

QEMU_REF=$(sed -n 's/^QEMU_REF ?= *//p' "$ROOT/qemu/Makefile")
[ -n "$QEMU_REF" ] || { echo "в qemu/Makefile не найден QEMU_REF" >&2; exit 1; }
echo "QEMU: $QEMU_REF"

exec docker build -f "$ROOT/kubevirt/Containerfile" \
  --build-arg QEMU_REF="$QEMU_REF" -t "$IMAGE" "$@" "$ROOT"
