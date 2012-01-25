package DwarfParser::DIE;

use strict;
use warnings;

sub pp_proto {
  my ($self, $types) = @_;

  "void dwarfparser__" . $self->{id} . "(UT_string * s, void * _x, int indent)";
}

sub pp_wrap_human {
  my $self = shift;

  "void dwarfparser_" . $self->name . "(UT_string * s, void * x) {\n  dwarfparser__" . $self->{id} . "(s, x, 0);\n}";
}

1;
