from .Team import Team
from .Fighter import Fighter


class Tournament:
    def __init__(self):
        self.team1 = None
        self.team2 = None
        self.round_cnt = 1

    def input_fighters(self, team_NO):
        print("Please input properties for fighters in Team {}".format(team_NO))
        fighter_list_team = []
        for fighter_idx in range(4 * (team_NO - 1) + 1, 4 * (team_NO - 1) + 5):
            while True:
                properties = input().split(" ")
                properties = [int(prop) for prop in properties]
                HP, attack, defence, speed = properties
                if HP + 10 * (attack + defence + speed) <= 500:
                    fighter = Fighter(fighter_idx, HP, attack, defence, speed)
                    fighter_list_team.append(fighter)
                    break
                print("Properties violate the constraint")
        return fighter_list_team

    def set_teams(self, team1, team2):
        self.team1 = team1
        self.team2 = team2

    def play_one_round(self):
        fight_cnt = 1
        print("Round {}:".format(self.round_cnt))

        while True:
            team1_fighter = self.team1.get_next_fighter()
            team2_fighter = self.team2.get_next_fighter()

            if team1_fighter is None or team2_fighter is None:
                break

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

            winner_info = "tie"
            if damage_second is None:
                winner_info = "Fighter {} wins".format(fighter_first.properties["NO"])
            else:
                if damage_first > damage_second:
                    winner_info = "Fighter {} wins".format(fighter_first.properties["NO"])
                elif damage_second > damage_first:
                    winner_info = "Fighter {} wins".format(fighter_second.properties["NO"])

            print("Duel {}: Fighter {} VS Fighter {}, {}".format(fight_cnt, team1_fighter.properties["NO"],
                    team2_fighter.properties["NO"], winner_info))
            team1_fighter.print_info()
            team2_fighter.print_info()
            fight_cnt += 1

        print("Fighters at rest:")
        for team in [self.team1, self.team2]:
            if team is self.team1:
                team_fighter = team1_fighter
            else:
                team_fighter = team2_fighter
            while True:
                if team_fighter is not None:
                    team_fighter.print_info()
                else:
                    break
                team_fighter = team.get_next_fighter()

        self.round_cnt += 1

    def check_winner(self):
        team1_defeated = True
        team2_defeated = True

        fighter_list1 = self.team1.fighter_list
        fighter_list2 = self.team2.fighter_list

        for i in range(len(fighter_list1)):
            if not fighter_list1[i].check_defeated():
                team1_defeated = False
                break

        for i in range(len(fighter_list2)):
            if not fighter_list2[i].check_defeated():
                team2_defeated = False
                break

        stop = False
        winner = 0
        if team1_defeated:
            stop = True
            winner = 2
            stop = True

        elif team2_defeated:
            winner = 1
            stop = True

        return stop, winner

    def play_game(self):
        fighter_list_team1 = self.input_fighters(1)
        fighter_list_team2 = self.input_fighters(2)

        team1 = Team(1)
        team2 = Team(2)
        team1.fighter_list = fighter_list_team1
        team2.fighter_list = fighter_list_team2

        self.set_teams(team1, team2)

        print("===========")
        print("Game Begins")
        print("===========\n")

        while True:
            print("Team 1: please input order")
            while True:
                order1 = input().split(" ")
                order1 = [int(order) for order in order1]
                flag_valid = True
                undefeated_number = 0
                for order in order1:
                    if order not in range(1, 5):
                        flag_valid = False
                    elif self.team1.fighter_list[order - 1].check_defeated():
                        flag_valid = False
                if len(order1) != len(set(order1)):
                    flag_valid = False
                for i in range(4):
                    if not self.team1.fighter_list[i].check_defeated():
                        undefeated_number += 1
                if undefeated_number != len(order1):
                    flag_valid = False
                if flag_valid:
                    break
                else:
                    print("Invalid input order")

            print("Team 2: please input order")
            while True:
                order2 = input().split(" ")
                order2 = [int(order) for order in order2]
                flag_valid = True
                undefeated_number = 0
                for order in order2:
                    if order not in range(5, 9):
                        flag_valid = False
                    elif self.team2.fighter_list[order - 1 - 4].check_defeated():
                        flag_valid = False
                if len(order2) != len(set(order2)):
                    flag_valid = False
                for i in range(4):
                    if not self.team2.fighter_list[i].check_defeated():
                        undefeated_number += 1
                if undefeated_number != len(order2):
                    flag_valid = False
                if flag_valid:
                    break
                else:
                    print("Invalid input order")
            self.team1.set_order(order1)
            self.team2.set_order(order2)

            self.play_one_round()
            stop, winner = self.check_winner()
            if stop:
                break

        print("Team {} wins".format(winner))
