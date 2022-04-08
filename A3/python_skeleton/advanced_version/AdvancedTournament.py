from base_version.Team import Team
from base_version.Tournament import Tournament
from .AdvancedFighter import AdvancedFighter
import advanced_version.AdvancedFighter as AdvancedFighterFile


class AdvancedTournament(Tournament):
    def __init__(self):
        super(AdvancedTournament, self).__init__()
        self.team1 = None
        self.team2 = None
        self.round_cnt = 1
        self.defeat_record = []

    def update_fighter_properties_and_award_coins(self, fighter, flag_defeat=False, flag_rest=False):
        ...

    def input_fighters(self, team_NO):
        ...
        
    def play_one_round(self):
        ...
