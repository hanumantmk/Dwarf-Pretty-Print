package DwarfParser::DIE::BaseType;

use strict;
use warnings;

use base 'DwarfParser::DIE';

use constant ENCODING2TYPE => {
  'signed.2'        => '"%hd"',
  'signed.4'        => '"%"PRId32',
  'signed.8'        => '"%"PRId64',
  'signed_char.1'   => '"%hhd"',
  'unsigned_char.1' => '"%hhu"',
  'unsigned.2'      => '"%hu"',
  'unsigned.4'      => '"%"PRIu32',
  'unsigned.8'      => '"%"PRIu64',
  'float.4'         => '"%f"',
  'float.8'         => '"%g"',
};

sub new {
  my ($class, $id, $name, $encoding, $byte_size) = @_;

  $name ||= 'int';

  $name =~ s/__/ /g;

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
  my $fmt   = ENCODING2TYPE->{join('.', $self->{encoding}, $self->{byte_size})} || '"%d"';

  <<CODE
$proto
{
$check
  $name * x = _x;

  utstring_printf(c->s, $fmt, *x);
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
