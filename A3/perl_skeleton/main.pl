use strict;
use warnings;

# switch version here

# use base_version::Tournament;
# my $tournament = new Tournament();

use advanced_version::AdvancedTournament;
my $tournament = new AdvancedTournament();

$tournament -> play_game();