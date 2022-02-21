import java.util.*;

public class Player extends GameCharacter {
	private int hp;
	private int oxygen;
	private char[] validActions;
	
	public Player(int row, int col, int hp, int oxygen) {
		super(row, col);
		validActions = new char[4];
		validActions[0] = 'U';
		validActions[1] = 'D';
		validActions[2] = 'R';
		validActions[3] = 'L';
		this.hp = hp;
		this.oxygen = oxygen;
		this.name = "Player";
		this.character = 'A';
	}

	public int getOxygen() {
		return this.oxygen;
	}
	
	public int getHp() {
		return this.hp;
	}
	
	public void setHp(int h) {
		this.hp = h;
	}

	public void setOxygen(int o) {
		this.oxygen = o;
	}
	
	@Override
	public void act(Map map) {
		Cell nextCell = null;
		int[] nextPos = new int[2];
		nextPos[0] = 0;
		nextPos[1] = 0;
		while (nextCell == null) {
			boolean correctAct = false;
			do {
				System.out.printf("Next move (U, D, R, L): ");
				Scanner input = new Scanner(System.in);
				String inputString = input.next();
				char nextAct = inputString.charAt(0);
				for (int i = 0; i < this.validActions.length; ++i) {
					if (validActions[i] == nextAct) {
						correctAct = true;
						break;
					}
				}
				if (inputString.length() > 1) correctAct = false;
				if (!correctAct) {
					System.out.printf("Invalid command. Please enter one of {U, D, R, L}.%n");
				} else {
					nextPos = this.cmd2Pos(nextAct);
				}
			} while(!correctAct);
			
			nextCell = map.getCell(nextPos[0], nextPos[1]);
			if (nextCell != null && nextCell.setOccupant(this)) {
				this.row = nextPos[0];
				this.col = nextPos[1];
				this.oxygen -= this.occupying.getHours();
				this.occupying.removeOccupant();
				this.setOccupying(nextCell);
			} else {
				nextCell = null;
			}
		}
	}
	
	@Override
	public boolean interactWith(GameCharacter comer) {
		if (comer.name.equals("Goblin")) {
			System.out.printf("\033[1;31;46mPlayer meets a Goblin! Player's HP - %d.\033[0m%n", ((Goblin)comer).getDamage());
			this.hp -= ((Goblin)comer).getDamage();
			((Goblin)comer).setActive(false);
			return false;
		}
		return false;
	}
}