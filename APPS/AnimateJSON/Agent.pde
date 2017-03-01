/**
 * The Agent class gives graphical feedback on drawing
 * updated : 01.03.16
 */


class Agent {
  PGraphics pg;
  ArrayList<PVector> PNTS;
  PVector CURRENT_POS;
  int COORDS_DATA_LENGTH, CURRENT_INDEX;

  PVector LOC, VEL, VELDIR;
  boolean PEN_UP, PEN_DOWN, ARRIVED, FINISHED_DRAWING;
  float TARGET_DIST;
  boolean bStart = false;
  float MAX_SPEED;
  float THRESH_MAX = 40;
  float dia;
  float hue;
  float SCALING;


  Agent(float _sp, float pointSize) {
    PNTS = new ArrayList<PVector>();
    LOC = new PVector(0, 0);
    VEL = new PVector(0, 0);
    CURRENT_POS = new PVector();

    ARRIVED = false;
    FINISHED_DRAWING = false;
    TARGET_DIST = 0.0;
    this.MAX_SPEED = _sp;
    bStart = false;
    this.dia = pointSize;
    hue = 89;
    pg = createGraphics(width, height);
  }

  void drawAgent(float _drawingSp, float _x, float _y, float _s){
    this.MAX_SPEED = _s;
    this.SCALING = _s;
    /////////////////////////////////
    boolean is_Finished = checkArrayLength(COORDS_DATA_LENGTH, CURRENT_INDEX);
    if (is_Finished) {
      FINISHED_DRAWING = true;
      CURRENT_INDEX = 0;
      hue = random(360);
      println(hue);
      clearScreen();
      //drawingYPos += 90; ///////   NOT HERE !!!
    }else{
            FINISHED_DRAWING = false;
    }

    if (ARRIVED) {
      PVector prevPos = (PVector)PNTS.get(CURRENT_INDEX);
      CURRENT_POS = chooseNextPosition();
      computeVELDirection(prevPos, CURRENT_POS);
      TARGET_DIST = calculateDistance(prevPos, CURRENT_POS);
      ARRIVED = false;
    }
    /*
     * When we move, do we move with pen down or pen up ?
     * Depends on THRESH_MAX variable
     */
    if (TARGET_DIST>=THRESH_MAX) {
    } else {
      displayAgent(_x,_y,_s);
    }

    // Move to new position
    VEL.x = _drawingSp*VELDIR.x;
    VEL.y = _drawingSp*VELDIR.y;
    //VEL.limit(MAX_SPEED);
    LOC.add(VEL);

    if (dist(LOC.x, LOC.y, CURRENT_POS.x, CURRENT_POS.y) <= 3.3) {
      LOC.set(CURRENT_POS);
      displayAgent(_x,_y,_s);
      ARRIVED = true;
    }
    image(pg,0,0);
  }

  void clearScreen(){
    pg.beginDraw();
    pg.background(237,100,12);
    pg.endDraw();
  }

  void computeVELDirection(PVector _pos, PVector _target){
      VELDIR = PVector.sub(_target, _pos);
      VELDIR.normalize();
      }

   PVector chooseNextPosition() {
     if (CURRENT_INDEX != PNTS.size()-1) {
       CURRENT_INDEX++;
     }
     PVector v = PNTS.get(CURRENT_INDEX);
     return v;
   }

  void setCoordPnts(ArrayList _p){
    PNTS = _p;
    CURRENT_POS = PNTS.get(0);
    LOC = CURRENT_POS;
    this.COORDS_DATA_LENGTH = PNTS.size();
    computeVELDirection(LOC, CURRENT_POS);
    FINISHED_DRAWING = false;
  }

  void displayAgent(float _x, float _y, float _s) {
    //int w = int(1280*_s);
    //int h = int(740*_s);
    //pg = createGraphics(w, h);
     pg.beginDraw();
     pg.colorMode(HSB,360,100,100);
     pg.noStroke();
    //hue = _h;
    pg.fill(hue,100,100);
    pg.pushMatrix();
    pg.translate(_x,_y);
    pg.scale(_s);
    pg.ellipse(LOC.x, LOC.y, dia, dia);
    pg.popMatrix();
    pg.endDraw();
  }

  void displayPoints(){
    fill(1,100,100);
    noStroke();
      for(int i=0; i<PNTS.size();i++){
        ellipse(PNTS.get(i).x, PNTS.get(i).y, 2,2);
      }
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
