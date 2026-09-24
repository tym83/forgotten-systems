#include "risc.h"
#include "disk.h"
#include <stdio.h>
#include <string.h>
int main(int argc, char** argv) {
  struct RISC* r = risc_new();
  risc_set_serial(r, NULL);
  risc_set_spi(r, 1, disk_new(argv[1]));
  long total = 0;
  for (int i = 0; i < 400; i++) {
    risc_run(r, 1000000); total += 1000000;
    uint32_t* fb = risc_get_framebuffer_ptr(r);
    uint32_t sum = 0;
    for (int k = 0; k < 1024*768/32; k++) sum += fb[k];
    if (sum != 0) { printf("кадровый буфер непустой после %ld млн инструкций, сумма %08X\n", total/1000000, sum); return 0; }
  }
  printf("кадровый буфер пуст после %ld инструкций\n", total);
  return 1;
}
