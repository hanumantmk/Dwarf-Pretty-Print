package DwarfParser::DIE::BaseType;

use strict;
use warnings;

sub new {
  my ($class, $id, $name, $encoding, $byte_size) = @_;

  return bless {
    id        => $id,
    name      => $name,
    encoding  => $encoding,
    byte_size => $byte_size,
  }, $class;
}

sub name {
  my $self = shift;

  return $self->{name};
}

sub pp_proto {
  my ($self, $types) = @_;

  "void dwarfparser__" . $self->{id} . "(UT_string * s, void * _x)";
}

sub pp_fun {
  my ($self, $types) = @_;

  $self->pp_proto($types) . " {\n  " . $self->name . " * x = _x;\n  utstring_printf(s, ". '"%d"' . ", *x);\n}";
}

sub children {
  my ($self, $types, $seen) = @_;

  return if ($seen->{$self});
  $seen->{$self} = 1;

  return ($self);
}

1;
