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

  ($types->{$self->{type}}
    ? $types->{$self->{type}}->name
    : 'void') . ' *';
}

sub pp_fun {
  my ($self, $types) = @_;

  my $type = $types->{$self->{type}};
  my $type_id = $self->{type};
  my $name = ($type && $type->can('name')) ? $type->name : 'void';
  my $check = $self->_pp_check();

  my $proto = $self->pp_proto($types);
  my $tail;

  if (! $type) {
    $tail = <<TAIL
  void * x = _x;
  if (x) {
    utstring_printf(c->s, "%p", x);;
  }
TAIL
    ;
  } elsif ($name eq 'char') {
    $tail = <<TAIL
  char * x = _x;
  if (x) {
    utstring_printf(c->s, "\\"%s\\"", x);;
  }
TAIL
    ;
  } else {
    $tail = <<TAIL
  $name * x = _x;
  if (x) {
    dwarfparser__$type_id(c, x);
  }
TAIL
    ;
  }

  <<CODE
$proto
{
$check
$tail
  else {
    utstring_printf(c->s, "NULL");
  }
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
