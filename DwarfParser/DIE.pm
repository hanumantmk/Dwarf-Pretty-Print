package DwarfParser::DIE;

use strict;
use warnings;

sub pp_proto {
  my ($self, $types) = @_;

  my $type = ref($self);

  "void dwarfparser__" . $self->{id} . "(dwarf_pp_context_t * c, void * _x)";
}

sub pp_wrap_human {
  my $self = shift;

  "void dwarfparser_" . $self->name . "(dwarf_pp_context_t * c, void * x) {\n  dwarfparser__" . $self->{id} . "(c, x);\n}";
}

sub _pp_check {
  my $self = shift;

  my $class = ref($self);
  my $name = "dwarfparser__" . $self->{id};

  <<CODE
  // $class
  char * str;
  if ((str = dwarf_pp_context_add(c, &$name, _x))) {
    utstring_printf(c->s, "%s", str);
    return;
  }
CODE
  ;
}

1;
