#define _GNU_SOURCE
#include <stdio.h>
#include "utstring.h"
#include "dwarfpp.h"
#include "dlfcn.h"

dwarf_pp_context_t * dwarf_pp_context_new()
{
  dwarf_pp_context_t * c = calloc(sizeof(*c), 1);
  utstring_new(c->s);

  return c;
}

int dwarf_pp_context_add(dwarf_pp_context_t * c, void * func, void * obj)
{
  dwarf_seen_t * node;
  void * key[2] = { func, obj };

  HASH_FIND(hh, c->lookup, key, sizeof(key), node);

  if (node) {
    return 0;
  }

  node = calloc(sizeof(*node), 1);
  node->key[0] = func;
  node->key[1] = obj;

  HASH_ADD_KEYPTR(hh, c->lookup, node->key, sizeof(key), node);

  return 1;
}

void dwarf_pp_context_destroy(dwarf_pp_context_t * c)
{
  dwarf_seen_t * ele, * tmp;

  HASH_ITER(hh, c->lookup, ele, tmp) {
    HASH_DEL(c->lookup, ele);
    free(ele);
  }

  utstring_free(c->s);
  free(c);
}

char * dwarfpp(void * obj, char * type)
{
  void * handle = dlopen("./dwarfparse.so", RTLD_LAZY);

  if (! handle) {
    return NULL;
  }

  char * string;
  asprintf(&string, "dwarfparser_%s", type);
  void (* fun)(dwarf_pp_context_t * c, void * data) = dlsym(handle, string);

  free(string);

  if (! fun) {
    return NULL;
  }

  dwarf_pp_context_t * c = dwarf_pp_context_new();
  fun(c, obj);

  char * out = strdup(utstring_body(c->s));

  dwarf_pp_context_destroy(c);

  return out;
}
