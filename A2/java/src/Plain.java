public class Plain extends Cell {
	
	public Plain(int row, int col) {
		super(row, col);
		this.color = "\033[1;32;42m";
		this.hours = 1;
	}
}