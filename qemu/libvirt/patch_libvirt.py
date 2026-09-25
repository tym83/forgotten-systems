#!/usr/bin/env python3
"""Заводит архитектуру RISC5 в libvirt.

Три таблицы, и они связаны: вторая индексируется значениями первой, третья
защищена проверкой совпадения длины с первой. Поэтому порядок строк обязан
совпадать, а забыть третью сборка не даст.
"""
import pathlib, sys

# 1. Перечень архитектур.
h = pathlib.Path('src/util/virarch.h'); t = h.read_text()
if 'VIR_ARCH_RISC5' in t:
    print('уже пропатчено'); sys.exit(0)
t = t.replace(
    '    VIR_ARCH_RISCV32,',
    '    VIR_ARCH_RISC5,        /* Wirth RISC5 32 LE http://www.projectoberon.net/ */\n'
    '    VIR_ARCH_RISCV32,', 1)
h.write_text(t)

# 2. Свойства: имя, разрядность, порядок байтов.
c = pathlib.Path('src/util/virarch.c'); t = c.read_text()
t = t.replace(
    '    { "riscv32",      32, VIR_ARCH_LITTLE_ENDIAN },',
    '    { "risc5",        32, VIR_ARCH_LITTLE_ENDIAN },\n'
    '    { "riscv32",      32, VIR_ARCH_LITTLE_ENDIAN },', 1)
c.write_text(t)

# 3. Машина по умолчанию в драйвере QEMU.
q = pathlib.Path('src/qemu/qemu_capabilities.c'); t = q.read_text()
t = t.replace(
    '    "virt", /* VIR_ARCH_RISCV32 */',
    '    "oberon", /* VIR_ARCH_RISC5 */\n'
    '    "virt", /* VIR_ARCH_RISCV32 */', 1)
q.write_text(t)
print('патч наложен на три таблицы')

# 4. Разбор случаев по архитектуре в драйвере QEMU.
#
# Компилятор требует явную ветку для каждой архитектуры (-Werror=switch-enum) —
# и это хорошо: он сам показал место, которое иначе пропустили бы. Встаём рядом
# с RISCV32: у нашей машины тоже нет ни корневого моста PCI, ни USB, ни прочей
# обвязки, которую эти ветки добавляют.
d = pathlib.Path('src/qemu/qemu_domain.c'); t = d.read_text()
if 'VIR_ARCH_RISC5' not in t:
    t = t.replace('    case VIR_ARCH_RISCV32:',
                  '    case VIR_ARCH_RISC5:\n    case VIR_ARCH_RISCV32:', 1)
    d.write_text(t)
    print('ветка в разборе случаев добавлена')
