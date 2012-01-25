package DwarfParser::DIE::Typedef;

use strict;
use warnings;

use base 'DwarfParser::DIE';

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

sub pp_fun {
  my ($self, $types) = @_;

  $self->pp_proto($types) . " {\n  dwarfparser__" . $self->{type} . "(s, _x, indent);\n} ";
}

sub children {
  my ($self, $types, $seen) = @_;

  return if ($seen->{$self});
  $seen->{$self} = 1;

  ($self, map { $_->children($types, $seen) } ($types->{$self->{type}} || ()));
}

1;
