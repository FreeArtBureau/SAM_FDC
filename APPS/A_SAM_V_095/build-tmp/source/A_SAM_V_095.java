import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import geomerative.*; 
import controlP5.*; 
import java.util.*; 
import java.text.*; 
import vsync.*; 
import processing.serial.*; 
import java.util.*; 
import java.util.Map; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class A_SAM_V_095 extends PApplet {


/* *********
 * \u2554\u2550\u2557\u2554\u2550\u2557\u2554\u2566\u2557
 * \u255a\u2550\u2557\u2560\u2550\u2563\u2551\u2551\u2551
 * \u255a\u2550\u255d\u2569 \u2569\u2569 \u2569
 * *********
 *
 * SAM_SOFT_dev_095 using P5 V2.2.1 [dev 25.02.17]
 *
 *   NOTES TO SELF :
 *   SOFT used for F\u00eate du Code Pompidou March 2017
 *
 */
/////////////////////////// LIBRARIES /////////////////////////





/////////////////////////// GLOBALS ////////////////////////////
Application APP;
// Possibility of adding other drawing methods through the DrawingFactory interface
DrawingMethod DM = new DrawingMethod();
DrawingFactory DF = DM.createDrawingMethod("FREE");
Hash MSG;
int jsonFileIndex = 2;

/////////////////////////// SETUP ////////////////////////////

public void setup() {
  size(1240, 720);
  background(0);
  smooth();
  noStroke();
  RG.init(this);
  MSG = new Hash(); // keeps track of system messages

  //Boolean for turning Serial Comm ON/OFF
  APP = new Application(this, false);
  APP.addStrategy( DF ); // add drawingFactory manually
  APP.initApp();
  infoFont = createFont("FiraMono-Regular", 12);
  //Interface : ControlP5
  guiInit();
}

/////////////////////////// DRAW ////////////////////////////
public void draw() {
  APP.draw();
  APP.update();

  displayInfo();
}

/////////////////////////// FUNCTIONS ///////////////////////
public void keyPressed() {
  APP.keyPressed();
}
/*
 * Brings all operations together :
 * Strategy > Machine > SAM via Serial
 * SOFT used for F\u00eate du Code Pompidou March 2017
 */

//////////////////////////////////////////////////
// >> Globals shared with this class
int STRATEGY_INDEX = 4;
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
/*
 -------------------
 SOME CONFIGURATIONS
 -------------------
 *******************
* SOFT used for F\u00eate du Code Pompidou March 2017

 *******************
 -------------------------------
 Example _01
 Strategy : ANNE ALGO
 Pixel Scale : 30 (gave 23 X 25cm)

 Thresh : 73
 Speed : 1.73
 Segment : 25
 Duration : 5 minutes
 -------------------------------
 Example _02
 Strategy : ANNE ALGO
 Pixel Scale : 35 (gave 23 X 25cm)

 Thresh : 60
 Speed : 1.30
 Segment : 35
 Duration : 15 minutes
 -------------------------------

  -------------------------------
 Example _03
 Strategy : ANNE ALGO
 Pixel Scale : 15 (gave 11 X 13cm)

 Thresh : 1
 Speed : .30
 Segment : 60
 intervalle : 6
 Duration : 30 minutes
 -------------------------------
 -------------------------------
 Example _04
 Strategy : ANNE ALGO
 Pixel Scale : 15 (gave 11 X 13cm)

 Thresh : 45
 Speed : 2.50
 Segment : 55
 intervalle : 2
 Duration : 10 minutes
 -------------------------------

  -------------------------------
 Example _05 [NICO_Layers]
 Strategy : ANNE ALGO
 Pixel Scale : 40 (gave 25 X 30cm)

 Thresh : 60
 Speed : 1.73
 Segment : 52
 intervalle : 3
 Duration : 10 minutes
 -------------------------------

 -------------------------------
 Example _06 [M_Layers] - SolidGold Limited Edition !
 Strategy : ANNE ALGO
 Pixel Scale : 35 (gave 35 X 45/50cm)

 Thresh : 60
 Speed : 1.00
 Segment : 25
 intervalle : 2
 Duration : 15 minutes
 -------------------------------


 -------------------------------
 Example _07 ALGO
 Strategy : ANNE ALGO
 Pixel Scale : 15 (gave 11 X 13cm)

 Thresh : 60
 Speed : 1.50
 Segment : 1
 intervalle : 1
 Duration : 10 minutes
 -------------------------------

  -------------------------------
 Example _08 ALGO
 Strategy : BLOB : 6 Layers printed separately
 Pixel Scale : 40 //(gave 11 X 13cm)

 Thresh : 24
 //Speed : 1.50
 Segment : 20
 intervalle : 4
 Duration : 2.33 minutes (180 points approx+
 -------------------------------





*/

/*
 * Some simple examples of custom drawing strategies
 * Can by written easily by others by extending the above main abstract class
 * SOFT used for F\u00eate du Code Pompidou March 2017
 */

//////////////////////////////////////////////////
// >> Globals shared with these classes
int SEGMENT;
int INTERVALLE;
String FILE_DIR = "/Users/markwebster/Google Drive/Pomp_Files/json/";
String JSONFileName = "SAM_dessin_11_20_41.json";


public class FreeDraw extends DrawingStrategy {
  public void setup() {
    AUTHOR = "Mark";
    TITLE = "FreeDraw";
    background(0);
  }
  public void draw() {
    if (mousePressed) {
      int x = mouseX;
      int y = mouseY;
      fill(0, 0, 255);
      noStroke();
      ellipse(x, y, 3, 3);
      PVector drawingCoords = new PVector(x, y);

      // add coordinates
      PVector savedCoords = new PVector(x, y, 0);
      addCoords(savedCoords);
    }
  }
}

public class RandomPoints extends DrawingStrategy {
  public void setup() {
    AUTHOR = "Mark";
    TITLE = "RandomPoints";
    background(0);
  }
  public void draw() {
    randomSeed(1);
    drawPoints();
  }

  public void drawPoints() {
    background(0);
    for (int i=0; i<20; i++) {
      float xPos = random(50, width-50);
      float yPos = random(50, height-50);
      PVector p = new PVector(xPos, yPos);
      fill(0, 200, 255);
      ellipse(p.x, p.y, 15, 15);

      // add coordinates
      if (SAVE_DRAWING_COORDS) {
        addCoords(p);
      }
    }
    if (SAVE_DRAWING_COORDS) {
      SAVE_DRAWING_COORDS =!SAVE_DRAWING_COORDS;
    }
  }
}


public class GeoType extends DrawingStrategy {
  RFont f;
  RShape s;
  RShape polyshp;
  RPoint[] points;
  int widthTranslate;
  int heightTranslate;

  public void setup() {
    f = new RFont("SourceSansPro-Bold.ttf", 233);
    s = f.toShape("sam");
    points = s.getPoints();
    AUTHOR = "Mark";
    TITLE = "GeoType";
    widthTranslate = width/8;
    heightTranslate = height/2;
    //println("W = "+widthTranslate+"\n H = "+heightTranslate);
  }

  public void draw() {
    background(0);
    pushMatrix();
    translate(widthTranslate, heightTranslate);

    RCommand.setSegmentLength(SEGMENT);
    polyshp = RG.polygonize(s);
    RPoint[] points = s.getPoints();

    for (int i=0; i<points.length; i++) {
      // add coordinates
      if (SAVE_DRAWING_COORDS) {
        PVector savedCoords = new PVector((points[i].x+widthTranslate), (points[i].y+heightTranslate));
        addCoords(savedCoords);
      }
      noFill();//
      strokeWeight(6);
      stroke(55, 200, 255);
      point(points[i].x, points[i].y);
    }
    if (SAVE_DRAWING_COORDS) {
      SAVE_DRAWING_COORDS =!SAVE_DRAWING_COORDS;
    }
    popMatrix();
  }
}

public class AnneAlgo extends DrawingStrategy {
  RShape polyshp;
  RPoint[] points;

  public void setup() {
    AUTHOR = "Mark";
    TITLE = "AnneALgo";
    IMGName = "anne_algo.svg";
    SHP = RG.loadShape(IMGName);

  }

  public void draw() {
    background(0);
    noFill();
    strokeWeight(2);
    stroke(55, 200, 255);
    RCommand.setSegmentLength(SEGMENT);
    polyshp = RG.polygonize(SHP);
    RPoint[] points = SHP.getPoints();

    for (int i=0; i<points.length; i+=INTERVALLE) {
      // add coordinates
      if (SAVE_DRAWING_COORDS) {
        PVector savedCoords = new PVector((int)(points[i].x), (int)(points[i].y));
        addCoords(savedCoords);
      }
      // Display coords as points
      point(points[i].x, points[i].y);
    }

    if (SAVE_DRAWING_COORDS) {
      SAVE_DRAWING_COORDS =!SAVE_DRAWING_COORDS;
    }
  }
}

/*
 * JSON drawing : ADDED 02.2017
 */

 public class JDraw extends DrawingStrategy {

   JsonData data;
   ArrayList<PVector> POINTS;

   public void setup() {
     AUTHOR = "Mark";
     TITLE = "JDraw";
     POINTS = new ArrayList<PVector>();
     data = new JsonData(0);
     data.loadData(0);
     println("JSON data size = "+data.getSize());
     POINTS=data.getPoints();

   }

   public void draw() {
     background(0);
     noFill();
     strokeWeight(2);
     stroke(55, 200, 255);

     for (int i=0; i<POINTS.size(); i++) {
       PVector savedCoords = new PVector(POINTS.get(i).x, POINTS.get(i).y);
       // add coordinates
       if (SAVE_DRAWING_COORDS) {
         addCoords(savedCoords);
       }
       // Display coords as points
       point(POINTS.get(i).x, POINTS.get(i).y);
     }

     if (SAVE_DRAWING_COORDS) {
       SAVE_DRAWING_COORDS =!SAVE_DRAWING_COORDS;
     }
   }
 }

/*
 * JSON drawing with offset : ADDED 02.2017
 */

 public class JDrawWithOffset extends DrawingStrategy {

   JsonData data;
   ArrayList<PVector> POINTS;
   PVector offset;

   public void setup() {
     AUTHOR = "Mark";
     TITLE = "JDraw";
     POINTS = new ArrayList<PVector>();
     data = new JsonData(0);
     data.loadData(0);
     println("JSON data size = "+data.getSize());
     POINTS=data.getPoints();
     offset = new PVector(0,0);
   }

   public void draw() {
     background(0);
     noFill();
     strokeWeight(2);
     stroke(55, 200, 255);

     for (int i=0; i<POINTS.size(); i++) {
       PVector savedCoords = new PVector(POINTS.get(i).x, POINTS.get(i).y); //addoffset
       // add coordinates
       if (SAVE_DRAWING_COORDS) {
         addCoords(savedCoords);
       }
       // Display coords as points
       point(POINTS.get(i).x, POINTS.get(i).y);
     }

     if (SAVE_DRAWING_COORDS) {
       SAVE_DRAWING_COORDS =!SAVE_DRAWING_COORDS;
     }
   }
 }


 /*
  *  A JSON class for reading JSON data from files
  */

  class JsonData {

    ArrayList<PVector> pnts;
    JSONObject json;
    JSONArray arrayOfCoords;
    JSONObject values;
    //String id;
    int idIndex;
    String portraitName;
    boolean isSave;
    int arraySize;

    JsonData(int _idIndex) {
      json = new JSONObject();
      arrayOfCoords = new JSONArray();
      json.setJSONArray("coordinates", arrayOfCoords);

      this.idIndex = _idIndex;

      // portrait.setInt("id",idIndex);
      isSave = false;
    }

    public void setData(ArrayList<PVector> _pnts, boolean _b) {
      isSave = _b;
      pnts = _pnts;
      for (int i=0; i<pnts.size(); i++) {
        JSONObject data = new JSONObject();
        //PVector p =
        data.setInt("index", i);
        data.setFloat("x", pnts.get(i).x);
        data.setFloat("y", pnts.get(i).y);
        // add data to JSON array
        arrayOfCoords.setJSONObject(i, data);
      }
      // add portrait data to array
      //coordinates.setJSONObject(idIndex, portrait);
      if (isSave) {
        saveJSONObject(json, "data/jsonDataPortraits.json");
      }
    }

    public int getSize() {
      JSONArray dataJSON = values.getJSONArray("coordinates");
      arraySize = dataJSON.size();
      return arraySize;
    }

    public void loadData(int _id) {
      idIndex = _id;
      values = loadJSONObject(FILE_DIR+JSONFileName);
      //values = loadJSONObject("jsonDataPortraits.json");
      //println(values);
      println("JSON data loaded ;\u2013)");
    }

    public ArrayList<PVector> getPoints() {
      ArrayList<PVector> points = new ArrayList<PVector>();
      JSONArray dataJSON = values.getJSONArray("coordinates");
      for (int i=0; i<dataJSON.size (); i++) {
           JSONObject content =  dataJSON.getJSONObject(i);

            float x = content.getFloat("x");
            float y = content.getFloat("y");
            PVector p = new PVector(x, y);
            points.add(p);
      }
      return points;
    }
  }
/*
 * Factory Method Pattern
 * SOFT used for F\u00eate du Code Pompidou March 2017
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

  public void draw() {
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
/*
 * * Abstract Drawing Strategy Class
 * - Determines what to draw with SAM
 * - THIS IS THE MAIN CLASS FOR EXTENDING DRAWING FUNCTIONALITIES
 * SOFT used for F\u00eate du Code Pompidou March 2017
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
    //STRATEGY_COORDS.removeDups(); // remove any duplicate data ;\u2014)
  }
}

////////////////////////////////////////////////// END MAIN ABSTRACT CLASS
/*
 * A set of utility functions for screen interface :
 * system info + stop watch
 * SOFT used for F\u00eate du Code Pompidou March 2017
 */

PFont infoFont;
String currentTime, currentStrategy;


/*
 * Displays system info
 *
 */

public void displayInfo() {
  currentTime = getTime();
  currentStrategy =  APP.CURRENT_DS.getStrategy();
  pushStyle();
  textFont(infoFont, 12);
  textSize(12);
  textAlign(LEFT);
  rectMode(CORNER);
  fill(0);
  noStroke();
  rect(816,0, 400, height);
  ////////////////////////////////////////////////
  float mx = 820;
  float my = 190;

  String messages = "";
  messages += MSG.returnHashEntries();
  messages += "Last data msg: " + MSG.getMessage("Data MSG") + "\n";

  pushMatrix();
  translate(mx, my);
  fill(0);
  fill(73,243,73);
  text(messages, 0, 0);

  popMatrix();
  popStyle();
  ////////////////////////////////////////////////
  pushStyle();
  float tx = 820;
  float ty = 30;

  String out = "";
  out += "............... SYSTEM ...............\n";
  out += "fps: " + nf(frameRate, 0, 1) + "\n";
  out += "current strategy: " + currentStrategy + "\n";
  out += "Time: "+ currentTime+ "\n";


  pushMatrix();
  translate(tx, ty);
  fill(0);
  noStroke();
  //stroke(255,0,0);
  fill(73,243,73);
  text(out, 0, 0);
  text("Timer : ",0, 90);
  APP.theMachine.drawingStopWatch.display(80,90, 12);
  fill(150,50,200);
  text("SAM COORDS: " + APP.theMachine.COORDS_TO_SAM, 0, 130);
  popMatrix();
  popStyle();

  fill(0,100,200);
  text("............... PARAMETERS .....................", 820, 400);

  //////////////////////////////////////////////////
}


/*
 * Rolex class
 * A stop watch for timing events
 */

public class Rolex {

  long startTime = 0;
  long stopTime = 0;
  boolean isRunning = false;
  int ms, sec, min, h;


  public void start() {
    this.startTime = System.currentTimeMillis();
    this.isRunning = true;
    this.ms = 0;
    this.sec = 0;
    this.min = 0;
    this.h = 0;
  }


  public void stop() {
    println("Stop watch has been stopped");
    this.stopTime = System.currentTimeMillis();
    this.isRunning = false;
  }

  public void reset() {
    println("Stop watch has been reset");
    sec=0;
    min=0;
    h=0;
  }

  public void display(float _x, float _y, int _s) {
    run();
    pushStyle();
    textSize(_s);
    String s = String.format("%02d:%02d:%02d\n", h, min, sec);
    pushMatrix();
    translate(_x, _y);
    fill(240,34,30);
    text(s, 0, 0);
    popMatrix();
    popStyle();
  }

   public void run(){
    if (isRunning) {
      sec=(int)getElapsedTimeSecs()%60;
      min=(int)getElapsedTimeSecs()/60%60;
      h=(int)getElapsedTimeSecs()/(60*60)%60;
    }
  }


  //elaspsed time in milliseconds
  public long getElapsedTime() {
    long elapsed;
    if (isRunning) {
      elapsed = (System.currentTimeMillis() - startTime);
    } else {
      elapsed = (stopTime - startTime);
    }
    return elapsed;
  }


  //elaspsed time in seconds
  public long getElapsedTimeSecs() {
    long elapsed;
    if (isRunning) {
      elapsed = ((System.currentTimeMillis() - startTime) / 1000);
    } else {
      elapsed = ((stopTime - startTime) / 1000);
    }
    return elapsed;
  }
}

// Handy function for getting current time
public String getTime() {
  Date dNow = new Date( );
  SimpleDateFormat time = new SimpleDateFormat ("hh"+":"+"mm"+":"+"ss");
  //println(time.format(dNow));
  String t = time.format(dNow);
  return t;
}
/*
 * The Machine class manages coordinate data received from the Drawing Strategy class.
 * This data is then sent to the Serial via SamSerialData class
 * SOFT used for F\u00eate du Code Pompidou March 2017
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
  int PNT_COL;
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

  public void initMachine() {
    Z_CAL = 0;
    Z_DIST = 0;
    Z_DIFF = 30;
    LOC = new PVector(0, 0);
    VEL = new PVector(0, 0);
    CURRENT_POS = new PVector();

    ARRIVED = false;
    FINISHED_DRAWING = false;
    TARGET_DIST = 0.0f;
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
  public void moveToFirstCoord() {
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
  public void draw() {
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
    if (dist(LOC.x, LOC.y, CURRENT_POS.x, CURRENT_POS.y) <= 3.5f)
    {
      LOC.set(CURRENT_POS);
      penDown();
      ARRIVED = true;
    }
  }

  public void movePenUpOrDown(PVector pos, PVector target) {
    if (TARGET_DIST>=THRESH_MAX) {
      penUp();
    } else {
      penDown();
    }
  }

  public void computeVELDirection(PVector _pos, PVector _target)
  {
    VELDIR = PVector.sub(_target, _pos);
    VELDIR.normalize();
  }


  /*
   * Calculate distance from previous position to target position
   */
  public float calculateDistance(PVector _last, PVector _target) {
    float d = _last.dist( _target );
    return d;
  }

  public void penUp() {
    PEN_UP = true;
    PEN_DOWN = false;
  }

  public void penDown() {
    PEN_DOWN = true;
    PEN_UP  = false;
    displayDrawing();
  }

  /*
   * Chooses the next position to draw to based on index linear read
   */
  public PVector chooseNextPosition() {
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
  public boolean checkArrayLength(int _len, int _index) {
    boolean b = false;
    if (_index == _len-1) {
      b = true;
    }
    return b;
  }

  /*
   * Keeping all the motion update stuff here
   */
  public void update() {
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

  public void quitMachine() {
    String msg = "Finished drawing, what next ?";
    MSG.addMessage("Control MSG", msg); // see HASH class
    FINISHED_DRAWING = true;
    DRAWING = false; // this is bad having globals here ?
    drawingStopWatch.stop();
  }

  /*
   * Display drawing
   */
  public void displayDrawing() {
    noStroke();
    fill(PNT_COL);
    ellipse(LOC.x, LOC.y, PNT_SIZE, PNT_SIZE);
  }

  /*
   * Method for getting coordinate data
   */
  public void setCoordinates(PT_ArrayList _receivedCoords) {
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
/*
 * Class taking care of SAM's Serial data
 * SOFT used for F\u00eate du Code Pompidou March 2017
 */
/////////////////////////////////////////



ValueSender sender;
public int SAM_X, SAM_Y, SAM_Z, PIXEL_SCALE;

class SamSerialData {
  PApplet p5;

  SamSerialData(PApplet p5) {
    this.p5 = p5;
    PIXEL_SCALE = 5; // !!!!!!! should be a global somewhere for this too - put with speed variable
    SAM_X = 0;
    SAM_Y = 0;
    SAM_Z = 0;
  }

  public void updateSerialData(PVector _pos) {
    //println("This the what SAM recieves as pos data = "+_pos);
    PVector pMult = new PVector(_pos.x * PIXEL_SCALE, _pos.y * PIXEL_SCALE, 0.0f);
    SAM_X = (int)pMult.x;
    SAM_Y = (int)pMult.y;
    SAM_Z = (int)_pos.z;

  }

  public void initSerial() {
    String portName = Serial.list()[4]; // was 4 ?
    //printArray(Serial.list()); // debugging
    Serial serial = new Serial(p5, portName, 57600); // initially at 19200
    //receiver = new ValueReceiver(this, serial).observe("someVarA").observe("someVarB");
    sender = new ValueSender(p5, serial)
      .observe("SAM_X")
        .observe("SAM_Y")
          .observe("SAM_Z")
            .observe("PIXEL_SCALE");
  }
}
///////////////////////////////////////// SERIAL END
// --------------------------------------------
//* SOFT used for F\u00eate du Code Pompidou March 2017
class Timer
{
  float now = 0;
  float before = 0;
  float dt = 0;

  Timer()
  {
    now = before = millis()/1000.0f;
  }

  public float dt()
  {
    now = millis()/1000.0f;
    dt = now - before;
    before = now;
    return dt;
  }
}
/*
 * A generic class for creating & managing ArrayLists
 * Generics or paramterized types can be used with any data type.
 * SOFT used for F\u00eate du Code Pompidou March 2017
 */

//////////////////////////////////////////////////


class PT_ArrayList<Item> {

  private Item DATA_TYPE;
  ArrayList<Item> COLLECTION;


  public PT_ArrayList() {
    COLLECTION = new ArrayList<Item>();
  }


  public void addItem(Item _item) {
    COLLECTION.add(_item);
    this.DATA_TYPE=_item;
  }

  public Item getItem(int _index) {
    Item i = COLLECTION.get(_index);
    return i;
  }

  public void printOut() {
    for (Item i : COLLECTION) {
      println("Array contents : "+ i);
    }
  }

  public void clearData() {
    COLLECTION.clear();
  }

  /*
   * Method for getting size
   */
  public int getSize() {
    int s = COLLECTION.size();
    return s;
  }

  /*
   * Implements Iterator for grabbing content
   */
  public void getAll() {
    Iterator itr = COLLECTION.iterator();
    while (itr.hasNext ()) {
      Object element = itr.next();
      print(element + " ");
    }
  }


  /*
   * Modifiy contents of Collection
   */

  public void modify() {
    ListIterator litr = COLLECTION.listIterator();
    while (litr.hasNext ()) {
      Object element = litr.next();
      litr.set(element + "added this");
    }
  }

  /*
   * Method for returning data type
   */
  public String getDataType() {
    String s = DATA_TYPE.getClass().getName();
    return s;
  }

  /*
   * Method for removing duplicates of Integer/Float type
   * Handy when we need to strip down data for sending to SAM
   */

  public int removeDups() {

    int size = COLLECTION.size();
    int duplicates = 0;

    for (int i = 0; i < size - 1; i++) {
      // start from the next item
      // since the ones before are checked
      for (int j = i + 1; j < size; j++) {

        if (COLLECTION.get(j)!=(COLLECTION.get(i)))
          //if (!COLLECTION.get(j).equals(COLLECTION.get(i))) // >>> String check implementation
          continue;
        duplicates++;
        COLLECTION.remove(j);
        // decrease j because the array got re-indexed
        j--;
        // decrease the size of the array
        size--;
      } // for j
    } // for i

    return duplicates;
  }
}

///////////////////////////////////////// COLLECTION END

/*
 * Nice general purpose class for collecting & retrieving Strings by ID
 * - Good for messages.
 * NOTE : Each message must by given a separate ID !
 */



public class Hash {

  HashMap<String, String> HASH_COLLECTION;


  public Hash() {
    HASH_COLLECTION = new HashMap<String, String>();
  }

  /*
   * Method for adding messages with an ID/Key
   */
  public void addMessage(String _id, String _msg) {
    HASH_COLLECTION.put(_id, _msg);
  }

  /*
   * Method for getting a message from Collection by id/key
   * @param  id  : index of String to return in Collection
   */
  public String getMessage(String _id) {
    String s = HASH_COLLECTION.get(_id);
    return s;
  }

  /*
   * Method for displaying last Hash entry in console
   */
  public void printOutHashEntries() {
    println("\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7 HASH \u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7");
    for (Map.Entry em : HASH_COLLECTION.entrySet () ) {
      println("ID: "+em.getKey()+" | Message: "+em.getValue());
    }
    println("\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7 HASH END");
  }

   /*
   * Method for returning last Hash entry as a String
   */
  public String returnHashEntries() {
    String out = "";
    out+="\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7 HASH \u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\n";
    for (Map.Entry em : HASH_COLLECTION.entrySet () ) {
      //println("ID: "+em.getKey()+" | Message: "+em.getValue());
      out+= "ID: "+em.getKey()+"\n";
      out+= "Message: "+em.getValue() + "\n";
    }
     out+="\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7\u00b7 END\n";
     return out;
  }
}
/*
 * Graphical User Interface by Andreas Schlegel
 * ControlP5 : www.sojamo.de/controlP5
 * Using version 2.2.5
 * SOFT used for F\u00eate du Code Pompidou March 2017
 */

ControlP5 INTERFACES;
//////////////////////// INTERFACE VARIABLES


//////////////////////////////////////////
public void guiInit() {
  PFont p = createFont("FiraMono-Regular", 12);
  textFont(p, 12);
  ControlFont f = new ControlFont(p, 12);
  INTERFACES  = new ControlP5(this, f);

  // Custom dropdownlist
  ScrollableList s1;
  s1 = INTERFACES.addScrollableList("DrawingStrategy")
    .setPosition(1020, 422)
      .setSize(200, 130)
        .setLabel("Drawing Strategy")
          .setWidth(140)
           .setBarHeight(20)
           .setItemHeight(20);

   for (int i=0; i<APP.theStrategies.size (); i++) {
      String strategyID = APP.theStrategies.get(i).getStrategy();
      s1.addItem(strategyID, i);
  }

  //////////////////////////////////// Add GROUP 1
  Group g1 = INTERFACES.addGroup("g1")
    .setPosition(820, 440)
      .setWidth(180)
        .activateEvent(true)
          //.hide() // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! HIDING GROUP !! ATTENTION !!
          .setBackgroundColor(color(0, 53 ))  //#CED2DB, #C9BFBF
            .setBackgroundHeight(230)
              .setLabel("Drawing Parameters")
                .setBarHeight(17);

  ///////////////////////////////////////////////////////////////////// GROUP 1 NAME ?
  // LINES
  Slider ls1 = INTERFACES.addSlider("THRESH_MAX").setPosition(10, 20)
    .setRange(1, 160).setValue(60.0f).setGroup(g1)
      .setSize(100, 15)
        .setColorBackground(0xffF5F5F5).setColorForeground(0xffA09E9F)
          .setColorValueLabel(0xff525252).setColorActive(0xffF08D0C);

  Slider ls2 = INTERFACES.addSlider("MAX_SPEED").setPosition(10, 40)
    .setRange(0.4f, 6.0f).setValue(0.50f).setGroup(g1)
      .setSize(100, 15)
        .setColorBackground(0xffF5F5F5).setColorForeground(0xffA09E9F)
          .setColorValueLabel(0xff525252).setColorActive(0xffF08D0C);

  Slider ls3 = INTERFACES.addSlider("SEGMENT").setPosition(10, 60)
    .setRange(1, 50).setValue(10).setGroup(g1)
      .setSize(100, 15)
        .setColorBackground(0xffF5F5F5).setColorForeground(0xffA09E9F)
          .setColorValueLabel(0xff525252).setColorActive(0xffF08D0C);

  Slider ls4 = INTERFACES.addSlider("INTERVALLE").setPosition(10, 80)
    .setRange(1, 50).setValue(2).setGroup(g1)
      .setSize(100, 15)
        .setColorBackground(0xffF5F5F5).setColorForeground(0xffA09E9F)
          .setColorValueLabel(0xff525252).setColorActive(0xffF08D0C);


  Bang b1 = INTERFACES.addBang("SAVE").setPosition(10, 110)
    .setSize(15, 15).setGroup(g1).setCaptionLabel("save")
      .setColorBackground(0xffF5F5F5).setColorForeground(0xffA09E9F)
        .setColorValueLabel(0xff525252).setColorActive(0xffF08D0C);

  Bang b2 = INTERFACES.addBang("START").setPosition(60, 110)
    .setSize(15, 15).setGroup(g1).setCaptionLabel("setup")
      .setColorBackground(0xffF5F5F5).setColorForeground(0xffA09E9F)
        .setColorValueLabel(0xff525252).setColorActive(0xffF08D0C);


  Bang b3 = INTERFACES.addBang("DRAW").setPosition(110, 110)
    .setSize(15, 15).setGroup(g1).setCaptionLabel("draw")
      .setColorBackground(0xffF5F5F5).setColorForeground(0xffA09E9F)
        .setColorValueLabel(0xff525252).setColorActive(0xffF08D0C);

  Bang b4 = INTERFACES.addBang("RESET").setPosition(60, 150)
    .setSize(15, 15).setGroup(g1).setCaptionLabel("reset")
      .setColorBackground(0xffF5F5F5).setColorForeground(0xffA09E9F)
        .setColorValueLabel(0xff525252).setColorActive(0xffF08D0C);

  Bang b5 = INTERFACES.addBang("QUIT").setPosition(10, 150)
    .setSize(15, 15).setGroup(g1).setCaptionLabel("quit")
      .setColorBackground(0xffF5F5F5).setColorForeground(0xffA09E9F)
        .setColorValueLabel(0xff525252).setColorActive(0xffF08D0C);


  Bang gb1 = INTERFACES.addBang("bangLoad").setPosition(10, 210)
    .setSize(10, 10).setTriggerEvent(Bang.RELEASE).setGroup(g1).setCaptionLabel("load IMG")
      .setColorBackground(0xff0D6FBC).setColorForeground(0xff0D6FBC);
}

////////////////////////////////////////// END INTERFACE SETTINGS
/*
void controlEvent(ControlEvent theEvent) {
  // Update strategy list
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    //println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
    String s = theEvent.getGroup().getName();
    //println(s);
    if (s.equals("DrawingStrategy")) {
      STRATEGY_INDEX = (int)theEvent.getGroup().getValue();
      background(0);
      //APP.initApp();
      APP.CURRENT_DS = APP.theStrategies.get( STRATEGY_INDEX );
    }
  } else if (theEvent.isController()) {
    //println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
    //println(SAVE);
  }
}
*/

// UPDATING BANG VALUES : >>>
public void SAVE() {
  SAVE_DRAWING_COORDS = true;
  //APP.theMachine.setMachineOrigins();
  //println("### bang(). a bang event. setting drawing coords to "+SAVE_DRAWING_COORDS);
}

public void START() {
  //if(APP.theMachine.COORDS_DATA_LENGTH>0){
  SHOW_STRATEGY = false;
  APP.theMachine.setCoordinates(APP.CURRENT_DS.STRATEGY_COORDS);
  println("Number of coordinate points = " +APP.theMachine.COORDS_DATA_LENGTH);
  int n = APP.theMachine.COORDS_DATA_LENGTH;
  String message = "N\u00b0 pnts = "+n;
  MSG.addMessage("Data MSG", message);
  FIRST_COORD=true;
  //}
  //println("### bang(). a bang event. setting drawing coords to "+FIRST_COORD);
}

public void DRAW() {
  // if (FIRST_COORD) {
  FIRST_COORD = false;
  DRAWING=true;
  SHOW_STRATEGY=false;
  APP.theMachine.drawingStopWatch.start();
  //println("### bang(). a bang event. starting to draw "+FIRST_COORD);
  // }
}

public void RESET() {
  APP.theMachine.drawingStopWatch.reset();
  String message = "Coordinate data deleted";
  MSG.addMessage("Data MSG", message);
  APP.initApp();
}

public void QUIT() {
    APP.theMachine.quitMachine();
    //DRAWING = false;
}

//////////////////////////////////////// Dropdown List customize
public void DrawingStrategy(int n){
  //background(0);
  APP.initApp();
  INTERFACES.get(ScrollableList.class, "DrawingStrategy").getItem(n);
  APP.CURRENT_DS = APP.theStrategies.get( n );
  STRATEGY_INDEX = n;
}

/////////////////////////////////////////// IMAGE SELECTION FROM PUTER

// Bang button updates
public void bangLoad() {
  selectInput("Choose an SVG image for SAM", "fileSelected");
}

// File Selection method for choosing saved presets
public void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    APP.CURRENT_DS.IMGName = selection.getAbsolutePath();
    if (APP.CURRENT_DS.IMGName != null) {
      APP.CURRENT_DS.SHP = RG.loadShape(APP.CURRENT_DS.IMGName);
      File f = new File(APP.CURRENT_DS.IMGName); // gets file name from absolute Path
      String s = f.getName();
      String message = "New file: "+s;
      MSG.addMessage("Data MSG", message);
    } else {
      APP.CURRENT_DS.SHP = RG.loadShape("anne_algo.svg");
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#030303", "--hide-stop", "A_SAM_V_095" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
