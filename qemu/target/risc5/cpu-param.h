/*
 * Параметры машины RISC5 для QEMU.
 *
 * Значения взяты из RISC5.v и RISC5Top.v Никлауса Вирта, а не из описаний:
 *   RISC5.v:13      reg [21:0] PC        счётчик команд — 22 бита В СЛОВАХ
 *   RISC5Top.v:39   wire [23:0] adr      адресная шина — 24 бита, байтовая
 *
 * Отсюда адресное пространство ровно 16 МБ. Слово 32 бита, выравнивание по
 * слову: счётчик команд считает слова, поэтому байтовый адрес есть PC * 4.
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
#ifndef RISC5_CPU_PARAM_H
#define RISC5_CPU_PARAM_H

#define TARGET_LONG_BITS            32
#define TARGET_PAGE_BITS            12
#define TARGET_PHYS_ADDR_SPACE_BITS 24
#define TARGET_VIRT_ADDR_SPACE_BITS 24

/*
 * Блока управления памятью у машины нет: физический адрес равен
 * виртуальному, привилегий и трансляции не существует. Это не упрощение
 * нашей модели, а свойство железа — см. лабораторную «Защиты памяти здесь
 * нет».
 */
#endif
