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

from Cell import Mountain 

class Volcano(Mountain):
	def __init__(self, row, col, freq):
		Mountain.__init__(self, row, col)
		self._countdown = freq 
		self._frequency = freq
		self._color = '\u001b[41m'
		self._active = True 

	# TODO: _active getter
	@property
	def active(self):
		return self._active
	
	def act(self, map):
		# TODO: reduce the countdown by 1 
        #       when the countdown is zero, refresh the countdown 
        #       get all objects occupying the neighboring cells 
        #		and update their properties accordingly 
		self._countdown -= 1
		if self._countdown == 0: 
			print("\033[1;33;41mVolcano erupts! \033[0;0m")
			# add game logic 
			self._countdown = self._frequency
			cells = map.get_neighbours(self._row, self._col)
			for cell in cells:
				occ = cell.occupant
				if occ:
					if occ.name == "Goblin":
						occ.active = False
						occ.occupying.remove_occupant()
					elif occ.name == "Player":
						occ.hp -= 1
        # END TODO 

	def display(self):
		# TODO: return a string representing the Volcano 
		print(
			f"{self._color} \033[2;97m{self._countdown}{self._color} \033[0m   ",
			end=''
		)
        # END TODO 