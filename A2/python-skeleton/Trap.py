# Duck Typing
class Trap:
    def __init__(self, row, col):
        self._row = row
        self._col = col
        self._occupying = None
        self._name = "Trap"

    # TODO: _occupying get and setter
    @property
    def occupying(self):
        return self._occupying
    
    @occupying.setter
    def occupying(self, cell):
        self._occupying = cell

    # TODO: _name getter
    @property
    def name(self):
        return self._name

    def interact_with(self, comer):
        # TODO: Add game logic.
        self.occupying.remove_occupant()
        if comer.name == "Goblin":
            print("\033[1;31;43mA goblin entered a trap at (%d, %d)and died.\033[0;0m" % (self._row, self._col))
            comer.active = False
            return False
        elif comer.name == "Player":
            print("\033[1;31;43mYou entered a trap at (%d, %d)! HP - 1.\033[0;0m" % (self._row, self._col))
            comer.hp -= 1
            comer.oxygen -= 1
            return True
        else:
            return False


    def display(self):
        # TODO: Add display logic.
        return "\033[2;97m "
