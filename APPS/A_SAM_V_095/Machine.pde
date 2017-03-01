/*
 * The Machine class manages coordinate data received from the Drawing Strategy class.
 * This data is then sent to the Serial via SamSerialData class
 * SOFT used for Fête du Code Pompidou March 2017
 */

//////////////////////////////////////////////////
// >> Globals shared with this class
float THRESH_MAX; // needs to be an interface var
float MAX_SPEED;
float imgOffsetX = 15;
float imgOffsetY = 15;

////////////////////////////////////

class Machine {
  SamSerialData SAM;
  PT_ArrayList<PVector> DRAW_COORDS;
  PVector COORDS_TO_SAM;
  PVector CURRENT_POS;
  int COORDS_DATA_LENGTH, CURRENT_INDEX;

  PVector LOC, VEL, VELDIR;
  boolean PEN_UP, PEN_DOWN, ARRIVED, FINISHED_DRAWING;
  float TARGET_DIST;
  int Z_DIST, Z_CAL, Z_DIFF;
  float PNT_SIZE;
  color PNT_COL;
  //PVector MACHINE_ORIGIN;
  boolean bStart = false;

  Rolex drawingStopWatch; // for timing drawing proceedures
  Timer timer;
  float dt; // time between two successive call to draw (in seconds)

  // Basic Machine setup with boolean on/off for Serial connection
  Machine(PApplet _P5, boolean _port)
  {
    SAM = new SamSerialData(_P5);
    drawingStopWatch = new Rolex();
    if (_port) {
      SAM.initSerial();
    }
    bStart = false;
  }

  void initMachine() {
    Z_CAL = 0;
    Z_DIST = 0;
    Z_DIFF = 30;
    LOC = new PVector(0, 0);
    VEL = new PVector(0, 0);
    CURRENT_POS = new PVector();

    ARRIVED = false;
    FINISHED_DRAWING = false;
    TARGET_DIST = 0.0;
    PNT_SIZE = 2;
    PNT_COL = color(150, 255, 0);
    MSG.printOutHashEntries(); // prints out HASH messages
    penUp();
    DRAWING = false;

    bStart = false;
    imgOffsetX*=PIXEL_SCALE;
    imgOffsetY*=PIXEL_SCALE;
  }

  ///////////////////////////////////////////////////////// MAIN METHODS FOR MOVING
  /*
   * Moves machine to first saved coordinate
   */
  void moveToFirstCoord() {
    CURRENT_INDEX=0;
    LOC = DRAW_COORDS.getItem(CURRENT_INDEX);
    CURRENT_POS = DRAW_COORDS.getItem(CURRENT_INDEX+1);
    computeVELDirection(LOC, CURRENT_POS);
    movePenUpOrDown(LOC, CURRENT_POS);

    String message = "Moving to first coordinate";
    MSG.addMessage("Control MSG", message);
    PNT_COL = color(255, 0, 0);
    PNT_SIZE = 7;

    bStart = true;
    timer = new Timer();
  }

  /*
   * Moves machine to each saved coordinate
   * & continues until the end of Array
   */
  void draw() {
    if (bStart == false) return;

    //    dt = timer.dt();

    PNT_COL = color(150, 255, 0);
    PNT_SIZE = 3;
    String message = "SAM is currently busy drawing";
    MSG.addMessage("Control MSG", message);

    /////////////////////////////////
    boolean is_Finished = checkArrayLength(COORDS_DATA_LENGTH, CURRENT_INDEX);
    if (is_Finished)
    {
      bStart = false;
      quitMachine();
    }

    if (ARRIVED)
    {
      // d = v*t;
      PVector prevPos = (PVector)DRAW_COORDS.getItem(CURRENT_INDEX);
      CURRENT_POS = chooseNextPosition();
      computeVELDirection(prevPos, CURRENT_POS);
      TARGET_DIST = calculateDistance(prevPos, CURRENT_POS);
      //movePenUpOrDown(prevPos, CURRENT_POS);
      ARRIVED = false;
    }
    /*
     * When we move, do we move with pen down or pen up ?
     * Depends on THRESH_MAX variable
     */
    if (TARGET_DIST>=THRESH_MAX) {
      penUp();
    } else {
      penDown();
    }

    // Move to new position
    //moveTo(CURRENT_POS);
    VEL.x = MAX_SPEED*VELDIR.x;
    VEL.y = MAX_SPEED*VELDIR.y;
    LOC.add(VEL);

    //float
    if (dist(LOC.x, LOC.y, CURRENT_POS.x, CURRENT_POS.y) <= 3.5)
    {
      LOC.set(CURRENT_POS);
      penDown();
      ARRIVED = true;
    }
  }

  void movePenUpOrDown(PVector pos, PVector target) {
    if (TARGET_DIST>=THRESH_MAX) {
      penUp();
    } else {
      penDown();
    }
  }

  void computeVELDirection(PVector _pos, PVector _target)
  {
    VELDIR = PVector.sub(_target, _pos);
    VELDIR.normalize();
  }


  /*
   * Calculate distance from previous position to target position
   */
  float calculateDistance(PVector _last, PVector _target) {
    float d = _last.dist( _target );
    return d;
  }

  void penUp() {
    PEN_UP = true;
    PEN_DOWN = false;
  }

  void penDown() {
    PEN_DOWN = true;
    PEN_UP  = false;
    displayDrawing();
  }

  /*
   * Chooses the next position to draw to based on index linear read
   */
  PVector chooseNextPosition() {
    PVector v = new PVector(0, 0);
    CURRENT_INDEX++;
    if (CURRENT_INDEX < DRAW_COORDS.getSize()) {
      v = (PVector)DRAW_COORDS.getItem(CURRENT_INDEX);
    }
    return v;
  }

  /*
   * Check if arrived at end of arrayList
   * @param _s is the current index for the machine
   */
  boolean checkArrayLength(int _len, int _index) {
    boolean b = false;
    if (_index == _len-1) {
      b = true;
    }
    return b;
  }

  /*
   * Keeping all the motion update stuff here
   */
  void update() {
    COORDS_TO_SAM = new PVector();

    if (PEN_UP) {
      COORDS_TO_SAM = new PVector (0, 0, Z_DIFF+Z_DIST);
      COORDS_TO_SAM.add(LOC);
    }

    if (PEN_DOWN) {
      COORDS_TO_SAM = new PVector (0, 0, Z_DIST);
      COORDS_TO_SAM.add(LOC);
    }

    if (FINISHED_DRAWING) {
      COORDS_TO_SAM = new PVector (LOC.x, LOC.y, 10);
      VEL = new PVector(0, 0);
      LOC.add(VEL);
    }

    ////////////////////////////////////// IMPORTANT
    SAM.updateSerialData( COORDS_TO_SAM );
  }

  void quitMachine() {
    String msg = "Finished drawing, what next ?";
    MSG.addMessage("Control MSG", msg); // see HASH class
    FINISHED_DRAWING = true;
    DRAWING = false; // this is bad having globals here ?
    drawingStopWatch.stop();
  }

  /*
   * Display drawing
   */
  void displayDrawing() {
    noStroke();
    fill(PNT_COL);
    ellipse(LOC.x, LOC.y, PNT_SIZE, PNT_SIZE);
  }

  /*
   * Method for getting coordinate data
   */
  void setCoordinates(PT_ArrayList _receivedCoords) {
    this.DRAW_COORDS = new PT_ArrayList<PVector>();
    //this.DRAW_COORDS = _receivedCoords; // copy or reference ?
    for (int i=0; i<_receivedCoords.getSize (); i++) {
      PVector p = (PVector)_receivedCoords.getItem(i);
      this.DRAW_COORDS.addItem(p);
    }
    //this.DRAW_COORDS.addItem(_receivedCoords); // this way ?
    this.COORDS_DATA_LENGTH = DRAW_COORDS.getSize();
  }


  /*
   * Method for setting the machine origins
   * We update the PVector : MACHINE_ORIGIN


   void setMachineOrigins() {
   MACHINE_ORIGIN = new PVector();
   MACHINE_ORIGIN.x = 0;
   MACHINE_ORIGIN.y = 0;
   MACHINE_ORIGIN.z = Z_DIFF;

   println("-------------------------------------");
   println("The machine has been calibrated");
   println("and is ready to draw.");
   println("-------------------------------------");
   }
   */
  ////////////////////////////////////////////////////////// KEYS
  public void keyPressed() {
    if (key == 'c') {
      //setMachineOrigins();
    }

    if (key == '+') {
      Z_CAL+=1;
      Z_DIST=Z_CAL;
      println("This is the current value for Z_DIST = "+Z_DIST);
    }
    if (key == '-') {
      Z_CAL-=1;
      Z_DIST=Z_CAL;
      println("This is the current value for Z_DIST = "+Z_DIST);
    }

    if (keyCode == RIGHT) {
      LOC.x+=imgOffsetX;
    }

    if (keyCode == LEFT) {
      LOC.x-=imgOffsetX;
    }

    if (keyCode == UP) {
      LOC.y-=imgOffsetY;
    }
    if (keyCode == DOWN) {
      LOC.y+=imgOffsetY;
    }
  }
}
///////////////////////////////////////////////// END MACHINE CLASS
