public abstract class GameCharacter {
	protected int row;
	protected int col;
	protected Cell occupying;
	protected String name;
	protected boolean active;
	protected char character;
	protected String color;
	
	public GameCharacter(int row, int col) {
		this.row = row;
		this.col = col;
		occupying = null;
		name = null;
		active = true;
		this.character = ' ';
		this.color = "\033[1;31m";
	}

	public int getRow() {
		return this.row;
	}
	
	public int getCol() {
		return this.col;
	}
	
	public boolean getActive() {
		return this.active;
	}
	
	public String getName() {
		return this.name;
	}
	
	public Cell getOccupying() {
		return this.occupying;
	}

	public void setOccupying(Cell cell) {
		this.occupying = cell;
	}

	public void setActive(boolean active) {
		this.active = active;
	}
	
	protected int[] cmd2Pos(char c) {
		int[] nextPos = new int[2];
		nextPos[0] = this.row;
		nextPos[1] = this.col;
		if (c == 'L') {
			nextPos[1] -= 1;
		} else if (c == 'R') {
			nextPos[1] += 1;
		} else if (c == 'U') {
			nextPos[0] -= 1;
		} else if (c == 'D') {
			nextPos[0] += 1;
		} else {
			System.out.printf("Invalid Move.%n");
		}
		return nextPos;
	}
	
	public String display() {
		return String.format("%s%s", this.color, this.character);
	}
	
	public abstract boolean interactWith(Object comer);

	public abstract void act(Map map);
}