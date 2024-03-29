use strict;
use warnings;

use lib "./";

package Tournament;
use base_version::Team;
use base_version::Fighter;

sub new {
    my $class = shift;

    my $self = {
        "team1" => undef,
        "team2" => undef,
        "round_cnt" => 1
    };

    return bless $self, $class;
}

sub set_teams {
    my ( $self, $team1, $team2 ) = @_;
    $self->{"team1"} = $team1;
    $self->{"team2"} = $team2;
}

sub play_one_round { 
    my ( $self ) = @_;
    my $fight_cnt = 1;
    print "Round $self->{'round_cnt'}:\n";

    my $team1_fighter = undef;
    my $team2_fighter = undef;
    my $team_fighter = undef;

    while (1) {
        $team1_fighter = $self->{"team1"}->get_next_fighter();
        $team2_fighter = $self->{"team2"}->get_next_fighter();

        if (!defined($team1_fighter) | !defined($team2_fighter)) {
            last;
        }
        
        my $fighter_first = $team1_fighter;
        my $fighter_second = $team2_fighter;

        if (${$team1_fighter->get_properties()}{"speed"} < ${$team2_fighter->get_properties()}{"speed"}) {
            $fighter_first = $team2_fighter;
            $fighter_second = $team1_fighter;
        } 

        my $properties_first = $fighter_first->get_properties();
        my $properties_second = $fighter_second->get_properties();

        my $damage_first = $properties_first->{"attack"} - $properties_second->{"defense"};
        if ($damage_first < 1) {
            $damage_first = 1;
        }
        my $damage_second = undef;

        $fighter_second->reduce_HP($damage_first);
        
        if (!$fighter_second->check_defeated()) {
            $damage_second = $properties_second->{"attack"} - $properties_first->{"defense"};
            if ($damage_second < 1) {
                $damage_second = 1;
            }
            $fighter_first->reduce_HP($damage_second);
        }

        my $winner_info = "tie";
        if (!$damage_second) {
            $winner_info = "Fighter ${$fighter_first->get_properties()}{'NO'} wins";
        } else {
            if ($damage_first > $damage_second) {
                $winner_info = "Fighter ${$fighter_first->get_properties()}{'NO'} wins";
            } elsif ($damage_second > $damage_first) {
                $winner_info = "Fighter ${$fighter_second->get_properties()}{'NO'} wins";
            }
        }

        print("Duel $fight_cnt: Fighter ${$team1_fighter->get_properties()}{'NO'} VS Fighter ${$team2_fighter->get_properties()}{'NO'}, $winner_info\n");
        $team1_fighter->print_info();
        $team2_fighter->print_info();
        $fight_cnt += 1;
    }

    print("Fighters at rest:\n");
    for my $team (($self->{"team1"}, $self->{"team2"})) {
        if ($team == $self->{"team1"}) {
            $team_fighter = $team1_fighter
        } else {
            $team_fighter = $team2_fighter
        }
        while (1) {
            if (defined($team_fighter)) {
                $team_fighter->print_info();
            } else {
                last;
            }
            $team_fighter = $team->get_next_fighter();
        }
    }

    $self->{"round_cnt"} += 1
}

sub check_winner() {
    my ( $self ) = @_;
    my $team1_defeated = 1;
    my $team2_defeated = 1;

    my $fighter_list1 = $self->{"team1"}->get_fighter_list();
    my $fighter_list2 = $self->{"team2"}->get_fighter_list();

    for my $i ((scalar @$fighter_list1) - 1) {
        if (!@$fighter_list1[$i]->check_defeated()) {
            $team1_defeated = 0;
            last;
        }
    }

    for my $i ((scalar @$fighter_list2) - 1) {
        if (!@$fighter_list2[$i]->check_defeated()) {
            $team2_defeated = 0;
            last;
        }
    }

    my $stop = 0;
    my $winner = 0;

    if ($team1_defeated) {
        $stop = 1;
        $winner = 2;
    } elsif ($team2_defeated) {
        $stop = 1;
        $winner = 1;
    }

    return $stop, $winner
}

sub input_fighters {
    my ( $self, $team_NO ) = @_;
    print("Please input properties for fighters in Team $team_NO\n");
    my $fighter_list_team = []; 
    for my $fighter_idx ((4*($team_NO - 1) + 1)..(4*($team_NO - 1) + 4)) {
        while (1) {
            my $properties_stdin = <STDIN>;
            chomp $properties_stdin;
            my @properties_str = split(' ', $properties_stdin);
            my @properties = map(int, @properties_str);
            my ( $HP, $attack, $defence, $speed ) = @properties;
            if ($HP + 10 * ($attack + $defence + $speed) <= 500) {
                my $fighter = Fighter->new( $fighter_idx, $HP, $attack, $defence, $speed );
                push(@$fighter_list_team, $fighter);
                last;
            }
            print("Properties violate the constraint\n");
        }
    }
    return $fighter_list_team;
}

sub play_game {
    my ( $self ) = @_;
    my $fighter_list_team1 = $self->input_fighters(1);
    my $fighter_list_team2 = $self->input_fighters(2);

    my $team1 = new Team(1);
    my $team2 = new Team(2);
    $team1->set_fighter_list($fighter_list_team1);
    $team2->set_fighter_list($fighter_list_team2);

    $self->set_teams($team1, $team2);

    my $stop = undef;
    my $winner = undef;

    print("===========\n");
    print("Game Begins\n");
    print("===========\n\n");

    while (1) {
        print("Team 1: please input order\n");
        my @order1 = undef;
        my @order2 = undef;
        while (1) {
            my $order_input = <STDIN>;

            if (!defined($order_input)) {
                # exit if reached EOF
                exit(0);
            }

            chomp $order_input;
            my @order_str = split(' ', $order_input);
            @order1 = map(int, @order_str);
            my $flag_valid = 1;
            my $undefeated_number = 0;
            for my $order (@order1) {
                if (($order < 1) | ($order > 4)) {
                    $flag_valid = 0;
                } elsif (${$self->{"team1"}->get_fighter_list()}[$order - 1]->check_defeated()) {
                    $flag_valid = 0;
                }
            }
            
            my $num_unique = 0;
            my %seen = ();
            foreach my $i (@order1) {
                $num_unique++ unless $seen{$i}++;
            }

            if (scalar @order1 != $num_unique) {
                $flag_valid = 0;
            }

            for my $i (0..3) {
                if (!(${$self->{"team1"}->get_fighter_list()}[$i]->check_defeated())) {
                    $undefeated_number += 1;
                }
            }

            if ($undefeated_number != scalar @order1) {
                $flag_valid = 0;
            }

            if ($flag_valid) {
                last;
            } else {
                print("Invalid input order\n");
            }
        }

        print("Team 2: please input order\n");
        while (1) {
            my $order_input = <STDIN>;
            chomp $order_input;
            my @order_str = split(' ', $order_input);
            @order2 = map(int, @order_str);
            my $flag_valid = 1;
            my $undefeated_number = 0;
            for my $order (@order2) {
                if (($order < 5) | ($order > 8)) {
                    $flag_valid = 0;
                } elsif (${$self->{"team2"}->get_fighter_list()}[$order - 1 - 4]->check_defeated()) {
                    $flag_valid = 0;
                }
            }

            my $num_unique = 0;
            my %seen = ();
            foreach my $i (@order2) {
                $num_unique++ unless $seen{$i}++;
            }

            if (scalar @order2 != $num_unique) {
                $flag_valid = 0;
            }

            for my $i (0..3) {
                if (!($self->{"team2"}->{"fighter_list"}[$i]->check_defeated())) {
                    $undefeated_number += 1;
                }
            }

            if ($undefeated_number != scalar @order2) {
                $flag_valid = 0;
            }

            if ($flag_valid) {
                last;
            } else {
                print("Invalid input error\n");
            }
        }

        $self->{"team1"}->set_order(\@order1);
        $self->{"team2"}->set_order(\@order2);

        $self->play_one_round();

        ( $stop, $winner ) = $self->check_winner();
        if ($stop) {
            last;
        }
    }

    print("Team $winner wins\n");
}


1;