/*
 * Class taking care of SAM's Serial data
 * SOFT used for Fête du Code Pompidou March 2017
 */
/////////////////////////////////////////

import vsync.*;
import processing.serial.*;
ValueSender sender;
public int SAM_X, SAM_Y, SAM_Z, PIXEL_SCALE;

class SamSerialData {
  PApplet p5;

  SamSerialData(PApplet p5) {
    this.p5 = p5;
    PIXEL_SCALE = 5; // !!!!!!! should be a global somewhere for this too - put with speed variable
    SAM_X = 0;
    SAM_Y = 0;
    SAM_Z = 0;
  }

  void updateSerialData(PVector _pos) {
    //println("This the what SAM recieves as pos data = "+_pos);
    PVector pMult = new PVector(_pos.x * PIXEL_SCALE, _pos.y * PIXEL_SCALE, 0.0);
    SAM_X = (int)pMult.x;
    SAM_Y = (int)pMult.y;
    SAM_Z = (int)_pos.z;

  }

  void initSerial() {
    String portName = Serial.list()[4]; // was 4 ?
    //printArray(Serial.list()); // debugging
    Serial serial = new Serial(p5, portName, 57600); // initially at 19200
    //receiver = new ValueReceiver(this, serial).observe("someVarA").observe("someVarB");
    sender = new ValueSender(p5, serial)
      .observe("SAM_X")
        .observe("SAM_Y")
          .observe("SAM_Z")
            .observe("PIXEL_SCALE");
  }
}
///////////////////////////////////////// SERIAL END
