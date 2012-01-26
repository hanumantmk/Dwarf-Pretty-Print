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

  my $proto = $self->pp_proto($types);
  my $check = $self->_pp_check();
  my $type_id = $self->{type};

  <<CODE
$proto
{
  dwarfparser__$type_id(c, _x, indent);
}
CODE
  ;
}

sub children {
  my ($self, $types, $seen) = @_;

  return if ($seen->{$self});
  $seen->{$self} = 1;

  ($self, map { $_->children($types, $seen) } ($types->{$self->{type}} || ()));
}

1;
