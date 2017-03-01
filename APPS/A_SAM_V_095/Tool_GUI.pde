/*
 * Graphical User Interface by Andreas Schlegel
 * ControlP5 : www.sojamo.de/controlP5
 * Using version 2.2.5
 * SOFT used for Fête du Code Pompidou March 2017
 */

ControlP5 INTERFACES;
//////////////////////// INTERFACE VARIABLES


//////////////////////////////////////////
void guiInit() {
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
    .setRange(1, 160).setValue(60.0).setGroup(g1)
      .setSize(100, 15)
        .setColorBackground(#F5F5F5).setColorForeground(#A09E9F)
          .setColorValueLabel(#525252).setColorActive(#F08D0C);

  Slider ls2 = INTERFACES.addSlider("MAX_SPEED").setPosition(10, 40)
    .setRange(0.4, 6.0).setValue(0.50).setGroup(g1)
      .setSize(100, 15)
        .setColorBackground(#F5F5F5).setColorForeground(#A09E9F)
          .setColorValueLabel(#525252).setColorActive(#F08D0C);

  Slider ls3 = INTERFACES.addSlider("SEGMENT").setPosition(10, 60)
    .setRange(1, 50).setValue(10).setGroup(g1)
      .setSize(100, 15)
        .setColorBackground(#F5F5F5).setColorForeground(#A09E9F)
          .setColorValueLabel(#525252).setColorActive(#F08D0C);

  Slider ls4 = INTERFACES.addSlider("INTERVALLE").setPosition(10, 80)
    .setRange(1, 50).setValue(2).setGroup(g1)
      .setSize(100, 15)
        .setColorBackground(#F5F5F5).setColorForeground(#A09E9F)
          .setColorValueLabel(#525252).setColorActive(#F08D0C);


  Bang b1 = INTERFACES.addBang("SAVE").setPosition(10, 110)
    .setSize(15, 15).setGroup(g1).setCaptionLabel("save")
      .setColorBackground(#F5F5F5).setColorForeground(#A09E9F)
        .setColorValueLabel(#525252).setColorActive(#F08D0C);

  Bang b2 = INTERFACES.addBang("START").setPosition(60, 110)
    .setSize(15, 15).setGroup(g1).setCaptionLabel("setup")
      .setColorBackground(#F5F5F5).setColorForeground(#A09E9F)
        .setColorValueLabel(#525252).setColorActive(#F08D0C);


  Bang b3 = INTERFACES.addBang("DRAW").setPosition(110, 110)
    .setSize(15, 15).setGroup(g1).setCaptionLabel("draw")
      .setColorBackground(#F5F5F5).setColorForeground(#A09E9F)
        .setColorValueLabel(#525252).setColorActive(#F08D0C);

  Bang b4 = INTERFACES.addBang("RESET").setPosition(60, 150)
    .setSize(15, 15).setGroup(g1).setCaptionLabel("reset")
      .setColorBackground(#F5F5F5).setColorForeground(#A09E9F)
        .setColorValueLabel(#525252).setColorActive(#F08D0C);

  Bang b5 = INTERFACES.addBang("QUIT").setPosition(10, 150)
    .setSize(15, 15).setGroup(g1).setCaptionLabel("quit")
      .setColorBackground(#F5F5F5).setColorForeground(#A09E9F)
        .setColorValueLabel(#525252).setColorActive(#F08D0C);


  Bang gb1 = INTERFACES.addBang("bangLoad").setPosition(10, 210)
    .setSize(10, 10).setTriggerEvent(Bang.RELEASE).setGroup(g1).setCaptionLabel("load IMG")
      .setColorBackground(#0D6FBC).setColorForeground(#0D6FBC);
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
  String message = "N° pnts = "+n;
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
void DrawingStrategy(int n){
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
void fileSelected(File selection) {
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
