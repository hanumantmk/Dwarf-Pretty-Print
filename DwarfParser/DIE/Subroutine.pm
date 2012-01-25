package DwarfParser::DIE::Subroutine;

use strict;
use warnings;

use base 'DwarfParser::DIE';

sub new {
  my ($class, $id, $type) = @_;

  return bless {
    id     => $id,
    type   => $type,
    params => [],
  }, $class;
}

sub name { 'void' }

sub pp_fun {
  my ($self, $types) = @_;

  my $type = $types->{$self->{type}};

  my $return = $type ? $type->name : 'void';
  my $params = join(", ", map { $types->{$_} ? $types->{$_}->name($types) : '?' } @{$self->{params}});

  my $name = "$return (* ?)($params)";

  $self->pp_proto($types) . "{\n
  utstring_printf(s, \"$name\");
}";
}

sub children {
  my ($self, $types, $seen) = @_;

  return if ($seen->{$self});
  $seen->{$self} = 1;

  return if (! $self->{type});

  ($self, map { $_->children($types, $seen) } grep { $_ } map { $types->{$_} } $self->{type}, @{$self->{params}});
}

1;
