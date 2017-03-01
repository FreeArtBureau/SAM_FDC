/*
 * SAM JOIN THE DOTS V0.65 Camera
 * https://github.com/FreeArtBureau/SAM/tree/master/PROJET_BOBO
 *
 */

////////////////////////////////////////
import processing.video.*;
import blobDetection.*;
import processing.pdf.*;
import java.text.*;
import java.util.*;

////////////////////////////////////////
PShader shaderBlur, canny, refine;

JsonData DATA;
boolean isJsonExport = false;
String filePath = "/Users/tisane/Google Drive/Pomp_Files/json/";
//String filePath = "/Users/tisane/Desktop/JSON/";
int numberPoints;
int factor = 14; // image size
int levels = 2;

BlobDetection[] theBlobDetection = new BlobDetection[int(levels)];
DotDiagram[] theDiagrams;
Capture cam;
PImage img;
//String direct = "/Users/markwebster/Desktop/toPrint";
String TIME;
TSP myTSP;
//boolean newFrame=false;

//////////////////////////////////////////////

void settings() {
  img = new PImage(80, 60);
  //visage = loadImage("picasso_thumb.jpg");
  size(80*factor, 60*factor, P3D);
}

//////////////////////////////////////////////
void setup() {
//  img = new PImage(80, 60);
//  size(800, 600, P3D);
  background(255);
  myTSP = new TSP();
  filterSkelt = new SkeletonFilter();
  //visage = loadImage("picasso_thumb.jpg");


  colorMode(HSB, 360, 100, 100);
  shaderBlur = loadShader("blur.glsl");
  canny = loadShader("canny.glsl");
  refine = loadShader("refine.glsl");

  refine.set("texelWidth", 1.0);
  refine.set("texelHeight", 1.0);
  refine.set("upperThreshold", 1.0);
  refine.set("lowerThreshold", 0.01);

//  shaderBlur.set("blurSize", 2);
//  shaderBlur.set("sigma", 2.5);

  DATA = new JsonData(0);
  //jsonFileIndex = 0;
  cam = new Capture(this, 40*4, 30*4, 15);
  cam.start();
  //img = new PImage(80, 60);
  initGUI();
  compute();
}

//////////////////////////////////////////////
void draw() {
  //background(0);
  background(0,0,100);
  if (cam.available() == true) {
    //background(0);
    cam.read();
 }

 if (bDrawImage) {
   image(cam, 0, 0, width, height);
 }

  compute();
  img.copy(cam, 0, 0, cam.width, cam.height,
    0, 0, img.width, img.height);


  if (bDrawContours) {
    for (int i=0; i<levels; i++) {
      //theBlobDetection[i].computeBlobs(img.pixels);
      drawContours(i);
    }
  }

  //-------------------- > we only want to export the diagram for the printer ;–)
  if (bExportPDF)
  {
    beginRecord(PDF, "/Users/tisane/Google Drive/Pomp_Files/toPrint/SAM_diagram_"+getTime()+".pdf");
    //("/Users/markwebster/Desktop/toPrint/..."); > the address
    //colorMode(HSB, 360, 100, 100);
  }

  if (bDrawDiagram) {
    try {
    // get string value from ScrollableList
    int itemIndex = (int)s1.getValue();
    String algorithm = algorithms[ itemIndex ];

    if(theDiagrams != null) {
    for (int i=0; i<theDiagrams.length; i++) {
      theDiagrams[i].compute(numDots, 20, algorithm); // 10 : SIMPLE [best]
      theDiagrams[i].displayDotDiagram(lineThresh, bDrawDiagramLines, bDrawDiagramDotNumbers, i);
   }
   if(isJsonExport){
    calculateJSON(levels, isJsonExport);
    isJsonExport = false;
  }
    calculateTotalDiaPoints(levels);
  }
}
  catch(Exception e) {
    //println("...trying to change preset...");
  }
}

  if (bExportPDF){
    endRecord();
    bExportPDF = false;
  }

  if (isGUI) {
    cp5.show();
  } else {
    cp5.hide();
  }
  cp5.draw();
}
/////////////////////////////////////////////////////
