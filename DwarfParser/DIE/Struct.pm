package DwarfParser::DIE::Struct;

use strict;
use warnings;

use base 'DwarfParser::DIE';

sub new {
  my ($class, $id, $name) = @_;

  return bless {
    id      => $id,
    name    => $name,
    members => [],
  }, $class;
}

sub name {
  my $self = shift;

  return $self->{name} ? ("struct " . $self->{name}) : 'void ';
}

sub add_member {
  my ($self, $key, $val) = @_;

  push @{$self->{members}}, [$key, $val];
}

sub pp_fun {
  my ($self, $types) = @_;

  my $proto = $self->pp_proto($types);
  my $check = $self->_pp_check();
  my $name = $self->name;

  my $body = join("  utstring_printf(c->s, \",\\n\");\n", map {
    my ($key, $val) = @$_;

    my $child_type = $types->{$val};
    my $access = $child_type && $child_type->isa('DwarfParser::DIE::PointerType') ? "x->$key" : "&(x->$key)";
    my $child_id = $val;

    <<CHILD
  dwarf_pp_context_push(c, "%s", "$key");
  utstring_printf(c->s, "%s$key : ", c->ws);
  dwarfparser__$val(c, $access);
  dwarf_pp_context_pop(c);
CHILD
    ;
  } @{$self->{members}});

  <<CODE
$proto
{
$check
  $name * x = _x;
  utstring_printf(c->s, "$name {\\n");
$body
  utstring_printf(c->s, "\\n%s}", c->ws);
}
CODE
  ;
}

sub children {
  my ($self, $types, $seen) = @_;

  return if ($seen->{$self});
  $seen->{$self} = 1;

  ($self, map { my $t = $types->{$_->[1]}; $t ? $t->children($types, $seen) : () } @{$self->{members}});
}

1;
