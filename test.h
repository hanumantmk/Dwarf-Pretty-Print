typedef struct foo {
  int bar;
  char * baz;
  struct foo * foo_next;
  int stuff[10];
  int (*fun)(char *);
} foo_t;
