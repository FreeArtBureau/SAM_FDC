/*
 * displaying data information
 * 
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
   text("...................................", txtPosX+200,txtPosY-22);
   //text("...................................", txtPosX+400,txtPosY-22);
   textSize(16);
   fill(0,0,100);
   text("JOINDRE LES POINTS AVEC SAM",txtPosX, txtPosY);
   text("DESSIN ACTUEL : "+theData.fileName, txtPosX, txtPosY+interLine);
   text("POINT ACTUEL : "+theAgents.get(theAgents.size()-1).CURRENT_INDEX, txtPosX, txtPosY+interLine*2);
   text("POSITION ACTUEL : "+theAgents.get(theAgents.size()-1).CURRENT_POS.x + " : "+theAgents.get(0).CURRENT_POS.y, txtPosX, txtPosY+interLine*3);


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
  //  text(". . . . . . . . . . . . . . . . .",, txtPosX+300,txtPosY-24);
   textSize(36);
   fill(0,0,100);
   text("JOINDRE LES POINTS AVEC SAM",txtPosX, txtPosY+10);
   textSize(8);
   fill(0,0,100);
   text(". . . . . . . . . . . . . . . . .", txtPosX,txtPosY+interLine);

    popMatrix();

 }

 void displayBorders(){
   noStroke();
   float xOffset = 0;
   float yOffset = 0;
   float dotSize = 3;
   for(int x=40; x<width-40; x+=15){
     fill(0,0,100);
     if(x%2==0){
       yOffset=5;
     }else{
       yOffset=-5;
     }
     ellipse(x, 40+yOffset, dotSize,dotSize);
   }
   pushMatrix();
   translate(0,height-70);
   for(int x=40; x<width-40; x+=15){
     fill(0,0,100);
     if(x%2==0){
       yOffset=5;
     }else{
       yOffset=-5;
     }
     ellipse(x, 40+yOffset, dotSize,dotSize);
   }
   popMatrix();

   for(int y=40; y<height-40; y+=15){
     fill(0,0,100);
     if(y%2==0){
       yOffset=5;
     }else{
       yOffset=-5;
     }
     ellipse(40, y+yOffset, dotSize,dotSize);
   }
   pushMatrix();
   translate(width-80,0);
      for(int y=40; y<height-40; y+=15){
   fill(0,0,100);
   if(y%2==0){
     yOffset=5;
   }else{
     yOffset=-5;
   }
   ellipse(40, y+yOffset, dotSize,dotSize);
 }
    popMatrix();

 }

 void displaySAMName(float _displayX, float _displayY){
   float txtPosX = 0;
   float txtPosY = 10;
   float interLine = 26;
   pushMatrix();
   translate(_displayX, _displayY);
   textSize(8);
   fill(0,0,100);
   text("...............................", txtPosX,txtPosY-22);
   textSize(12);
   fill(0,0,100);
   String s = "╔═╗╔═╗╔╦╗\n╚═╗╠═╣║║║\n╚═╝╩ ╩╩ ╩";
   text(s, 0,5);
   textSize(8);
    text("...............................", txtPosX,txtPosY+34);
    textSize(12);
   text("La machine ", 70,10);
   text("qui dessine", 70,31);
   popMatrix();
 }
