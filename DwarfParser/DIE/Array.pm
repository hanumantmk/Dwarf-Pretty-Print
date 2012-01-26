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

  utstring_printf(c->s, "[\\n");
  int i;
  for (i = 0; i < $size - 1; i++) {
    dwarf_pp_context_push(c, "[%d]", i);
    utstring_printf(c->s, "%s", c->ws);
    dwarfparser__$type_id(c, x + i);
    utstring_printf(c->s, ",\\n");
    dwarf_pp_context_pop(c);
  }
  dwarf_pp_context_push(c, "[%d]", i);
    utstring_printf(c->s, "%s", c->ws);
  dwarfparser__$type_id(c, x + i);
  dwarf_pp_context_pop(c);
  utstring_printf(c->s, "\\n%s]", c->ws);
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
