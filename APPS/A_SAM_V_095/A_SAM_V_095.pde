
/* *********
 * ╔═╗╔═╗╔╦╗
 * ╚═╗╠═╣║║║
 * ╚═╝╩ ╩╩ ╩
 * *********
 *
 * SAM_SOFT_dev_095 using P5 V2.2.1 [dev 25.02.17]
 *
 *   NOTES TO SELF :
 *   SOFT used for Fête du Code Pompidou March 2017
 *
 */
/////////////////////////// LIBRARIES /////////////////////////
import geomerative.*;
import controlP5.*;
import java.util.*;
import java.text.*;

/////////////////////////// GLOBALS ////////////////////////////
Application APP;
// Possibility of adding other drawing methods through the DrawingFactory interface
DrawingMethod DM = new DrawingMethod();
DrawingFactory DF = DM.createDrawingMethod("FREE");
Hash MSG;
int jsonFileIndex = 2;

/////////////////////////// SETUP ////////////////////////////

void setup() {
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
void draw() {
  APP.draw();
  APP.update();

  displayInfo();
}

/////////////////////////// FUNCTIONS ///////////////////////
void keyPressed() {
  APP.keyPressed();
}
