// Рантайм Verilator тянет функции привязки потоков к ядрам, которых нет в
// wasm-sysroot. Ревью предупреждало ровно об этом. Сигнатуры должны совпадать
// с теми, что видит verilated.cpp, иначе wasm-ld ругается на несовпадение типов.
#include <cerrno>
extern "C" {
int pthread_getaffinity_np(unsigned long, unsigned long, void*) { return ENOSYS; }
int pthread_setaffinity_np(unsigned long, unsigned long, const void*) { return ENOSYS; }
int sched_getcpu(void) { return 0; }
}
