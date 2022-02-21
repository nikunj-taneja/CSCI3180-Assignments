public class Cell {
	protected int row;
	protected int col;
	protected Object occupant;
	protected int hours;
	protected String color;
	
	public Cell(int row, int col) {
		this.row = row;
		this.col = col;
		this.occupant = null;
		this.color = null; 
		this.hours = 0;
	}

	public int getHours() {
		return this.hours;
	}
	
	public Object getOccupant() {
		return this.occupant;
	}

	public boolean setOccupant(Object obj) {
		if (this.getOccupant() == null) {
			this.occupant = obj;
			return true;
		} else {
			if (this.getOccupant() instanceof GameCharacter) {
				if (((GameCharacter)this.getOccupant()).interactWith(obj)) {
					this.occupant = obj;
					return true;
				} else {
					return false;
				}
			} else if (this.getOccupant() instanceof Trap) {
				if (((Trap)this.getOccupant()).interactWith(obj)) {
					this.occupant = obj;
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}
	}

	public void removeOccupant() {
		this.occupant = null;
	}
	
	public void display() {
		if (this.occupant != null) {
			if (this.occupant instanceof GameCharacter) {
				System.out.format("%s %s%s \033[0m   ", this.color, ((GameCharacter)this.occupant).display(), this.color);
			} else if (this.occupant instanceof Trap) {
				System.out.format("%s %s%s \033[0m   ", this.color, ((Trap)this.occupant).display(), this.color);
			}
		} else {
			System.out.format("%s   \033[0m   ", this.color);
		}
	}

	
}