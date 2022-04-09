use strict;
use warnings;

package Fighter;

sub new {
  my $class = shift;
  my $self = {
    "NO" => shift,
    "HP" => shift,
    "attack" => shift,
    "defense" => shift,
    "speed" => shift,
    "defeated" => shift
  };

  return bless $self, $class;
}

sub get_properties {
  my ( $self ) = @_;
  return {
    "NO" => $self->{"NO"},
    "HP" => $self->{"HP"},
    "attack" => $self->{"attack"},
    "defense" => $self->{"defense"},
    "speed" => $self->{"speed"},
    "defeated" => 0
  };
}

sub reduce_HP {
  my ( $self, $damage ) = @_;
  $self->{"HP"} -= $damage;
  if ($self->{"HP"} <= 0) {
    $self->{"HP"} = 0;
    $self->{"defeated"} = 1;
  }
  return;
}

sub check_defeated {
  my ( $self ) = @_;
  return $self->{"defeated"};
}

sub print_info {
  my $self = shift;

  my $defeated_info;
  if ($self->check_defeated()) {
    $defeated_info = "defeated";
  } else {
    $defeated_info = "undefeated";
  }
  print "Fighter $self->{'NO'}: HP: $self->{'HP'} attack: $self->{'attack'} defense: $self->{'defense'} speed: $self->{'speed'} $defeated_info\n";
}


1;
