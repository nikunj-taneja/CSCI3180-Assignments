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

package AdvancedFighter;

use lib "./";

use base_version::Fighter;
use List::Util qw(sum);

our @ISA = qw(Fighter); 

our $coins_to_obtain = 20;
our $delta_attack = -1;
our $delta_defense = -1;
our $delta_speed = -1;


sub new {
    my ( $class, @args ) = @_;

    my $self = $class->SUPER::new(@args);

    $self->{"coins"} = 0;
    $self->{"history_record"} = [];

    return bless $self, $class;
}

sub obtain_coins {
    my ( $self ) = @_;
    $self->{"coins"} += $coins_to_obtain;
}

sub buy_prop_upgrade {
    my ( $self ) = @_;
    while ($self->{"coins"} >= 50) {
        print("Do you want to upgrade properties for Fighter $self->{'NO'}? A for attack. D for defense. S for speed. N for no.\n");
        my $strat = <STDIN>;
        chomp $strat;
        if ($strat eq "N") {
            return;
        }
        $self->{"coins"} -= 50;
        if ($strat eq "A") {
            $self->{"attack"} += 1;
        } elsif ($strat eq "D") {
            $self->{"defense"} += 1;
        } else {
            $self->{"speed"} += 1;
        }
    }
}

sub record_fight {
    my ( $self, $fight_result ) = @_; 
    push(@{$self->{"history_record"}}, $fight_result);
    
    # maintain record for only recent three duels
    if (scalar @{$self->{"history_record"}} > 3) {
        shift @{$self->{"history_record"}};
    }
}


sub update_properties {
    my ( $self ) = @_;
    $self->{"attack"} += $delta_attack;
    $self->{"defense"} += $delta_defense;
    $self->{"speed"} += $delta_speed;
}


1;