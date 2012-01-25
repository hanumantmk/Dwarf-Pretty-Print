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
  foo_t g = { 1000, "bar", &f, { 0 }, NULL };

  f.bar = 10;

  char * foo = dwarfpp(&g, "foo_t");

  if (foo) {
    printf("%s\n", foo);
  } else {
    printf("no symbol\n");
  }

  return 0;
}
