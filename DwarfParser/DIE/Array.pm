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

  $self->pp_proto($types) . "{\n  " . $type->name . " * x = _x;
  utstring_printf(s, \"[ \");
  int i;
  for (i = 0; i < $size - 1; i++) {
    dwarfparser__$type_id(s, x + i, indent);
    utstring_printf(s, \", \");
  }
  dwarfparser__$type_id(s, x + i, indent);
  utstring_printf(s, \" ]\");
}";
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
