/*
@USAGE :
 
 physicalButton button;
 
 void setup() 
 {
 size(200, 200);
 button = new physicalButton(this,2);
 }
 void draw()
 {
 if(button.isClick()){
 println("take a picture");
 }
 }
 
 */

import processing.serial.*;

class physicalButton { 

  Serial myPort;
  boolean canClick = true; //boolean to activate / desactivate
  int WAIT_TIME = 3500; // duration between next activation
  int lastClick; 


  physicalButton (PApplet _main, int portIndex) {  
    printArray(Serial.list());
    String portName = Serial.list()[portIndex];
    myPort = new Serial(_main, portName, 9600);
    delay(2000); //weird fasle positive on startup
    myPort.clear();
  }

  //utility setters 
  void enableClick() {
    canClick = true;
  }
  void disableClick() {
    canClick = false;
  }

  boolean hasFinished() {
    return millis() - lastClick > WAIT_TIME;
  }

  //retrive the messages from the serial and 
  boolean isClick() {  
    boolean click = false;
    if ( myPort.available() > 0) {  // If data is available,
      int val = myPort.read();
      if (val=='p' && hasFinished() && canClick) {
        println("pressed");
        lastClick = millis();
        return click;
      }
    }
    return click;
  }
}