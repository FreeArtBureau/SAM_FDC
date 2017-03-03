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

JsonData DATA;
boolean isJsonExport = false;
//String filePath ; //= sketchPath()+"/JSON/";

//IMAC VIGO
//String filePath= "/Users/esad/Google Drive/SAM_BEAUBOURG_JSON/";

//MACPRO VIGO
String filePath= "/Users/vjm/Google Drive/SAM GOES TO BEAUBOURG/SAM_BEAUBOURG_JSON";

String fileName ;

//String filePath = "";

int numberPoints;
int factor = 14; // image size
int levels = 2;

physicalButton theButton = new physicalButton(this, 2);
BlobDetection[] theBlobDetection = new BlobDetection[int(levels)];
DotDiagram[] theDiagrams;

PFont mono, monoSmall ;
// The font "andalemo.ttf" must be located in the 
// current sketch's "data" directory to load successfully

Capture cam;
PImage img;
//String direct = "/Users/markwebster/Desktop/toPrint";
String TIME;
//boolean newFrame=false;
int BLOB_FACTOR_X, BLOB_FACTOR_Y;
//////////////////////////////////////////////

void settings() {

  // for infos resolution IMAC 2009 = 1680 x 1050
  // so screen ratio = 1.6
  fullScreen(P3D);
  //size(1680, 1050, P3D);
}

//////////////////////////////////////////////
void setup() {
  mono = createFont("mono.ttf", 140);
  monoSmall = createFont("mono.ttf", 8);

  textFont(mono);

  colorMode(HSB, 360, 100, 100);

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
  background(0, 0, 0);
  if (cam.available() == true) {
    cam.read();
    img.copy(cam, (cam.width-cam.height)/2, 0, cam.height, cam.height, 0, 0, img.width, img.height);
  }

  if (bDrawImage) {
    cam.updatePixels();
    image(cam, 0, 0, width, height);
  }

  //filterVisage(blurlvl, thresh);

  computeBlobs();
  computeDiagrams();
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
          //          calculateJSON(levels, isJsonExport);
          isJsonExport = false;
        }
        calculateTotalDiaPoints(levels);
      }
    }
    catch(Exception e) {
      //println("...trying to change preset...");
    }
  }





  if (theButton.hasFinished() == false) {
    displayWait();
  }

  displayBorders();

  if (isGUI) {
    cp5.show();
  } else {
    cp5.hide();
  }
  cp5.draw();
}
/////////////////////////////////////////////////////


void takePicture() {
  fileName = getTime();
  println("taking a picture");
  //saveFrame(filePath + "/"+fileName+".png");

  //calculateJSON(levels, true);
  joinTheDotA4();
  Print(sketchPath()+"/PDF/" + fileName + ".pdf");
}


void displayWait() {
  background(0, 100, 0);
  fill(0, 0, 100);
  //String merci = "╔╦╗╔═╗╦═╗╔═╗╦\n║║║║╣ ╠╦╝║  ║\n╩ ╩╚═╝╩╚═╚═╝╩";
  String merci = "Merci \nvotre dessin s'imprime !";
  textFont(mono);
  textAlign(CENTER);
  textSize(50);

  //text(merci, 0, 100,width,height);

  float cd = 0.0;
  cd  =  millis() - theButton.lastClick ;
  String w = ""+ nf(theButton.WAIT_TIME/1000 - cd/1000, 2, 1);
  text(merci, 0, 500, width, height);
}




void displayBorders() {
  float dotSize = 5;
  noStroke();
  float xOffset = 0;
  float yOffset = 0;

  for (int x=40; x<width-40; x+=15) {
    float h = map(x, 0, width-40, 1, 360);
    fill(h, 100, 100);
    if (x%2==0) {
      yOffset=5;
    } else {
      yOffset=-5;
    }
    ellipse(x, 40+yOffset, dotSize, dotSize);
  }
  pushMatrix();
  translate(0, height-70);
  for (int x=40; x<width-40; x+=15) {
    float h = map(x, 0, width-40, 1, 360);
    fill(h, 100, 100);
    if (x%2==0) {
      yOffset=5;
    } else {
      yOffset=-5;
    }
    ellipse(x, 40+yOffset, dotSize, dotSize);
  }
  popMatrix();

  for (int y=40; y<height-40; y+=15) {
    float h = map(y, 0, height-40, 1, 360);
    fill(h, 100, 100);
    if (y%2==0) {
      yOffset=5;
    } else {
      yOffset=-5;
    }
    ellipse(40, y+yOffset, dotSize, dotSize);
  }

  pushMatrix();
  translate(width-80, 0);
  for (int y=40; y<height-40; y+=15) {
    float h = map(y, 0, height-40, 1, 360);
    fill(h, 100, 100);
    if (y%2==0) {
      yOffset=5;
    } else {
      yOffset=-5;
    }
    ellipse(40, y+yOffset, dotSize, dotSize);
  }
  popMatrix();



  pushMatrix();
  translate(width-320, 0);
  for (int y=40; y<height-40; y+=15) {
    float h = map(y, 0, height-40, 1, 360);
    fill(h, 100, 100);
    if (y%2==0) {
      yOffset=5;
    } else {
      yOffset=-5;
    }
    ellipse(40, y+yOffset, dotSize, dotSize);
  }
  popMatrix();

  pushMatrix();
  translate(240, 0);
  for (int y=40; y<height-40; y+=15) {
    float h = map(y, 0, height-40, 1, 360);
    fill(h, 100, 100);
    if (y%2==0) {
      yOffset=5;
    } else {
      yOffset=-5;
    }
    ellipse(40, y+yOffset, dotSize, dotSize);
  }
  popMatrix();
}

void displaySAMName(float _displayX, float _displayY) {
  float txtPosX = 0;
  float txtPosY = 10;
  float interLine = 26;
  pushMatrix();
  translate(_displayX, _displayY);
  textSize(8);
  fill(0, 0, 100);
  text("...............................", txtPosX, txtPosY-22);
  textSize(12);
  fill(0, 0, 100);
  String s = "╔═╗╔═╗╔╦╗\n╚═╗╠═╣║║║\n╚═╝╩ ╩╩ ╩";
  text(s, 0, 5);
  textSize(8);
  text("...............................", txtPosX, txtPosY+34);
  textSize(12);
  text("La machine ", 70, 20);
  text("qui dessine", 70, 31);
  popMatrix();
}