#include "libhello.h"
#include <stdio.h>

int main() {
  printf("[message from rust lib]\n%s\n\n", hello());
  return 0;
}
