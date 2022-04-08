use strict;
use warnings;

package Fighter;


sub new{
}

sub get_properties{
}

sub reduce_HP{
}

sub check_defeated{
}

sub print_info{
  my $self = shift;
  
  my $defeated_info;
  if ($self -> check_defeated() == 1){
    $defeated_info = "defeated";
  }else{
    $defeated_info = "undefeated";
  }
  print "Fighter $self->{'NO'}: HP: $self->{'HP'} attack: $self->{'attack'} defense: $self->{'defense'} speed: $self->{'speed'} $defeated_info\n";
}


1;
