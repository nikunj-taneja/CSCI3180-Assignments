import java.util.*;

public class StrangePlanet {
	public static void main(String[] args) {
		String dataFile = "input/map-basic.txt";
		// String dataFile = "input/map-extension.txt";
		Engine eng = new Engine(dataFile);
		eng.run();
	}
}
