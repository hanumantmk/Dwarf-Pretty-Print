package DwarfParser::DIE::BaseType;

use strict;
use warnings;

use base 'DwarfParser::DIE';

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

sub pp_fun {
  my ($self, $types) = @_;

  my $proto = $self->pp_proto($types);
  my $check = $self->_pp_check;
  my $name  = $self->name;

  <<CODE
$proto
{
$check
  $name * x = _x;

  utstring_printf(c->s, "%d", *x);
}
CODE
  ;
}

sub children {
  my ($self, $types, $seen) = @_;

  return if ($seen->{$self});
  $seen->{$self} = 1;

  return ($self);
}

1;
