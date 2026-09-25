#!/usr/bin/env python3
"""Заводит архитектуру RISC5 в libvirt.

Четыре места, и они связаны: вторая таблица индексируется значениями первой,
третья защищена проверкой совпадения длины с ней, а четвёртое — разбор случаев,
который собирается с требованием явной ветки для каждой архитектуры.

⚠ Каждая замена проверяется. Молча не применившийся патч хуже отсутствующего:
libvirt соберётся, но архитектуры знать не будет, и искать причину придётся
в рантайме.

Накладывается из корня дерева libvirt:  python3 patch_libvirt.py
"""
import pathlib
import sys

# Последнее поле — обязательна ли правка. Разбор случаев по архитектуре в
# драйвере QEMU был в libvirt 10, а к 11.9 его переписали на вспомогательные
# функции, и ветка стала не нужна. Остальные три обязательны в обеих версиях.
EDITS = [
    # файл, что ищем, на что заменяем, зачем, обязательна ли
    ('src/util/virarch.h',
     '    VIR_ARCH_RISCV32,',
     '    VIR_ARCH_RISC5,        /* Wirth RISC5 32 LE http://www.projectoberon.net/ */\n'
     '    VIR_ARCH_RISCV32,',
     'значение в перечне архитектур', True),

    ('src/util/virarch.c',
     '    { "riscv32",      32, VIR_ARCH_LITTLE_ENDIAN },',
     '    { "risc5",        32, VIR_ARCH_LITTLE_ENDIAN },\n'
     '    { "riscv32",      32, VIR_ARCH_LITTLE_ENDIAN },',
     'имя, разрядность, порядок байтов', True),

    ('src/qemu/qemu_capabilities.c',
     '    "virt", /* VIR_ARCH_RISCV32 */',
     '    "oberon", /* VIR_ARCH_RISC5 */\n'
     '    "virt", /* VIR_ARCH_RISCV32 */',
     'машина по умолчанию для драйвера QEMU', True),

    ('src/qemu/qemu_domain.c',
     '    case VIR_ARCH_RISCV32:',
     '    case VIR_ARCH_RISC5:\n'
     '    case VIR_ARCH_RISCV32:',
     'ветка в разборе случаев по архитектуре (libvirt 10)', False),

    # В 11.x разбор переехал сюда. Место находит сам компилятор: сборка идёт
    # с -Werror=switch-enum, и пропущенная ветка её останавливает.
    ('src/qemu/qemu_postparse.c',
     '    case VIR_ARCH_RISCV32:',
     '    case VIR_ARCH_RISC5:\n'
     '    case VIR_ARCH_RISCV32:',
     'ветка в разборе случаев по архитектуре (libvirt 11)', False),

    # ⚠ Для незнакомой архитектуры libvirt по умолчанию считает, что PCI есть
    # (qemuDomainSupportsPCI: особые случаи только для ARM и RISC-V, дальше
    # `return true`). У машины Вирта шины PCI нет вовсе, и без этой правки
    # libvirt требует контроллер, которого не может быть:
    # «Machine type 'oberon' supports PCI but no PCI controller added».
    ('src/qemu/qemu_domain.c',
     '    /* On RISC-V, only the virt machine type supports PCI */',
     '    /* Wirth\'s RISC5 has no PCI bus at all */\n'
     '    if (def->os.arch == VIR_ARCH_RISC5)\n'
     '        return false;\n'
     '\n'
     '    /* On RISC-V, only the virt machine type supports PCI */',
     'у RISC5 нет шины PCI', False),
]


def main():
    applied = skipped = absent = 0
    for path, old, new, why, required in EDITS:
        p = pathlib.Path(path)
        if not p.is_file():
            sys.exit(f'нет файла {path} — это точно дерево libvirt?')
        t = p.read_text()
        if 'VIR_ARCH_RISC5' in t:
            print(f'  = {path}: уже пропатчен ({why})')
            skipped += 1
            continue
        if old not in t:
            if required:
                sys.exit(f'не нашёл место в {path} — исходники изменились ({why})')
            print(f'  ~ {path}: места нет, и это норма для новых версий ({why})')
            absent += 1
            continue
        p.write_text(t.replace(old, new, 1))
        print(f'  + {path}: {why}')
        applied += 1

    print(f'наложено {applied}, уже было {skipped}, неприменимо {absent}')
    if applied == 0 and skipped == 0:
        sys.exit('патч не сделал ничего — так быть не должно')


if __name__ == '__main__':
    main()
