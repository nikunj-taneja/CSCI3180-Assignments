#
# CSCI3180 Principles of Programming Languages
#
# --- Declaration ---
#
# I declare that the assignment here submitted is original except for source
# material explicitly acknowledged. I also acknowledge that I am aware of
# University policy and regulations on honesty in academic work, and of the
# disciplinary guidelines and procedures applicable to breaches of such policy
# and regulations, as contained in the website
# http://www.cuhk.edu.hk/policy/academichonesty/
#
# Assignment 3
# Name : Taneja Nikunj
# Student ID : 1155123371
# Email Addr : ntaneja9@cse.cuhk.edu.hk
#

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
        "fight_cnt" => 0
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
    $self->{"order"} = [];
    for my $a_order (@$order) {
        push(@{$self->{"order"}}, int($a_order));
    }
    $self->{"fight_cnt"} = 0;
}

sub get_next_fighter {
    my ( $self ) = @_;

    if ($self->{"fight_cnt"} >= scalar @{$self->{"order"}}) {
        return undef;
    }

    my $prev_fighter_idx = ${$self->{"order"}}[$self->{"fight_cnt"}];
    my $fighter = undef;
    for my $cur_fighter (@{$self->{"fighter_list"}}) {
        if (${$cur_fighter->get_properties()}{"NO"} == $prev_fighter_idx) {
            $fighter = $cur_fighter;
            last;
        }
    }

    $self->{"fight_cnt"} += 1;
    return $fighter;
}


1;