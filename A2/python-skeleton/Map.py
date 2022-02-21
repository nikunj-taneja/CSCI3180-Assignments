from Cell import Cell


class Map:
    def __init__(self, rows, cols):
        self._rows = rows
        self._cols = cols
        self._cells = [[Cell() for x in range(cols)] for y in range(rows)]
    
    #TODO: rows getter
    
    #TODO: cols getter
    
    def get_cell(self, row, col):
        # TODO: check whether the position is out of boundary 
        #       if not, return the cell at (row, col)
        #       return None otherwise 
        if #condition: 
            print("\033[1;31;46mNext move is out of boundary!\033[0;0m")
            return None 
        else:
            # return a cell 
        # END TODO 

    def build_cell(self, row, col, cell):
        # TODO: check whether the position is out of boundary 
        #       if not, add a cell (row, col) and return True
        #       return False otherwise 
        if #condition: 
            print("\033[1;31;46mThe position (%d, %d) is out of boundary!\033[0;0m" %(row, col))
            return False 
        else:
            # return a cell 
        # END TODO

    # return a list of cells which are neighbours of cell (row, col) 
    def get_neighbours(self, row, col):
        return_cells = []
        # TODO: return a list of neighboring cells of cell (row, col) 

        # END TODO
        

    def display(self):
        # TODO: print the map by calling diplay of each cell 

        # END TODO
