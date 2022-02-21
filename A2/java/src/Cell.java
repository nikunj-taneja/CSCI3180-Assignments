public class Cell {
	protected int row;
	protected int col;
	protected GameCharacter occupant;
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
	
	public GameCharacter getOccupant() {
		return this.occupant;
	}

	public boolean setOccupant(GameCharacter obj) {
		if (this.getOccupant() == null || this.occupant.interactWith(obj)) {
			this.occupant = obj;
			return true;
		} else {
			return false;
		}
	}
	
	public void removeOccupant() {
		this.occupant = null;
	}
	
	public void display() {
		if (this.occupant != null) {
			System.out.format("%s %s%s \033[0m   ", this.color, this.occupant.display(), this.color);
		} else {
			System.out.format("%s   \033[0m   ", this.color);
		}
	}
}