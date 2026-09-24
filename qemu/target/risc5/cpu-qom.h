/* SPDX-License-Identifier: GPL-2.0-or-later */
#ifndef QEMU_RISC5_CPU_QOM_H
#define QEMU_RISC5_CPU_QOM_H

#include "hw/core/cpu.h"
#include "qom/object.h"

#define TYPE_RISC5_CPU "risc5-cpu"

OBJECT_DECLARE_CPU_TYPE(RISC5CPU, RISC5CPUClass, RISC5_CPU)

struct RISC5CPUClass {
    CPUClass parent_class;

    DeviceRealize parent_realize;
    ResettablePhases parent_phases;
};

#endif
