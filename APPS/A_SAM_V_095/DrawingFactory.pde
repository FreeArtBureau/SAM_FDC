/*
 * Factory Method Pattern
 * SOFT used for Fête du Code Pompidou March 2017
 */
//////////////////////////////////////////////////
public interface DrawingFactory {
  public void setup();
  public void draw();
  public void keyPressed();
}

//////////////////////////
public class FreeHand implements DrawingFactory {
  PT_ArrayList<PVector> STRATEGY_COORDS;

  public void setup() {
    STRATEGY_COORDS = new PT_ArrayList<PVector>();
  }

  void draw() {
    if (mousePressed) {
      int x = mouseX;
      int y = mouseY;
      fill(0, 0, 255);
      ellipse(x, y, 3, 3);
      PVector savedCoords = new PVector(x, y, 0);
      STRATEGY_COORDS.addItem(savedCoords);
    }
  }

  public void keyPressed() {
    if (key == 'l') {
      println("SavedCoords data length = "+STRATEGY_COORDS.getSize());
    }
    if(key == 'c'){
      background(0);
      STRATEGY_COORDS.clearData();
      println("Cleared stored data = "+STRATEGY_COORDS.getSize());
    }
  }

}

//////////////////////////////////////////////////////////////////////////////
public class DrawingMethod {
  public DrawingFactory createDrawingMethod(String _dType) {
    if (_dType == null) {
      return null;
    }
    if (_dType.equalsIgnoreCase("FREE")) {
      return new FreeHand();
    }
    return null;
  }
}
