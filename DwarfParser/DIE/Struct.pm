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

  $self->pp_proto($types) . " {\n  " . $self->name . " * x = _x;
  utstring_printf(s, " . '"(' . $self->name . " *) {\");
  indent += 2;
  char * INDENT = malloc(indent + 1);
  memset(INDENT, ' ', indent);
  INDENT[indent] = '\\0';
  utstring_printf(s, \"\\n\");\n
  " . join(
  "utstring_printf(s, \",\\n\");\n"
  , map {
    my $child_type = $types->{$self->{members}{$_}};
    my $access = $child_type && $child_type->isa('DwarfParser::DIE::PointerType') ? "x->$_" : "&(x->$_)";

    "  utstring_printf(s, \"%s$_ : \", INDENT);\n" .
    '  dwarfparser__' . $self->{members}{$_} . "(s, $access, indent);\n";
  } ( sort keys %{$self->{members}})) .
  "  INDENT[indent - 2] = '\\0'; " .
  '  utstring_printf(s, "\n%s}", INDENT);' .
  "\n  free(INDENT);\n}";
}

sub children {
  my ($self, $types, $seen) = @_;

  return if ($seen->{$self});
  $seen->{$self} = 1;

  ($self, map { my $t = $types->{$_}; $t ? $t->children($types, $seen) : () } values %{$self->{members}});
}

1;
