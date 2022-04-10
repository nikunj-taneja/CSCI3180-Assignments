use strict;
use warnings;

use lib "./";

package AdvancedTournament;
use base_version::Team;
use advanced_version::AdvancedFighter;
use base_version::Tournament;
use List::Util qw(sum);

our @ISA = qw(Tournament); 


sub new {
    my ( $class, @args ) = @_;
    my $self = $class->SUPER::new(@args);
    $self->{"defeat_record"} = [];

    return bless $self, $class;
}

sub play_one_round {
    my ( $self ) = @_;
    my $fight_cnt = 1;
    print "Round $self->{'round_cnt'}:\n";

    $self->{"defeat_record"} = [];

    my $team1_fighter = undef;
    my $team2_fighter = undef;
    my $team_fighter = undef;

    while (1) {
        $team1_fighter = $self->{"team1"}->get_next_fighter();
        $team2_fighter = $self->{"team2"}->get_next_fighter();

        if (!defined($team1_fighter) | !defined($team2_fighter)) {
            last;
        }

        $team1_fighter->buy_prop_upgrade();
        $team2_fighter->buy_prop_upgrade();
        
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

        my $winner = undef;
        my $winner_info = "tie";
        if (!$damage_second) {
            $winner = $fighter_first;
            $winner_info = "Fighter ${$fighter_first->get_properties()}{'NO'} wins";
        } else {
            if ($damage_first > $damage_second) {
                $winner = $fighter_first;
                $winner_info = "Fighter ${$fighter_first->get_properties()}{'NO'} wins";
            } elsif ($damage_second > $damage_first) {
                $winner = $fighter_second;
                $winner_info = "Fighter ${$fighter_second->get_properties()}{'NO'} wins";
            }
        }

        if (defined($winner)) {
            if ($winner == $fighter_first) {
                $fighter_first->record_fight(1);
                $fighter_second->record_fight(-1);
            } else {
                $fighter_first->record_fight(-1);
                $fighter_second->record_fight(1);
            }
        } else {
            $fighter_first->record_fight(0);
            $fighter_second->record_fight(0);
        }

        print("Duel $fight_cnt: Fighter ${$team1_fighter->get_properties()}{'NO'} VS Fighter ${$team2_fighter->get_properties()}{'NO'}, $winner_info\n");
        $team1_fighter->print_info();
        $team2_fighter->print_info();
        $fight_cnt += 1;

        my $flag_defeat_first = 0;
        my $flag_defeat_second = 0;
        my $flag_rest = 0;

        if ($fighter_second->check_defeated()) {
            push(@{$self->{"defeat_record"}}, $fighter_second->{"NO"});
            $flag_defeat_first = 1;
        }

        if ($fighter_first->check_defeated()) {
            push(@{$self->{"defeat_record"}}, $fighter_first->{"NO"});
            $flag_defeat_second = 1;
        }

        $self->update_fighter_properties_and_award_coins($fighter_first, $flag_defeat_first, $flag_rest);
        $self->update_fighter_properties_and_award_coins($fighter_second, $flag_defeat_second, $flag_rest);

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
                
                $self->update_fighter_properties_and_award_coins($team_fighter, 0, 1);
            } else {
                last;
            }
            $team_fighter = $team->get_next_fighter();
        }
    }

    $self->{"round_cnt"} += 1
    
}

sub update_fighter_properties_and_award_coins {
    my ( $self, $fighter, $flag_defeat, $flag_rest ) = @_;
    local $AdvancedFighter::delta_attack = $AdvancedFighter::delta_attack;
    local $AdvancedFighter::delta_defense = $AdvancedFighter::delta_defense;
    local $AdvancedFighter::delta_speed = $AdvancedFighter::delta_speed;
    local $AdvancedFighter::coins_to_obtain = $AdvancedFighter::coins_to_obtain;

    if ($flag_rest) {
        $AdvancedFighter::delta_attack = 1;
        $AdvancedFighter::delta_defense = 1;
        $AdvancedFighter::delta_speed = 1;
        $AdvancedFighter::coins_to_obtain = int(0.5*$AdvancedFighter::coins_to_obtain);
    }

    if (sum(@{$fighter->{"history_record"}}) == 3) {
        $AdvancedFighter::delta_attack = 1;
        $AdvancedFighter::delta_defense = -2;
        $AdvancedFighter::delta_speed = 1;
        # 10% more coins
        $AdvancedFighter::coins_to_obtain = int(1.1*$AdvancedFighter::coins_to_obtain);
        # clear history record
        $fighter->{"history_record"} = [];
        
    } elsif (sum(@{$fighter->{"history_record"}}) == -3) {
        $AdvancedFighter::delta_attack = -2;
        $AdvancedFighter::delta_defense = 2;
        $AdvancedFighter::delta_speed = 2;
        # 10% more coins
        $AdvancedFighter::coins_to_obtain = int(1.1*$AdvancedFighter::coins_to_obtain);
        # clear history record
        $fighter->{"history_record"} = [];
    }

    if ($flag_defeat) {
        $AdvancedFighter::delta_attack += 1;
        $AdvancedFighter::coins_to_obtain = int(2*$AdvancedFighter::coins_to_obtain);
    }

    $fighter->update_properties();
    $fighter->obtain_coins();
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
                my $fighter = AdvancedFighter->new( $fighter_idx, $HP, $attack, $defence, $speed );
                push(@$fighter_list_team, $fighter);
                last;
            }
            print("Properties violate the constraint\n");
        }
    }
    return $fighter_list_team;
}


1;