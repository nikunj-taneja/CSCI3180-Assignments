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

class Team:

    def __init__(self, NO):
        self.NO = NO
        self.fighter_list = None
        self.order = None
        # previous index of the order
        self.fight_cnt = 0

    @property
    def fighter_list(self):
        return self._fighter_list

    @fighter_list.setter
    def fighter_list(self, fighter_list):
        self._fighter_list = fighter_list

    def set_order(self, order):
        self.order = []
        for a_order in order:
            self.order.append(int(a_order))
        self.fight_cnt = 0

    def get_next_fighter(self):
        if self.fight_cnt >= len(self.order):
            return None
        prev_fighter_idx = self.order[self.fight_cnt]
        fighter = None
        for _fighter in self.fighter_list:
            if _fighter.properties["NO"] == prev_fighter_idx:
                fighter = _fighter
                break
        self.fight_cnt += 1
        return fighter
