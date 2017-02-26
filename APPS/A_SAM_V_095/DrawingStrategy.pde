/*
 * * Abstract Drawing Strategy Class
 * - Determines what to draw with SAM
 * - THIS IS THE MAIN CLASS FOR EXTENDING DRAWING FUNCTIONALITIES
 * SOFT used for Fête du Code Pompidou March 2017
 */
//////////////////////////////////////////////////
// >> Globals shared with this class
public boolean SAVE_DRAWING_COORDS;

////////////////////////////////////////

public abstract class DrawingStrategy {
  public PT_ArrayList<PVector> STRATEGY_COORDS;
  String AUTHOR;
  String TITLE;
  public RShape SHP;
  public String IMGName;

  public void setup() {
  }


  public void initStrategy() {
    SAVE_DRAWING_COORDS = false;
    STRATEGY_COORDS = new PT_ArrayList<PVector>();
    SHP = RG.loadShape(IMGName);
    String message = "Strategies initialised";
    MSG.addMessage("SetUp_MSG", message);
  }

  public void draw() {

  }

  public String getStrategy() {
    String s = TITLE;
    return s;
  }

  /* Copies coordinates from on-screen drawing
   * @param : drawing coordinates
   */
  public void addCoords(PVector _receivedCoords) {
    STRATEGY_COORDS.addItem(_receivedCoords); // this way ?
    String message = "Added coordinates";
    MSG.addMessage("Control MSG", message);
    //STRATEGY_COORDS.removeDups(); // remove any duplicate data ;—)
  }
}

////////////////////////////////////////////////// END MAIN ABSTRACT CLASS
