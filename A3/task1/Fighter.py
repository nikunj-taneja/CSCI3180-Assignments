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

class Fighter:

    def __init__(self, NO, HP, attack, defense, speed):
        self.NO = int(NO)
        self.HP = int(HP)
        self.attack = int(attack)
        self.defense = int(defense)
        self.speed = int(speed)
        self.defeated = False

    @property
    def properties(self):
        return {
            "NO": self.NO,
            "HP": self.HP,
            "attack": self.attack,
            "defense": self.defense,
            "speed": self.speed,
            "defeated": self.defeated
        }

    def reduce_HP(self, damage):
        self.HP = self.HP - damage
        if self.HP <= 0:
            self.HP = 0
            self.defeated = True
        return

    def print_info(self):
        defeated_info = "defeated" if self.defeated else "undefeated"
        print("Fighter {}: HP: {} attack: {} defense: {} speed: {} {}".format(self.NO, self.HP, self.attack, self.defense, self.speed, defeated_info))

    def check_defeated(self):
        return self.defeated



