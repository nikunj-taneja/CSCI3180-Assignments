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
		this.curAct += 1;
		if(nextCell != null && nextCell.setOccupant(this)){
			this.row = nextPos[0];
			this.col = nextPos[1];
			this.occupying.removeOccupant();
			this.setOccupying(nextCell);
			System.out.printf("\033[1;31;46mGoblin enters the cell (%d, %d).\033[0;0m%n", this.row, this.col);
		}
		if (!this.active) {
			System.out.println("\033[1;31;46mGoblin dies right after the movement.\033[0;0m");
			this.occupying.removeOccupant();
		}
	}
	
	@Override
	public boolean interactWith(Object comer) {
		if (comer instanceof Player) {
			((Player)comer).setHp(((Player)comer).getHp() - this.damage);
			System.out.printf("\033[1;31;46mA goblin at cell (%d, %d) meets Player. The goblin died. Player\'s HP - %d.\033[0;0m%n", this.row, this.col, this.damage);
			this.setActive(false);
			return true;
		}
		return true;
	}
}