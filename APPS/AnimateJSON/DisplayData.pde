/*
 * displaying data information
 */



 void displayData(float _displayX, float _displayY){
   float txtPosX = 10;
   float txtPosY = 10;
   float interLine = 22;

   pushMatrix();
   translate(_displayX, _displayY);
   textSize(8);
   fill(0,0,100);
   text("...................................", txtPosX,txtPosY-22);
   textSize(16);
   fill(0,0,100);
   text("Hello SAM",txtPosX, txtPosY);
   text("DESSIN ACTUEL : "+theData.fileName, txtPosX, txtPosY+interLine);
   text("POINT ACTUEL : "+theAgents.get(0).CURRENT_INDEX, txtPosX, txtPosY+interLine*2);
   text("POSITION ACTUEL : "+theAgents.get(0).CURRENT_POS.x + " : "+theAgents.get(0).CURRENT_POS.y, txtPosX, txtPosY+interLine*3);


    popMatrix();

 }

 void displayTitle(float _displayX, float _displayY){
   float txtPosX = 10;
   float txtPosY = 10;
   float interLine = 26;

   pushMatrix();
   translate(_displayX, _displayY);
   textSize(8);
   fill(0,0,100);
   text(". . . . . . . . . . . . . . . . .", txtPosX,txtPosY-30);
   //text(". . . . . . . . . . . . . . . . .",, txtPosX+300,txtPosY-24);
   textSize(36);
   fill(0,0,100);
   text("JOINDRE LES POINTS AVEC SAM",txtPosX, txtPosY+10);
   textSize(8);
   fill(0,0,100);
   text(". . . . . . . . . . . . . . . . .", txtPosX,txtPosY+interLine);

    popMatrix();

 }
