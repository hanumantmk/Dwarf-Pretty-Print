package DwarfParser::DIE::Struct;

use strict;
use warnings;

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

sub pp_proto {
  my ($self, $types) = @_;

  "void dwarfparser__" . $self->{id} . "(UT_string * s, void * _x)";
}

sub pp_fun {
  my ($self, $types) = @_;

  $self->pp_proto($types) . " {\n  " . $self->name . " * x = _x;\n  utstring_printf(s, " . '"(' . $self->name . " *) {\"); " . join(
  "  utstring_printf(s, \",\");\n  "
  , map {
    my $child_type = $types->{$self->{members}{$_}};
    my $access = $child_type && $child_type->isa('DwarfParser::DIE::PointerType') ? "x->$_" : "&(x->$_)";

    'dwarfparser__' . $self->{members}{$_} . "(s, $access);\n"
  } ( sort keys %{$self->{members}})) . ' utstring_printf(s, "}");' . "\n}";
}

sub children {
  my ($self, $types, $seen) = @_;

  return if ($seen->{$self});
  $seen->{$self} = 1;

  ($self, map { my $t = $types->{$_}; $t ? $t->children($types, $seen) : () } values %{$self->{members}});
}

1;
