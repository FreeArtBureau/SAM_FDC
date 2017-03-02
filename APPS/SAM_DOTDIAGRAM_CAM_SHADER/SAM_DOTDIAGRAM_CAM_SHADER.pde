/*
 * SAM JOIN THE DOTS V0.65 Camera
 * https://github.com/FreeArtBureau/SAM/tree/master/PROJET_BOBO
 * updated : 01.03.16
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

physicalButton theButton = new physicalButton(this, 2);
BlobDetection[] theBlobDetection = new BlobDetection[int(levels)];
DotDiagram[] theDiagrams;
//Printer thePrinter = new Printer();

Capture cam;
PImage img;
//String direct = "/Users/markwebster/Desktop/toPrint";
String TIME;
TSP myTSP;
//boolean newFrame=false;
int BLOB_FACTOR_X, BLOB_FACTOR_Y;
//////////////////////////////////////////////

void settings() {

  // for infos resolution IMAC 2009 = 1680 x 1050
  // so screen ratio = 1.6
  //visage = loadImage("picasso_thumb.jpg");
  fullScreen(P3D);
  
  //size(96*factor, 60*factor, P3D);
}

//////////////////////////////////////////////
void setup() {

  colorMode(HSB, 360, 100, 100);

  myTSP = new TSP();
  DATA = new JsonData(0);

  cam = new Capture(this, 40*4, 30*4, 15);
  cam.start();
  initGUI();
  img=new PImage( 30*4, 30*4);
  BLOB_FACTOR_X = height;
  BLOB_FACTOR_Y = height;
}

//////////////////////////////////////////////
void draw() {
  background(0, 0, 100);
  if (cam.available() == true) {
    cam.read();
    img.copy(cam, (cam.width-cam.height)/2, 0, cam.height, cam.height, 0, 0, img.width, img.height);
  }

  if (bDrawImage) {
    image(cam, 0, 0, width, height);
  }

  compute();

  if (bDrawContours) {
    pushMatrix();
    translate(width/2 - BLOB_FACTOR_X/2, 0);

    for (int i=0; i<levels; i++) {
      //theBlobDetection[i].computeBlobs(img.pixels);
      drawContours(i, BLOB_FACTOR_X, BLOB_FACTOR_Y, 0, 0);
    }
    popMatrix();
  }
  //-------------------- > we only want to export the diagram for the printer ;–)
  if (bExportPDF)
  {
    beginRecord(PDF, getTime()+".pdf");
    //("/Users/markwebster/Desktop/toPrint/..."); > the address
    //colorMode(HSB, 360, 100, 100);
  }

  if (bDrawDiagram) {
    try {
      // get string value from ScrollableList
      int itemIndex = (int)s1.getValue();
      String algorithm = algorithms[ itemIndex ];

      if (theDiagrams != null) {
        pushMatrix();
        translate(width/2 - BLOB_FACTOR_X/2, 0);
        for (int i=0; i<theDiagrams.length; i++) {
          theDiagrams[i].compute(numDots, 20, algorithm); // 10 : SIMPLE [best]
          theDiagrams[i].displayDotDiagram(lineThresh, bDrawDiagramLines, bDrawDiagramDotNumbers, i);
        }
        popMatrix();
        if (isJsonExport) {
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

  if (bExportPDF) {
    endRecord();
    bExportPDF = false;
  }

  if (theButton.isClick()) {
    takePicture();
  }


  if (isGUI) {
    cp5.show();
  } else {
    cp5.hide();
  }
  cp5.draw();
}
/////////////////////////////////////////////////////


void takePicture() {
  println("taking a picture");
  String pdfFileName = joinTheDotA4();
  Print(sketchPath()+"/PDF/" + pdfFileName + ".pdf");
}

String joinTheDotA4() {
  String fileName =  getTime() ;
  int itemIndex = (int)s1.getValue();
  String algorithm = algorithms[ itemIndex ];
  pushMatrix();

  beginRecord(PDF, "PDF/" + fileName + ".pdf");
  translate(width/2, height/2);
  scale(0.6);
  translate(-width/2, -height/2);
  stroke(0);
  rect(0, 0, width, height);

  colorMode(HSB, 360, 100, 100, 100); //needs to be set for PDF  
  if (theDiagrams != null) {
            translate(width/2 - BLOB_FACTOR_X/2, 0);

    for (int i=0; i<theDiagrams.length; i++) {
      theDiagrams[i].compute(numDots, 20, algorithm); // 10 : SIMPLE [best]
      theDiagrams[i].displayDotDiagram(lineThresh, true, bDrawDiagramDotNumbers, i);
    }
  }
  endRecord();
  pushMatrix();

  return fileName;
}