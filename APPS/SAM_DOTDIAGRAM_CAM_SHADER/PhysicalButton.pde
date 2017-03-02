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

 }
 }
 
 */

import processing.serial.*;

class physicalButton { 

  Serial myPort;
  boolean canClick = true; //boolean to activate / desactivate
  int WAIT_TIME = 30000; // duration between next activation in millisec
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
    if ( myPort.available() > 0) {  // If data is available,
      int val = myPort.read();
      if (val=='p' && hasFinished() && canClick) {
        lastClick = millis();
        return true;
      }
    }
    return false;
  }
}