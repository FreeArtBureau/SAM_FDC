/**
 * The Agent class gives graphical feedback on drawing
 */

class Agent {

  PVector location;
  PVector velocity;
  PVector acceleration;
  boolean arrived;
  ArrayList<PVector> PNTS;
  PVector CURRENT_POS; // current postition for SAM
  int CURRENT_INDEX;
  float TARGET_DIST;
  float THRESH_MAX = 85;
  boolean bStart;
  float maxSpeed;
  float dia;
  color c;

  Agent(float _sp, float pointSize) {
    location = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    arrived = false;
    this.dia = pointSize;
    c = color(255, 200, 0);
    maxSpeed = _sp;
    PNTS = new ArrayList<PVector>();
    CURRENT_INDEX = 0;
    bStart = true;
  }

  void drawAgent(){
    if(bStart == false) return;

    boolean is_Finished = checkArrayLength(PNTS.size(), CURRENT_INDEX);

    if (is_Finished){
      bStart = false;
      println("Finished drawing, what next ?");
      CURRENT_INDEX = 0;
      bStart = true;
      is_Finished = false;
      c = color(255, random(200), random(100,255));
      //quitMachine();
    }

    moveTo(CURRENT_POS);
    boolean arrived = checkArrival();
    if (arrived) {
      PVector prevPos = CURRENT_POS;
      CURRENT_POS = chooseNextPosition();
      TARGET_DIST = calculateDistance(prevPos, CURRENT_POS);
    }

    //println(TARGET_DIST);
    if (TARGET_DIST>=THRESH_MAX) {
    } else {
      displayAgent();
    }
  }

  /**
   * A method that receives a new target destination and calculates distance
   * from current position. It then moves to this new target position.
   * It also switches the 'arrived' boolean
   */
  void moveTo(PVector target) {
    PVector distance = PVector.sub(target, location);  // A vector pointing from the location to the target
    // newDestination = distance minus Velocity
    PVector newDestination = PVector.sub(distance, velocity);
    acceleration.add(newDestination);

    // Check arrival and set boolean to true
    if ((target.x == location.x) || (target.y == location.y)) {
      arrived = true;
    }
  }

  /**
   * Method for checking arrival
   *
   */
  boolean checkArrival() {
    boolean t = false;
    if (arrived) {
      t = true;
    }
    arrived = false;
    return t;
  }

   PVector chooseNextPosition() {
     if (CURRENT_INDEX != PNTS.size()) {
       CURRENT_INDEX++;
     }
     PVector v = PNTS.get(CURRENT_INDEX);
     return v;
   }

  void setCoordPnts(ArrayList _p){
    PNTS = _p;
    CURRENT_POS = PNTS.get(0);
    location = CURRENT_POS;
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    acceleration.mult(0);
  }


  void displayAgent() {
    noStroke();
    fill(c);
    ellipse(location.x, location.y, dia, dia);
    //rect(location.x, location.y, dia, dia);
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
  * Calculate distance from previous position to target position
  */
  float calculateDistance(PVector _last, PVector _target) {
    float d = _last.dist( _target );
    return d;
  }
}
