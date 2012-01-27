#include <stdint.h>

typedef struct foo {
  int bar;
  char * baz;
  struct foo * foo_next;
  int stuff[3];
  int (*fun)(char *);
  float f;
  double d;
  uint32_t ui32;
  uint64_t ui64;
  short s;
  unsigned char uc;
  signed char c;
} foo_t;
