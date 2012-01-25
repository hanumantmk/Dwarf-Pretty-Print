package DwarfParser::DIE::PointerType;

use strict;
use warnings;

use base 'DwarfParser::DIE';

sub new {
  my ($class, $id, $type, $byte_size) = @_;

  return bless {
    id        => $id,
    type      => $type,
    byte_size => $byte_size,
  }, $class;
}

sub name {
  my ($self, $types) = @_;

  $types->{$self->{type}}->name . ' *';
}

sub pp_fun {
  my ($self, $types) = @_;

  my $type = $types->{$self->{type}};
  my $name = ($type && $type->can('name')) ? $type->name : 'void';

  my $str = $self->pp_proto($types);

  if (! $type) {
    $str .= " {\n  void * x = _x;\n  if (x) {\n    utstring_printf(s, \"%p\", x);\n  } ";
  } elsif ($name eq 'char') {
    $str .= " {\n  char * x = _x;\n  if (x) {\n    utstring_printf(s, \"\\\"%s\\\"\", x);\n  } ";
  } else {
    $str .= " {\n  $name * x = _x;\n  if (x) {\n    dwarfparser__" . $self->{type} . "(s, x, indent);\n  }";
  }

  $str .= " else {\n    utstring_printf(s, \"NULL\");\n  }\n}";
}

sub children {
  my ($self, $types, $seen) = @_;

  return if ($seen->{$self});
  $seen->{$self} = 1;

  return if (! $self->{type});

  my $type = $types->{$self->{type}};

  ($self, map { $_->children($types, $seen) } ($type ? ($type) : ()));
}

1;
