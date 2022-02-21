import java.util.ArrayList;

public class Volcano extends Mountain {
	private int countdown;
	private int frequency;
	private boolean active;

	public Volcano(int row, int col, int freq) {
		super(row, col);
		this.countdown = freq;
		this.frequency = freq;
		this.color = "\u001b[41m";
		this.active = true;
	}

	public void act(Map map) {
		this.countdown -= 1;
		if (this.countdown == 0) {
			System.out.println("\033[1;33;41mVolcano erupts! \033[0;0m");
			this.countdown = this.frequency;
			ArrayList<Cell> cells = map.getNeighbours(this.row, this.col);
			for (int i = 0; i < cells.size(); ++i) {
				Object occ = cells.get(i).getOccupant();
				if(occ != null) {
					if (occ instanceof Goblin) {
						((Goblin)occ).setActive(false);
						((Goblin)occ).occupying.removeOccupant();
					} else if (occ instanceof Player) {
						((Player)occ).setHp(((Player)occ).getHp() - 1);
					}
				}
			}
		}
	}

	@Override
	public void display() {
		System.out.format("%s \033[2;97m%d%s \033[0m   ", this.color, this.countdown, this.color);
	}

	// add for java
	public boolean getActive() {
		return this.active;
	}
}