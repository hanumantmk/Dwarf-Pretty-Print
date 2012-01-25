#include <stdio.h>
#include "utstring.h"
#include "dwarfpp.h"
#include "dlfcn.h"

char * dwarfpp(void * obj, char * type)
{
  void * handle = dlopen("./dwarfparse.so", RTLD_LAZY);

  if (! handle) {
    return NULL;
  }

  UT_string * s;
  utstring_new(s);
  utstring_printf(s, "dwarfparser_%s", type);

  void (* fun)(UT_string * s, void * data) = dlsym(handle, utstring_body(s));

  if (! fun) {
    return NULL;
  }

  utstring_clear(s);

  fun(s, obj);

  char * out = strdup(utstring_body(s));

  utstring_free(s);

  return out;
}
