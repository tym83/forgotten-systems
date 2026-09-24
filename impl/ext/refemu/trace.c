#include "risc.h"
#include "disk.h"
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char** argv) {
  struct RISC* r = risc_new();
  risc_set_serial(r, NULL);
  risc_set_spi(r, 1, disk_new(argv[1]));
  int n = argc > 2 ? atoi(argv[2]) : 60;
  for (int i = 0; i < n; i++) { printf("[%5d] PC=%06X\n", i, risc_get_pc(r) * 4); risc_run(r, 1); }
  return 0;
}
