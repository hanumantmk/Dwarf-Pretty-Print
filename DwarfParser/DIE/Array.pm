package DwarfParser::DIE::Array;

use strict;
use warnings;

use base 'DwarfParser::DIE';

sub new {
  my ($class, $id, $type) = @_;

  return bless {
    id   => $id,
    type => $type,
    size => 0,
  }, $class;
}

sub name { '' }

sub pp_fun {
  my ($self, $types) = @_;

  my $type = $types->{$self->{type}};
  my $type_id = $self->{type};
  my $size = $self->{size};
  my $name = $type->name;
  my $proto = $self->pp_proto($types);
  my $check = $self->_pp_check;
  
  <<CODE
$proto
{
$check
  $name * x = _x;
  utstring_printf(c->s, "[ ");
  int i;
  for (i = 0; i < $size - 1; i++) {
    dwarfparser__$type_id(c, x + i, indent);
    utstring_printf(c->s, ", ");
  }
  dwarfparser__$type_id(c, x + i, indent);
  utstring_printf(c->s, " ]");
}
CODE
  ;
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
