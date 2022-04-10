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
        if flag_rest:
            # fighter at rest
            AdvancedFighterFile.delta_attack = 1
            AdvancedFighterFile.delta_defense = 1
            AdvancedFighterFile.delta_speed = 1
            # only half the coins
            AdvancedFighterFile.coins_to_obtain = int(0.5*AdvancedFighterFile.coins_to_obtain)

        # check if fighter is a consecutive winner/loser
        if sum(fighter.history_record) == 3:
            AdvancedFighterFile.delta_attack = 1
            AdvancedFighterFile.delta_defense = -2
            AdvancedFighterFile.delta_speed = 1
            # 10% more coins
            AdvancedFighterFile.coins_to_obtain = int(1.1*AdvancedFighterFile.coins_to_obtain)
            # clear history record
            fighter.history_record = []
        
        elif sum(fighter.history_record) == -3:
            AdvancedFighterFile.delta_attack = -2
            AdvancedFighterFile.delta_defense = 2
            AdvancedFighterFile.delta_speed = 2
            # 10% more coins
            AdvancedFighterFile.coins_to_obtain = int(1.1*AdvancedFighterFile.coins_to_obtain)
            # clear history record
            fighter.history_record = []

        if flag_defeat:
            # increment delta_attack
            AdvancedFighterFile.delta_attack += 1
            # double coins
            AdvancedFighterFile.coins_to_obtain = int(2*AdvancedFighterFile.coins_to_obtain)
        
        fighter.update_properties()
        fighter.obtain_coins()

        # set deltas and coins_to_obtain to default
        AdvancedFighterFile.delta_attack = -1
        AdvancedFighterFile.delta_defense = -1
        AdvancedFighterFile.delta_speed = -1
        AdvancedFighterFile.coins_to_obtain = 20

    def input_fighters(self, team_NO):
        print("Please input properties for fighters in Team {}".format(team_NO))
        fighter_list_team = []
        for fighter_idx in range(4 * (team_NO - 1) + 1, 4 * (team_NO - 1) + 5):
            while True:
                properties = input().split(" ")
                properties = [int(prop) for prop in properties]
                HP, attack, defence, speed = properties
                if HP + 10 * (attack + defence + speed) <= 500:
                    fighter = AdvancedFighter(fighter_idx, HP, attack, defence, speed)
                    fighter_list_team.append(fighter)
                    break
                print("Properties violate the constraint")
        return fighter_list_team
        
    def play_one_round(self):
        fight_cnt = 1
        print("Round {}:".format(self.round_cnt))
        self.defeat_record = []
        while True:
            team1_fighter = self.team1.get_next_fighter()
            team2_fighter = self.team2.get_next_fighter()

            if team1_fighter is None or team2_fighter is None:
                break

            team1_fighter.buy_prop_upgrade()
            team2_fighter.buy_prop_upgrade()

            fighter_first = team1_fighter
            fighter_second = team2_fighter
            if team1_fighter.properties["speed"] < team2_fighter.properties["speed"]:
                fighter_first = team2_fighter
                fighter_second = team1_fighter

            properties_first = fighter_first.properties
            properties_second = fighter_second.properties

            damage_first = max(properties_first["attack"] - properties_second["defense"], 1)
            fighter_second.reduce_HP(damage_first)

            damage_second = None
            if not fighter_second.check_defeated():
                damage_second = max(properties_second["attack"] - properties_first["defense"], 1)
                fighter_first.reduce_HP(damage_second)

            winner = None
            winner_info = "tie"
            if damage_second is None:
                winner_info = "Fighter {} wins".format(fighter_first.properties["NO"])
                winner = fighter_first
            else:
                if damage_first > damage_second:
                    winner_info = "Fighter {} wins".format(fighter_first.properties["NO"])
                    winner = fighter_first
                elif damage_second > damage_first:
                    winner_info = "Fighter {} wins".format(fighter_second.properties["NO"])
                    winner = fighter_second
            
            # record fight result
            if winner == fighter_first:
                fighter_first.record_fight(1)
                fighter_second.record_fight(-1)
            elif winner == fighter_second:
                fighter_first.record_fight(-1)
                fighter_second.record_fight(1)
            else:
                fighter_first.record_fight(0)
                fighter_second.record_fight(0)


            print("Duel {}: Fighter {} VS Fighter {}, {}".format(fight_cnt, team1_fighter.properties["NO"],
                    team2_fighter.properties["NO"], winner_info))
            team1_fighter.print_info()
            team2_fighter.print_info()
            fight_cnt += 1

            # update fighter props
            flag_defeat_first = False
            flag_defeat_second = False
            if fighter_second.check_defeated():
                self.defeat_record.append(fighter_second.NO)
                flag_defeat_first = True
            if fighter_first.check_defeated():
                self.defeat_record.append(fighter_first.NO)
                flag_defeat_second = True
            self.update_fighter_properties_and_award_coins(fighter_first, flag_defeat=flag_defeat_first)
            self.update_fighter_properties_and_award_coins(fighter_second, flag_defeat=flag_defeat_second)
        
        print("Fighters at rest:")
        for team in [self.team1, self.team2]:
            if team is self.team1:
                team_fighter = team1_fighter
            else:
                team_fighter = team2_fighter
            while True:
                if team_fighter is not None:
                    team_fighter.print_info()
                    self.update_fighter_properties_and_award_coins(team_fighter, flag_rest=True)
                else:
                    break
                team_fighter = team.get_next_fighter()

        self.round_cnt += 1

