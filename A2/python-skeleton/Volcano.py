from Cell import Mountain 

class Volcano(Mountain):
	def __init__(self, row, col, freq):
		Mountain.__init__(self, row, col)
		self._countdown = freq 
		self._frequency = freq
		self._color = '\u001b[41m'
		self._active = True 

	# TODO: _active getter
	
	def act(self, map):
		# TODO: reduce the countdown by 1 
        #       when the countdown is zero, refresh the countdown 
        #       get all objects occupying the neighboring cells 
        #		and update their properties accordingly 

        if #condition: 
        	print("\033[1;33;41mVolcano erupts! \033[0;0m")
        	# add game logic 
        # END TODO 

	def display(self):
		# TODO: return a string representing the Volcano 

        # END TODO 