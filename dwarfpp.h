#ifndef DWARFPP_H
#define DWARFPP_H

#include <assert.h>
#include "uthash.h"
#include "utstring.h"
#include "utlist.h"

typedef struct dwarf_seen {
  void * key[2];

  UT_string * str;

  UT_hash_handle hh;
} dwarf_seen_t;

typedef struct dwarf_stack {
  char * str;

  struct dwarf_stack * next, * prev;
} dwarf_stack_t;

typedef struct dwarf_pp_context {
  dwarf_seen_t * lookup;
  char ws[1024];

  int level;
  dwarf_stack_t * stack;

  UT_string * s;
} dwarf_pp_context_t;

char * dwarfpp(void * obj, char * type);

dwarf_pp_context_t * dwarf_pp_context_new();
char * dwarf_pp_context_add(dwarf_pp_context_t * c, void * func, void * obj);
void dwarf_pp_context_destroy(dwarf_pp_context_t * c);
void dwarf_pp_context_push(dwarf_pp_context_t * c, char * fmt, ...);
void dwarf_pp_context_pop(dwarf_pp_context_t * c);

#endif
