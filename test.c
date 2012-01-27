#include <stdio.h>
#include <string.h>
#include "test.h"
#include "dwarfpp.h"

int foo(char * c)
{
  return (int)(*c);
}

int main()
{
  uint64_t l = 1;
  l <<= 45;
  foo_t f = { 0, "lol", 0, { 0 }, &foo, 0, 0, 1231, 1211111, -21, 200, -66 };
  foo_t h = { 1100, "baz", &f, { 0 }, &foo, 1.1, 2121323112.2132, 13212, 13212332, 55, 0, 120 };
  foo_t g = { 1000, "bar", &h, { 0 }, NULL, 110000.2312, 122.11, 2312, l, 321, 11, 0 };

  f.bar = 10;
  f.foo_next = &g;

  char * foo = dwarfpp(&g, "foo_t");

  if (foo) {
    printf("%s\n", foo);
  } else {
    printf("no symbol\n");
  }

  return 0;
}
