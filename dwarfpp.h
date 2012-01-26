#ifndef DWARFPP_H
#define DWARFPP_H

#include "uthash.h"
#include "utstring.h"

typedef struct dwarf_seen {
  void * key[2];

  UT_hash_handle hh;
} dwarf_seen_t;

typedef struct dwarf_pp_context {
  dwarf_seen_t * lookup;
  UT_string * s;
} dwarf_pp_context_t;

char * dwarfpp(void * obj, char * type);

dwarf_pp_context_t * dwarf_pp_context_new();
int dwarf_pp_context_add(dwarf_pp_context_t * c, void * func, void * obj);
void dwarf_pp_context_destroy(dwarf_pp_context_t * c);

#endif
