/*
 * Animate a JSON file
 * DEV : 25.02.2016
 */

import java.util.*;
//import java.io.IOException;


JsonData theData;
String filePath = "/Users/tisane/Google Drive/Pomp_Files/json/TEST_01/";
File folder = new File(filePath);
File[] listOfFiles;
int folderSize;
String currentFileInUse;
String lastModifiedFile;

float SAM_DRAWING_SPEED = 7.0;
ArrayList<Agent> theAgents;

Timer timerLoadData;
float periodLoadData = 10.0; // seconds
boolean isNewData = false;
boolean redrawBG = false;
 //////////////////////////////////////////////
 void setup(){
   size(800, 640);
   background(0,0,33);
   noStroke();
   rectMode(CENTER);
   listOfFiles = folder.listFiles();
   Arrays.sort(listOfFiles);
   //printCurrentFolderFiles();
   folderSize = listOfFiles.length;

   File lastFile = getLatestFilefromDir(filePath);
   currentFileInUse = lastFile.getName();
   //currentFileInUse = "jsonDataPortraits_02_05_46.json";

   timerLoadData = new Timer(false);
   timerLoadData.scheduleAtFixedRate(new DataLoadTask(), 0, (long) periodLoadData*1000);
   theAgents = new ArrayList<Agent>();
   // draw from last saved file in directory
   initDraw();

 }

 //////////////////////////////////////////////
 void draw(){
   if(redrawBG) {
     background(0,0,33);
      redrawBG = false;
   }
   pushMatrix();
   //translate(10,10);
   scale(0.8);
   /*
   for(Agent a : theAgents){
     a.drawAgent();
     a.update();
   }
   */

   Agent ag = theAgents.get(theAgents.size()-1);
   ag.drawAgent();
   ag.update();

  popMatrix();

 }

 ///////////////////////////// FUNCTIONS// TimerTask class lets us schedule & time java tasks.
 class DataLoadTask extends TimerTask{
   public void run() {
    println("run called");
    isNewData = checkNewData();
    println(isNewData);
    if(isNewData) {
      saveFrame("Capture_###.png");
      redrawBG = true;
      println("Hey, we got some new data !");
      getData();
      isNewData=false;
    }else {
      //println("We are still waiting for new data Roger !");
    }
   }
 }

 void initDraw(){
   theData = new JsonData();
   theData.loadData(currentFileInUse);
     Agent a = new Agent(3, 3);
     a.setCoordPnts( theData.getPoints() );
     theAgents.add(a);
 }


 void getData(){
    listOfFiles = folder.listFiles();
    Arrays.sort(listOfFiles);
    File lastFile = getLatestFilefromDir(filePath);
    currentFileInUse = lastFile.getName();

    theData = new JsonData();
    theData.loadData(currentFileInUse);
    println("File: "+currentFileInUse);

    //for(Agent a : theAgents){

      Agent a = new Agent(3, 3);
      a.setCoordPnts( theData.getPoints() );
      theAgents.add(a);
 }


 boolean checkNewData(){
   boolean test = false;
   File[] listOfFiles = folder.listFiles();
   int numElements = listOfFiles.length;
   println("Latest number of elements in folder = "+numElements);
   println("Last number of elements in folder = "+folderSize);
   if(folderSize<numElements){
     test = true;
     folderSize = numElements; // UPDATE folderSize ?
   }else {
      test = false;
   }
   return test;
 }


 // Checks file names
 boolean isSame(String _s){
   if(_s.equals(currentFileInUse)){
   return true;
   }
   else return false;

 }

 /*
  * Gets last modified file in directory
  */

  File getLatestFilefromDir(String dirPath){
   File dir = new File(dirPath);
   File[] files = dir.listFiles();
   if (files == null || files.length == 0) {
       return null;
   }
  File lastModifiedFile = files[0];
  boolean testFile = lastModifiedFile.isHidden();
  println( "Hidden = "+testFile );
   for (int i = 1; i < files.length; i++) {
      if ((lastModifiedFile.lastModified() < files[i].lastModified() &&  (testFile == false))) {
          lastModifiedFile = files[i];
      }
   }
   return lastModifiedFile;
}

  void printCurrentFolderFiles(){
    for (int i = 0; i < listOfFiles.length; i++) {
      System.out.println(listOfFiles[i].getName());
      //System.out.println(listOfFiles[i].getName()+"\t"+new Date(listOfFiles[i].lastModified()));
    }
  }


 ////////////////////////////////////////////// END
