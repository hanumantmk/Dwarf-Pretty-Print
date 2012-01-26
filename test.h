typedef struct foo {
  int bar;
  char * baz;
  struct foo * foo_next;
  int stuff[3];
  int (*fun)(char *);
} foo_t;
