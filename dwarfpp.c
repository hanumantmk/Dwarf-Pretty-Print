#define _GNU_SOURCE
#include <stdio.h>
#include "utstring.h"
#include "dwarfpp.h"
#include "dlfcn.h"

dwarf_pp_context_t * dwarf_pp_context_new()
{
  dwarf_pp_context_t * c = calloc(sizeof(*c), 1);
  utstring_new(c->s);
  memset(c->ws, ' ', 1024);
  c->ws[0] = '\0';

  return c;
}

void dwarf_pp_context_push(dwarf_pp_context_t * c, char * fmt, ...)
{
  dwarf_stack_t * node = calloc(sizeof(*node), 1);

  va_list ap;
  va_start(ap, fmt);
  vasprintf(&(node->str), fmt, ap);
  va_end(ap);

  DL_APPEND(c->stack, node);

  c->ws[c->level * 2] = ' ';
  c->level++;
  c->ws[c->level * 2] = '\0';
}

void dwarf_pp_context_pop(dwarf_pp_context_t * c)
{
  dwarf_stack_t * node = c->stack->prev;

  assert(c->level > 0);
  DL_DELETE(c->stack, node);

  c->ws[c->level * 2] = ' ';
  c->level--;
  c->ws[c->level * 2] = '\0';

  free(node->str);
  free(node);
}

char * dwarf_pp_context_add(dwarf_pp_context_t * c, void * func, void * obj)
{
  dwarf_seen_t * node;
  void * key[2] = { func, obj };

  HASH_FIND(hh, c->lookup, key, sizeof(key), node);

  if (node) {
    return utstring_body(node->str);
  }

  node = calloc(sizeof(*node), 1);
  node->key[0] = func;
  node->key[1] = obj;
  utstring_new(node->str);
  utstring_printf(node->str, "ROOT");

  dwarf_stack_t * ele;
  DL_FOREACH(c->stack, ele) {
    utstring_printf(node->str, "->%s", ele->str);
  }

  HASH_ADD_KEYPTR(hh, c->lookup, node->key, sizeof(key), node);

  return NULL;
}

void dwarf_pp_context_destroy(dwarf_pp_context_t * c)
{
  dwarf_seen_t * ele, * tmp;

  HASH_ITER(hh, c->lookup, ele, tmp) {
    HASH_DEL(c->lookup, ele);
    utstring_free(ele->str);
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
