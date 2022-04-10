from base_version.Fighter import Fighter

coins_to_obtain = 20
delta_attack = -1
delta_defense = -1
delta_speed = -1


class AdvancedFighter(Fighter):
    def __init__(self, NO, HP, attack, defense, speed):
        super(AdvancedFighter, self).__init__(NO, HP, attack, defense, speed)
        self.coins = 0
        self.history_record = []

    def obtain_coins(self):
        self.coins += coins_to_obtain
        
    def buy_prop_upgrade(self):
        while self.coins >= 50:
            strat = input(
                f"Do you want to upgrade properties for Fighter {self.NO}? "\
                "A for attack. D for defense. S for speed. N for no.\n"
            )
            if strat == 'N':
                return
            
            self.coins -= 50
            if strat == 'A':
                self.attack += 1
            elif strat == 'D':
                self.defense += 1
            else:
                self.speed += 1
        
    def update_properties(self):
        self.attack = max(self.attack + delta_attack, 1)
        self.defense = max(self.defense + delta_defense, 1)
        self.speed = max(self.speed + delta_speed, 1)

    def record_fight(self, fight_result):
        self.history_record.append(fight_result)
        
        # maintain record for only recent three duels
        if len(self.history_record) > 3:
            self.history_record.pop(0)
        
