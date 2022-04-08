use strict;
use warnings;

use lib "./";
use base_version::Fighter;

package Team;

sub new {
    my $class = shift;
    my $self = {
        "NO" => shift,
        "fighter_list" => undef,
        "order" => undef,
        "fight_cnt" => shift
    };
    return bless $self, $class;
};

sub set_fighter_list {
    my ( $self, $fighter_list ) = @_;
    $self->{"fighter_list"} = $fighter_list;
}

sub get_fighter_list {
    my ( $self ) = @_;
    return $self->{"fighter_list"};
}

sub set_order {
    my ( $self, $order ) = @_;
    for my $a_order (@$order) {
        push(@{$self->{"order"}}, $a_order);
    }
    $self->{"fight_cnt"} = 0;
}

sub get_next_fighter {
    my ( $self ) = @_;
    if ($self->{"fight_cnt"} >= scalar @{$self->{"order"}}) {
        return undef;
    }
    my $prev_fighter_idx = $$self->{"order"}[$self->{"fight_cnt"}];
    my $fighter = undef;
    for my $cur_fighter (@$self->{"fighter_list"}) {
        if (${$cur_fighter->get_properties()}{"NO"} == $prev_fighter_idx) {
            $fighter = $$cur_fighter;
            last;
        }
    }
    $self->{"fighter_cnt"} += 1;
    return $fighter;
}


1;