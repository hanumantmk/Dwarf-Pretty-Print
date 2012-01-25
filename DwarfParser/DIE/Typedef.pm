package DwarfParser::DIE::Typedef;

use strict;
use warnings;

sub new {
  my ($class, $id, $name, $type) = @_;

  return bless {
    id   => $id,
    name => $name,
    type => $type,
  }, $class;
}

sub name {
  my $self = shift;

  return $self->{name};
}

sub pp_proto {
  my ($self, $types) = @_;

  "void dwarfparser_" . $self->name . "(UT_string * s, void * _x)";
}

sub pp_fun {
  my ($self, $types) = @_;

  $self->pp_proto($types) . " {\n  dwarfparser__" . $self->{type} . "(s, _x);\n} ";
}

sub children {
  my ($self, $types, $seen) = @_;

  return if ($seen->{$self});
  $seen->{$self} = 1;

  ($self, map { $_->children($types, $seen) } $types->{$self->{type}});
}

1;
