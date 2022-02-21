# Duck Typing
class Trap:
    def __init__(self, row, col):
        self._row = row
        self._col = col
        self._occupying = None
        self._name = "Trap"

    # TODO: _occupying get and setter

    # TODO: _name getter

    def interact_with(self, comer):
        # TODO: Add game logic.
        if comer.name == "Goblin":
            print("\033[1;31;43mA goblin entered a trap at (%d, %d)and died.\033[0;0m" % (self._row, self._col))
            # TODO: Add game logic.
        elif comer.name == "Player":
            print("\033[1;31;43mYou entered a trap at (%d, %d)! HP - 1.\033[0;0m" % (self._row, self._col))
            # TODO: Add game logic.


    def display(self):
        # TODO: Add display logic.
