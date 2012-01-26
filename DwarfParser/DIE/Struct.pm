package DwarfParser::DIE::Struct;

use strict;
use warnings;

use base 'DwarfParser::DIE';

sub new {
  my ($class, $id, $name) = @_;

  return bless {
    id      => $id,
    name    => $name,
    members => { },
  }, $class;
}

sub name {
  my $self = shift;

  return $self->{name} ? ("struct " . $self->{name}) : 'void ';
}

sub add_member {
  my ($self, $key, $val) = @_;

  $self->{members}{$key} = $val;
}

sub pp_fun {
  my ($self, $types) = @_;

  my $proto = $self->pp_proto($types);
  my $check = $self->_pp_check();
  my $name = $self->name;

  my $body = join("  utstring_printf(c->s, \",\\n\");\n", map {
    my $child_type = $types->{$self->{members}{$_}};
    my $access = $child_type && $child_type->isa('DwarfParser::DIE::PointerType') ? "x->$_" : "&(x->$_)";
    my $child_id = $self->{members}{$_};

    <<CHILD
  utstring_printf(c->s, "%s$_ : ", dwarf_pp_context_indent(c, indent + 2));
  dwarfparser__$child_id(c, $access, indent + 2);
CHILD
    ;
  } ( sort keys %{$self->{members}}));

  <<CODE
$proto
{
$check
  $name * x = _x;
  utstring_printf(c->s, "$name {\\n");
$body
  utstring_printf(c->s, "\\n%s}", dwarf_pp_context_indent(c, indent));
}
CODE
  ;
}

sub children {
  my ($self, $types, $seen) = @_;

  return if ($seen->{$self});
  $seen->{$self} = 1;

  ($self, map { my $t = $types->{$_}; $t ? $t->children($types, $seen) : () } values %{$self->{members}});
}

1;
