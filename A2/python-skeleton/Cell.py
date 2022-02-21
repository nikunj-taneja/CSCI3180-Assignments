from abc import abstractmethod


class Cell:
    def __init__(self, row=0, col=0):
        self._row = row
        self._col = col
        self._occupant = None
        self._color = None 
        self._hours = 0
    
    # TODO: hours getter and setter

    # TODO: occupant getter


    def set_occupant(self, obj):
        # TODO: set occupant for the Plain cell 
        #       return whether success or not

        # END TODO

    def remove_occupant(self):
        # TODO: remove the occupant 

        # END TODO

    def display(self):
        # TODO: print a string to display the cell 
        #       and the occupant in the cell 

        # END TODO

class Plain(Cell):
    def __init__(self, row, col):
        Cell.__init__(self, row, col)
        self._color = '\033[1;32;42m'
        self._hours = 1

class Mountain(Cell):
    def __init__(self, row, col):
        Cell.__init__(self, row, col)
        self._color = '\033[1;37;47m'

    def set_occupant(self, obj):
        # TODO: return False

        # END TODO
    
class Swamp(Cell):
    def __init__(self, row, col):
        Cell.__init__(self, row, col)
        self._color = '\033[1;34;44m'
        self._hours = 2
