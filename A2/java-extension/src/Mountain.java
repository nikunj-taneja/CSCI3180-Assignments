public class Mountain extends Cell {
	
	public Mountain(int row, int col) {
		super(row, col);
		this.color = "\033[1;37;47m";
	}
	
	@Override
	public boolean setOccupant(Object obj) {
		return false; 
	}
}