/*
 * Ответы на запросы наблюдателя для машины RISC5.
 *
 * Нужен ровно один: query-cpu-definitions. Наша цель его не поддерживала, и
 * libvirt на отказ отвечал обращением по нулевому указателю — падал вместо
 * внятной ошибки. Отказ был честным (вариантов ядра у машины нет), но дешевле
 * ответить, чем править чужой код.
 *
 * Модель здесь ровно одна и всегда будет одна: у Вирта не было ни поколений
 * ядра, ни признаков, которые можно включать и выключать. Перечисляем то, что
 * уже есть как тип объекта.
 *
 * ⚠ Определять приходится ОБЕ функции, а не только нужную. Заглушка на этот
 * случай лежит в одном объектном файле (stubs/qmp-cpu.c), и линковщик тянет
 * его целиком, если хоть один её символ остался неперекрытым. Так же поступает
 * цель riscv.
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */
#include "qemu/osdep.h"
#include "qemu/target-info.h"
#include "qapi/error.h"
#include "qapi/qapi-commands-machine.h"
#include "cpu.h"

static void risc5_cpu_add_definition(gpointer data, gpointer user_data)
{
    ObjectClass *oc = data;
    CpuDefinitionInfoList **cpu_list = user_data;
    CpuDefinitionInfo *info = g_new0(CpuDefinitionInfo, 1);
    const char *typename = object_class_get_name(oc);

    info->name = cpu_model_from_type(typename);
    info->q_typename = g_strdup(typename);

    QAPI_LIST_PREPEND(*cpu_list, info);
}

CpuDefinitionInfoList *qmp_query_cpu_definitions(Error **errp)
{
    CpuDefinitionInfoList *cpu_list = NULL;
    GSList *list = object_class_get_list(target_cpu_type(), false);

    g_slist_foreach(list, risc5_cpu_add_definition, &cpu_list);
    g_slist_free(list);

    return cpu_list;
}

/*
 * Раскрытие модели — перечислить признаки, которые даёт выбранная модель.
 * У нашей машины признаков нет вообще, поэтому отказываем честно. Функция
 * нужна, чтобы не подтянулась заглушка целиком (см. выше).
 */
CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
                                                     CpuModelInfo *model,
                                                     Error **errp)
{
    error_setg(errp, "У RISC5 одна модель процессора и она без признаков");
    return NULL;
}
