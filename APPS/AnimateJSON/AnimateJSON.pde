/*
 * Animate a JSON file
 * DEV : 28.02.2016 : MW
 */

import java.util.*;
import java.io.File;
import java.io.FilenameFilter;


JsonData theData;
//String filePath = "/Users/tisane/Google Drive/SAM GOES TO BEAUBOURG/SAM_BEAUBOURG_JSON/";
String filePath = "/Users/tisane/Desktop/JSON/";

File folder = new File(filePath);
float periodLoadData = 30.0; // seconds
float SAM_DRAWING_SPEED = 2.8;
float DRAW_SCALE = 0.8;
ArrayList<Agent> theAgents;
ArrayList<Drawing> theDrawings;
float drawingYPos, drawingXPos;


PFont f;

//////////////////////////////////////////////
 void setup(){
   size(1280, 740);
   background(0,0,33);
   noStroke();
   rectMode(CENTER);
   colorMode(HSB,360,100,100);
   f =createFont("FiraCode-Regular", 18);
   textFont(f,18);
   initFolder();
   timerLoadData = new Timer(false);
   timerLoadData.scheduleAtFixedRate(new DataLoadTask(), 0, (long) periodLoadData*1000);
   initDraw();
 }

 //////////////////////////////////////////////
 void draw(){
   background(237,100,7);

  //------------------------ > display last drawing BIG
   pushMatrix();
   translate(40,100);
   Agent a = (Agent)theAgents.get(theAgents.size()-1);
   a.drawAgent(SAM_DRAWING_SPEED, 0, 0, DRAW_SCALE);

   Drawing theDotDrawing = theDrawings.get(theDrawings.size()-1);
   theDotDrawing.displayDrawing(0, 0, DRAW_SCALE, 173, 2);
   popMatrix();

  displayTitle(100,30);
  displayData(100, 640);

  int numDrawings = theDrawings.size();
      for(int i=0; i<numDrawings; i++){
        Drawing d = theDrawings.get(i);
      d.displayDrawing(860, 40+i*90, 0.1, 267, 6);
    }

  //checkDrawingBounds();
 }

 //------------------------ >FUNCTIONS
 void initDraw(){
   theAgents = new ArrayList<Agent>();
   theDrawings = new ArrayList<Drawing>();
   theData = new JsonData();
   theData.loadData(currentFileInUse);

     Agent a = new Agent(SAM_DRAWING_SPEED, 3);
     a.setCoordPnts( theData.getPoints() );
     theAgents.add(a);
     drawingYPos = 90;
     drawingXPos = 880;
     addNewDrawing(theData.getPoints());

 }
// this function is called each time getData is called with a new file
// in the folder directory
 void  addNewAgent(){
      Agent newDrawingAgent = new Agent(SAM_DRAWING_SPEED, 3);
      newDrawingAgent.setCoordPnts( theData.getPoints() );
      theAgents.add(newDrawingAgent);
      drawingYPos += 90;
  }

void addNewDrawing( ArrayList<PVector> _drawingPoints ){
    Drawing newDrawing = new Drawing();
    newDrawing.setDrawingPoints( _drawingPoints );
    theDrawings.add( newDrawing );
}


void checkDrawingBounds(){
  if(drawingXPos>width-90){
    drawingXPos = 880;
    drawingYPos = 90;
  }
  if(drawingYPos>height-90){
    drawingXPos += 90;
    drawingYPos = 90;
  }
}
 ////////////////////////////////////////////// END

 void keyPressed(){


 }
