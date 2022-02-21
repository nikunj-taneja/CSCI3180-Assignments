import java.util.*;
import java.io.*;

public class Engine {
	private ArrayList<Object> actors;
	private Map map;
	private Player player;
	
	public Engine(String dataFile) {
		this.actors = new ArrayList<Object>();
		this.map = null;
		this.player = null;
		
		try {
			BufferedReader reader = new BufferedReader(new FileReader(dataFile));
			String tempString = null;

			tempString = reader.readLine();
			String[] arr = tempString.split("\\s+");
			int rowNum = Integer.parseInt(arr[0]);
			int colNum = Integer.parseInt(arr[1]);
			int playerOxygen = Integer.parseInt(arr[2]);
			int playerHp = Integer.parseInt(arr[3]);
			int goblinNum = Integer.parseInt(arr[4]);
			int trapNum = Integer.parseInt(arr[5]);
			int volcanoNum = Integer.parseInt(arr[6]);

			this.map = new Map(rowNum, colNum);

			for (int i = 0; i < rowNum; ++i) {
				tempString = reader.readLine();
				String[] splitArr = tempString.split("\\s+");
				for (int j = 0; j < splitArr.length; ++j) {
					if (splitArr[j].equals("P")) {
						this.map.buildCell(i, j, new Plain(i, j));
					} else if(splitArr[j].equals("M")) {
						this.map.buildCell(i, j, new Mountain(i, j));
					} else if(splitArr[j].equals("S")) {
						this.map.buildCell(i, j, new Swamp(i, j));
					}
				}
			}
			
			this.player = new Player(rowNum - 1, 0, playerHp, playerOxygen);
			Cell initCell = this.map.getCell(rowNum - 1, 0);
			initCell.setOccupant(this.player);
			this.player.setOccupying(initCell);
			this.actors.add(this.player);
			
			for (int i = 0; i < goblinNum; ++i) {
				tempString = reader.readLine();
				String[] splitArr = tempString.split("\\s+");
				int goblinRow = Integer.parseInt(splitArr[0]);
				int goblinCol = Integer.parseInt(splitArr[1]);
				char[] goblinActions = new char[splitArr.length - 2];
				for (int j = 2; j < splitArr.length; ++j) {
					goblinActions[j - 2] = splitArr[j].charAt(0);
				}
				Goblin gob = new Goblin(goblinRow, goblinCol, goblinActions);
				this.actors.add(gob);
				initCell = this.map.getCell(goblinRow, goblinCol);
				initCell.setOccupant(gob);
				gob.setOccupying(initCell);
			}

			for (int i = 0; i < trapNum; ++i) {
				tempString = reader.readLine();
				String[] splitArr = tempString.split("\\s+");
				int trapRow = Integer.parseInt(splitArr[0]);
				int trapCol = Integer.parseInt(splitArr[1]);
				Trap trap = new Trap(trapRow, trapCol);
				initCell = this.map.getCell(trapRow, trapCol);
				initCell.setOccupant(trap);
				trap.setOccupying(initCell);
			}

			for (int i = 0; i < volcanoNum; ++i) {
				tempString = reader.readLine();
				String[] splitArr = tempString.split("\\s+");
				int volcanoRow = Integer.parseInt(splitArr[0]);
				int volcanoCol = Integer.parseInt(splitArr[1]);
				int volcanoFreq = Integer.parseInt(splitArr[2]);
				Volcano vol = new Volcano(volcanoRow, volcanoCol, volcanoFreq);
				this.actors.add(vol);
				this.map.buildCell(volcanoRow, volcanoCol, vol);
			}
			
			reader.close();
		} catch (IOException e) {
			System.out.println("read file error!");
		}
		
		
	}
	
	public void run() {
		this.printInfo();
		while (this.state() == 0) {
			for (int i = 0; i < this.actors.size(); ++i) {
				if (this.actors.get(i) instanceof GameCharacter) {
					if (((GameCharacter)this.actors.get(i)).getActive()) {
						((GameCharacter)this.actors.get(i)).act(this.map);
					}
				} else if (this.actors.get(i) instanceof Volcano) {
					if (((Volcano)this.actors.get(i)).getActive()) {
						((Volcano)this.actors.get(i)).act(this.map);
					}
				}
			}
			this.printInfo();
			this.cleanUp();
		}
		this.printResult();
	}
	
	public void cleanUp() {
		Iterator<Object> it = actors.iterator();
		while (it.hasNext()) {
			Object o = it.next();
			if (o instanceof GameCharacter) {
				if (!((GameCharacter)o).getActive()) {
					it.remove();
				}
			}
		}
	}
	
	public int state() {
		if (this.player.getHp() <= 0 || this.player.getOxygen() <= 0) {
			return -1;
		} else if (this.player.getRow() == 0 && this.player.getCol() == this.map.getCols() - 1) {
			return 1;
		} else {
			return 0;
		}
	}
	
	public void printInfo() {
		this.map.display();
		int trapNum = 0;
		ArrayList<Cell> cells = this.map.getNeighbours(this.player.getRow(), this.player.getCol());
		for (int i = 0; i < cells.size(); ++i) {
			Object occ = cells.get(i).getOccupant();
			if (occ instanceof Trap) {
				++trapNum;
			}
		}
		System.out.printf("Oxygen: %d, HP: %d, Trap: %d%n", this.player.getOxygen(), this.player.getHp(), trapNum);
	}
	
	public void printResult() {
		if (this.state() == 1) {
			System.out.println("\033[1;33;41mCongrats! You win!\033[0;0m");
		} else if (this.state() == -1) {
			System.out.println("\033[1;33;41mBad Luck! You lose.\033[0;0m");
		}
	}
}
