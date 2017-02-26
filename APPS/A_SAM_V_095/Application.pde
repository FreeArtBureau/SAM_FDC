/*
 * Brings all operations together :
 * Strategy > Machine > SAM via Serial
 * SOFT used for Fête du Code Pompidou March 2017
 */

//////////////////////////////////////////////////
// >> Globals shared with this class
int STRATEGY_INDEX = 3;
boolean FIRST_COORD, DRAWING, SHOW_STRATEGY, PAUSED;
//boolean LIVE = true;

//////////////////////////////////////////////////
class Application {
  ArrayList <DrawingStrategy> theStrategies;
  DrawingStrategy CURRENT_DS; // currently selected drawing strategy
  Machine theMachine;
  DrawingFactory theFactoryStrategy;

  ///////////////////////////////////
  // Basic set up with Serial Port Communication & initial machine coords
  public Application(PApplet _p5, boolean _port) {
    theMachine = new Machine(_p5, _port);
  }

  //////////////////////////////////////// MAIN SETUP & DRAW
  public void initApp() {
    DRAWING = false;
    FIRST_COORD = false;
    SHOW_STRATEGY = true;
    PAUSED = false;
    theStrategies = new ArrayList <DrawingStrategy>();
    addStrategiesToApp();
    CURRENT_DS = theStrategies.get(STRATEGY_INDEX);
    theMachine.initMachine();

    String message = "Application initialised";
    MSG.addMessage("SetUp_MSG", message);
  }


  /*
   * MAIN DRAWING METHOD & UPDATING OF DRAWING PROCESS
   */
  public void draw() {

    if (SHOW_STRATEGY) {
      CURRENT_DS.draw();
    }

    if (FIRST_COORD) {
      theMachine.moveToFirstCoord();
    }

//    println(theMachine.LOC);


    if ( DRAWING ) {
      theMachine.draw();
    }

    // Possible live drawing method ?
    //  if ( LIVE ) {
    //    theFactoryStrategy.draw();
    // }
  }

  public void update() {
    theMachine.update();
  }

  /*
   * Setting up list of drawing strategies
   * We instanciate all classes with constructor
   * & with setup methods; initStrategy() / setup()
   */
  public void addStrategiesToApp() {
    clear();
    theStrategies.add(new FreeDraw());
    theStrategies.add(new RandomPoints());
    theStrategies.add(new GeoType()); // we get a java #text error message from here (geomerative ?)
    theStrategies.add(new AnneAlgo());
    theStrategies.add(new JDraw());

    for (DrawingStrategy ds : theStrategies) {
      ds.initStrategy();
      ds.setup();
    }
  }

  private void clear() {
    background(0);
  }

  // Add drawing strategies from DrawingFactory:
  public void addStrategy(DrawingFactory _df) {
    this.theFactoryStrategy = _df;
    this.theFactoryStrategy.setup();
  }

  ////////////////////////////////////////////////////////////// KEYS

  public void keyPressed() {
    //CURRENT_DS.keyPressed();
    theMachine.keyPressed();


    if (key == 'r') {
      initApp();
    }

    if (key == 'p') {
      PAUSED = !PAUSED;
      if ( PAUSED ) {
        println("TAKING A BREAK SAM ?");
        String message = "Taking a break ?";
        MSG.addMessage("Control MSG", message);
        noLoop();
      } else {
        loop();
        println("ALRIGHT, LETS SKA !");
        String message = "Alright, let's SKA !";
        MSG.addMessage("Control MSG", message);
      }
    }
  }
}

///////////////////////////////////////// APPLICATION END
