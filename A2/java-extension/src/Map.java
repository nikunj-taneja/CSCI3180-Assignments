import java.util.ArrayList;

public class Map {
	private int rows;
	private int cols;
	private Cell[][] cells;
	
	public Map(int rows, int cols) {
		this.rows = rows;
		this.cols = cols;
		cells = new Cell[this.rows][this.cols];
	}

	public int getCols() {
		return this.cols;
	}

	public int getRows() {
		return this.rows;
	}
	
	public Cell getCell(int row, int col) {
		if (row < 0 || row >= this.rows || col < 0 || col >= this.cols) {
			System.out.printf("\033[1;31;46mNext move is out of boundary!\033[0;0m%n");
			return null;
		} else {
			return this.cells[row][col];
		}
	}
	
	public boolean buildCell(int row, int col, Cell cell) {
		if (row >= 0 && row < this.rows && col >= 0 && col < this.cols) {
			this.cells[row][col] = cell;
			return true;
		} else {
			System.out.printf("\033[1;31;46mThe position (%d, %d) is out of boundary!\033[0;0m%n", row, col);
			return false;
		}
	}
	
	public ArrayList<Cell> getNeighbours(int row, int col) {
		ArrayList<Cell> returnCells = new ArrayList<Cell>();
		for (int i = Math.max(0, row - 1); i <= Math.min(row + 1, this.rows - 1); ++i) {
			for (int j = Math.max(0, col - 1); j <= Math.min(col + 1, this.cols - 1); ++j) {
				returnCells.add(this.cells[i][j]);
			}
		}
		return returnCells;
	}
	
	public void display() {
		System.out.printf("   ");
		for (int i = 0; i < this.cols; ++i) {
			System.out.printf("%d     ", i);
		}
		System.out.printf("%n");
		for (int i = 0; i < this.rows; ++i) {
			System.out.printf("%d ", i);
			for (int j = 0; j < this.cols; ++j) {
				this.cells[i][j].display();
			}
			System.out.printf("%n%n");
		}
	}
}