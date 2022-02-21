public class Swamp extends Cell {
	
	public Swamp(int row, int col) {
		super(row, col);
		this.color = "\033[1;34;44m";
		this.hours = 2;
	}
}