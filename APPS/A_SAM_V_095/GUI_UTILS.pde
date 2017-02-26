/*
 * A set of utility functions for screen interface :
 * system info + stop watch
 * SOFT used for Fête du Code Pompidou March 2017
 */

PFont infoFont;
String currentTime, currentStrategy;


/*
 * Displays system info
 *
 */

void displayInfo() {
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
String getTime() {
  Date dNow = new Date( );
  SimpleDateFormat time = new SimpleDateFormat ("hh"+":"+"mm"+":"+"ss");
  //println(time.format(dNow));
  String t = time.format(dNow);
  return t;
}
