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
  foo_t f = { 0, "lol", 0, { 0 }, &foo };
  foo_t h = { 1100, "baz", &f, { 0 }, &foo };
  foo_t g = { 1000, "bar", &h, { 0 }, NULL };

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
