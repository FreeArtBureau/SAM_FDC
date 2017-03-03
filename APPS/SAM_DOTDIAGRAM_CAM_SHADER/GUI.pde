/*
 * Interface setup
 *
 */
import java.io.*;
import controlP5.*;
ControlP5 cp5;
ScrollableList s1;

//////////////////////////////////////// GLOBALS
int blurlvl;
int maxPixelH;
//int levels;
float levelMax;
int lineThresh;
float thresh;
float colorStart = 35;
float colorRange =  82;
float alphaContours;
int numDots;
float dotSize = 5.0;
float txtSize = 9.0;
boolean bDrawContours;
boolean bDrawContoursVertex;

int print_Lvl=1;
boolean bShapes = true;
PFont f;
boolean isGUI = false;
boolean bExportPDF = false;
boolean bDrawImage;
boolean bComputeDiagrams;
boolean bDrawDiagram;
boolean bDrawDiagramDotNumbers;
boolean bDrawDiagramLines;
boolean bComputeGlobalDiagram;
boolean is_Partial;
int partialFactor;
int partialFine;
String[]  algorithms = {"RADIAL", "SIMPLE", "PEUCKER"};

boolean CANNY = false; // shade
float CANNY_THRESH;

boolean bPrintNumbers = false;

int skipNumber;
float xGuiPos = 10;
float yGuiPos = 25;
float yOffSlider = 10;
float yOffButton = 20;

//////////////////////////////////////// SETUP

void initGUI() {
  f = createFont("Iosevka-Medium", 11);
  textFont(f, 11);
  cp5 = new ControlP5(this, f);
  cp5.setAutoDraw(false);

  ////////////////////////////////////////
  //--------------------- > Add GROUP 1
  Group g1  =  cp5.addGroup("g1")
    .setPosition(xGuiPos, yGuiPos)
    .setWidth(210)
    .activateEvent(true)
    .setBackgroundColor(color( #C9BFBF, 33 ))  //#CED2DB, #C9BFBF
    .setBackgroundHeight(100)
    .setLabel("BLOBS")
    .setBarHeight(18);

  //--------------------- > blobDetection params
  cp5.addSlider("blurlvl")
    .setRange(0, 4)
    .setPosition(2, 5)
    .setHeight(15)
    .setWidth(120)
    .setGroup(g1);

  cp5.addSlider("levels")
    .setRange(0, 20)
    .setPosition(2, yGuiPos)
    .setHeight(15)
    .setWidth(120)
    .setGroup(g1);

  cp5.addSlider("levelMax")
    .setRange(0.1, 1.0)
    .setPosition(2, yGuiPos+(yOffSlider*2))
    .setHeight(15)
    .setWidth(120)
    .setGroup(g1);

  cp5.addSlider("maxPixelH")
    .setRange(1, 150).setPosition(2, yGuiPos+(yOffSlider*4))
    .setHeight(15).setWidth(120)
    .setGroup(g1);

  cp5.addSlider("thresh")
    .setRange(0.0, 1.0)
    .setPosition(2, yGuiPos+(yOffSlider*6))
    .setHeight(15)
    .setWidth(120)
    .setGroup(g1);


  ////////////////////////////////////////
  //--------------------- > Add GROUP 2
  Group g2  =  cp5.addGroup("g2")
    .setPosition(xGuiPos+220, yGuiPos)
    .setWidth(260)
    .activateEvent(true)
    .setBackgroundColor(color( #CED2DB, 33 ))  //#CED2DB, #C9BFBF
    .setBackgroundHeight(150)
    .setLabel("IMAGE")
    .setBarHeight(18);

  //--------------------- > image params
  cp5.addToggle("bDrawImage")
    .setLabel("image")
    .setPosition(2, 5)
    .setGroup(g2);

  cp5.addToggle("bDrawContours")
    .setLabel("contours")
    .setPosition(52, 5)
    .setGroup(g2);

  //cp5.addToggle("is_Partial").setLabel("partial").setPosition(102, 5).setGroup(g2);
  cp5.addToggle("bDrawContoursVertex")
    .setLabel("vertices")
    .setPosition(154, 5)
    .setGroup(g2);

  cp5.addSlider("alphaContours")
    .setRange(0, 255)
    .setPosition(2, yGuiPos+(yOffButton))
    .setHeight(15)
    .setWidth(120)
    .setGroup(g2);

  cp5.addSlider("partialFactor")
    .setRange(0, 10)
    .setPosition(2, yGuiPos+(yOffSlider*4.2))
    .setHeight(15)
    .setWidth(120)
    .setGroup(g2);

  cp5.addSlider("partialFine")
    .setRange(0, 100).setPosition(2, yGuiPos+(yOffSlider*6))
    .setHeight(15)
    .setWidth(120)
    .setGroup(g2);

  cp5.addSlider("colorStart")
    .setRange(0, 360)
    .setPosition(2, yGuiPos+(yOffSlider*8))
    .setHeight(15)
    .setWidth(120)
    .setGroup(g2);

  cp5.addSlider("colorRange")
    .setRange(0, 360)
    .setPosition(2, yGuiPos+(yOffSlider*10))
    .setHeight(15)
    .setWidth(120)
    .setGroup(g2);

  /*
  Bang gb1 = cp5.addBang("bangLoad").setPosition(206, 5)
   .setSize(35, 20).setTriggerEvent(Bang.RELEASE).setCaptionLabel("load IMG")
   .setColorBackground(#0D6FBC).setColorForeground(#CED2DB).setGroup(g2);
   */

  ////////////////////////////////////////
  //--------------------- > Add GROUP 3 DIAGRAMS for join the dots
  Group g3 = cp5.addGroup("g3")
    .setPosition(xGuiPos, 155)
    .setWidth(210)
    .activateEvent(true)
    .setBackgroundColor(color( #C9BFBF, 33 ))  //#CED2DB, #C9BFBF
    .setBackgroundHeight(260)
    .setLabel("DIAGRAM")
    .setBarHeight(18);

  //--------------------- > diagram params
  cp5.addSlider("numDots")
    .setRange(1, 200)
    .setPosition(2, 5)
    .setHeight(15)
    .setWidth(120)
    .setGroup(g3);

  cp5.addSlider("lineThresh")
    .setRange(1, 150)
    .setPosition(2, yGuiPos)
    .setHeight(15)
    .setWidth(120)
    .setGroup(g3);

  cp5.addSlider("dotSize")
    .setRange(0.5, 30)
    .setPosition(2, yGuiPos*1.8)
    .setHeight(15)
    .setWidth(120)
    .setGroup(g3);

  cp5.addSlider("txtSize")
    .setRange(0.5, 30)
    .setPosition(2, yGuiPos*2.5)
    .setHeight(15)
    .setWidth(120)
    .setGroup(g3);

  /////////////////////////////////////////////
  // drop down list for diagram algorithms
  s1 = cp5.addScrollableList("Algorithm")
    .open()
    .setPosition(2+80, yGuiPos+(yOffButton*5))
    .addItems(algorithms)
    .setItemHeight(20)
    .setBarHeight(20)
    .setHeight(80)
    .setGroup(g3);


  //--------------------- > diagram params
  cp5.addToggle("bDrawDiagram")
    .setLabel("diagram")
    .setPosition(2, yGuiPos+(yOffButton*3))
    .setGroup(g3);

  cp5.addToggle("bDrawDiagramLines")
    .setLabel("lines").setPosition(2+50, yGuiPos+(yOffButton*3))
    .setGroup(g3);

  cp5.addToggle("bDrawDiagramDotNumbers")
    .setLabel("dots").setPosition(2+100, yGuiPos+(yOffButton*3))
    .setGroup(g3);

  cp5.addToggle("bComputeGlobalDiagram")
    .setLabel("one diagram")
    .setPosition(2, yGuiPos+(yOffButton*5))
    .setGroup(g3);

  //--------------------- > Export & properties save
  cp5.addButton("exportPDF")
    .setLabel("export").setPosition(2, yGuiPos+(yOffButton*7.2))
    .setGroup(g3);

  cp5.addButton("saveProperties")
    .setLabel("save values")
    .setPosition(2, yGuiPos+(yOffButton*8.5))
    .setGroup(g3);

  cp5.addButton("loadProperties")
    .setLabel("load values")
    .setPosition(2, yGuiPos+(yOffButton*9.5))
    .setGroup(g3);

  // TO ADD : a text for displying number of points
  //cp5.addTextField().setLabel("load values").setPosition(2, yGuiPos+(yOffButton*8.5)).setGroup(g3);
  //getNumPoints
  // Be careful - this saves all cp5 properties including controllers!
  //cp5.loadProperties("values_init");

  /////GROUP FOR PRINTED DIAGRAM

  Group g4 = cp5.addGroup("g4")
    .setPosition(xGuiPos, 450)
    .setWidth(210)
    .activateEvent(true)
    .setBackgroundColor(color( #C9BFBF, 33 ))  //#CED2DB, #C9BFBF
    .setBackgroundHeight(260)
    .setLabel("DIAGRAM PRINT")
    .setBarHeight(18);

  cp5.addSlider("print_Lvl")
    .setRange(0, 20)
    .setPosition(2, 10)
    .setHeight(15)
    .setWidth(120)
    .setGroup(g4);

    cp5.addToggle("bPrintNumbers")
    .setLabel("NB").setPosition(2, yGuiPos+10)
    .setGroup(g4);
  
  cp5.addSlider("skipNumber")
    .setRange(1, 10)
    .setPosition(2, (yGuiPos+10) * 2+4)
    .setHeight(15)
    .setWidth(120)
    .setGroup(g4);

  cp5.addToggle("bShapes")
    .setLabel("SHP").setPosition(2, (yGuiPos+10) * 3+4)
    .setGroup(g4);
}


/////////////////////////////////////////
// ::::::::: GUI METHODS :::::::::::::::
////////////////////////////////////////
/*
  void controlEvent(ControlEvent e) {
 String name = e.getName();
 
 if (name.equals("blurlvl"))
 {
 //blurlvl = int(e.getValue());
 } else if (name.equals("levels"))
 {
 //  levels = (int)e.getValue();
 } else if (name.equals("levelMax"))
 {
 levelMax = e.getValue();
 } else if (name.equals("is_Diagram"))
 {
 } else if (name.equals("maxPixelH"))
 {
 } else if (name.equals("partialFactor"))
 {
 //levels = (int)e.getValue();
 } else if (name.equals("thresh"))
 {
 } else if (name.equals("loadProperties"))
 {
 }
 }
 */

void FilterType(int n) {
  cp5.get(ScrollableList.class, "Algorithm").getItem(n);
}

////////////////////////////////////////
void exportPDF() {
  bExportPDF = true;
}
////////////////////////////////////////// Bang button updates

//////////////////////////////////
// Button updates for saving & loading properties
public void saveProperties() {
  selectOutput("Save a preset", "fileSelectedOut");
}
public void loadProperties() {
  selectInput("Load a preset", "fileSelectedLoad");
}


// File Selection method for choosing saved presets
void fileSelectedLoad(File selection) {
  try {
    if (selection != null)
      println("User selected " + selection.getAbsolutePath());
    String s = selection.getAbsolutePath();
    String message = "New preset loaded: "+s;
    cp5.loadProperties(s);
    println("///////////////////////////////////////");
    println(message);
    println("///////////////////////////////////////");
  }
  catch(Exception e) {
    println("/////////////////////////////////////////////////");
    println("You haven't chosen the right file buddy");
    println("/////////////////////////////////////////////////");
  }
}

// File saving method for saving presets
void fileSelectedOut(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    String s = selection.getAbsolutePath();
    cp5.saveProperties(s);
  }
}