'''
/*
* CSCI3180 Principles of Programming Languages
*
* --- Declaration ---
*
* I declare that the assignment here submitted is original except for source
* material explicitly acknowledged. I also acknowledge that I am aware of
* University policy and regulations on honesty in academic work, and of the
* disciplinary guidelines and procedures applicable to breaches of such policy
* and regulations, as contained in the website
* http://www.cuhk.edu.hk/policy/academichonesty/
*
* Assignment 2
* Name : Taneja Nikunj
* Student ID : 1155123371
* Email Addr : ntaneja9@cse.cuhk.edu.hk
*/
'''

from abc import abstractmethod


class Cell:
    def __init__(self, row=0, col=0):
        self._row = row
        self._col = col
        self._occupant = None
        self._color = None 
        self._hours = 0
    
    # TODO: hours getter and setter
    @property
    def hours(self):
        return self._hours
    
    @hours.setter
    def hours(self, hours):
        self._hours = hours

    # TODO: occupant getter
    @property
    def occupant(self):
        return self._occupant


    def set_occupant(self, obj):
        # TODO: set occupant for the Plain cell 
        #       return whether success or not
        if self._occupant is None:
            self._occupant = obj
            return True
        else:
            if self._occupant.interact_with(obj):
                self._occupant = obj
                return True
            else:
                return False
        # END TODO

    def remove_occupant(self):
        # TODO: remove the occupant 
        self._occupant = None
        # END TODO

    def display(self):
        # TODO: print a string to display the cell 
        #       and the occupant in the cell 
        if self._occupant is not None:
            print(f'{self._color} {self._occupant.display()}{self._color} \033[0m   ', end='')
        else:
            print(f'{self._color}   \033[0m   ', end='')
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
        return False
        # END TODO
    
class Swamp(Cell):
    def __init__(self, row, col):
        Cell.__init__(self, row, col)
        self._color = '\033[1;34;44m'
        self._hours = 2
