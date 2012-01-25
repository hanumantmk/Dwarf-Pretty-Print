package DwarfParser::DIE::PointerType;

use strict;
use warnings;

sub new {
  my ($class, $id, $type, $byte_size) = @_;

  return bless {
    id        => $id,
    type      => $type,
    byte_size => $byte_size,
  }, $class;
}

sub pp_proto {
  my ($self, $types) = @_;

  "void dwarfparser__" . $self->{id} . "(UT_string * s, void * _x)";
}

sub pp_fun {
  my ($self, $types) = @_;

  my $type = $types->{$self->{type}};
  my $name = ($type && $type->can('name')) ? $type->name : 'void';
  if ($name eq 'char') {
    $self->pp_proto($types) . " {\n  char * x = _x;\n  if (x) {\n    utstring_printf(s, \"\\\"%s\\\"\", x);\n} } ";
  } else {
    $self->pp_proto($types) . " {\n  $name * x = _x;\n  if (x) {\n    dwarfparser__" . $self->{type} . "(s, x);\n}\n  else { utstring_printf(s, \"NULL\"); }\n }";
  }
}

sub children {
  my ($self, $types, $seen) = @_;

  return if ($seen->{$self});
  $seen->{$self} = 1;

  my $type = $types->{$self->{type}};

  ($self, map { $_->children($types, $seen) } ($type ? ($type) : ()));
}

1;
