import java.util.ArrayList;

public class Goblin extends GameCharacter {
	private char[] actions;
	private int curAct;
	private int damage;
	
	public Goblin(int row, int col, char[] actions) {
		super(row, col);
		this.actions = actions;
		this.curAct = 0;
		this.damage = 1;
		this.name = "Goblin";
		this.character = 'G';
	}

	public int getDamage() {
		return this.damage;
	}
	
	@Override
	public void act(Map map) {
		char nextMove = this.actions[this.curAct % this.actions.length];
		int[] nextPos = this.cmd2Pos(nextMove);
		Cell nextCell = map.getCell(nextPos[0], nextPos[1]);
		if(nextCell != null && nextCell.setOccupant(this)){
			this.curAct += 1;
			this.row = nextPos[0];
			this.col = nextPos[1];
			this.occupying.removeOccupant();
			this.setOccupying(nextCell);
			System.out.printf("\033[1;31;46mGoblin enters the cell (%d, %d).\033[0;0m%n", this.row, this.col);
		}
		if (!this.active) {
			this.occupying.removeOccupant();
		}
	}
	
	@Override
	public boolean interactWith(GameCharacter comer) {
		if (comer.name.equals("Player")) {
			((Player)comer).setHp(((Player)comer).getHp() - this.damage);
			System.out.printf("\033[1;31;46mA goblin at cell (%d, %d) meets Player.\033[0;0m%n", this.row, this.col);
			this.setActive(false);
			return true;
		}
		return false;
	}
}