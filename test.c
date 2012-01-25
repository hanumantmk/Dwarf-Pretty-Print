#include <stdio.h>
#include "test.h"
#include "dwarfpp.h"

int main()
{
  foo_t f = { 0, "lol", 0 };
  foo_t g = { 1000, "bar", &f };

  f.bar = 10;

  char * foo = dwarfpp(&g, "foo_t");

  if (foo) {
    printf("%s\n", foo);
  } else {
    printf("no symbol\n");
  }

  return 0;
}
