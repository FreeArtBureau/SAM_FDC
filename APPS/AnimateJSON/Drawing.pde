/*
 * Class for saving & displaying drawings
 */



 class Drawing{
   ArrayList<PVector> points;
   int drawingNumber;

   Drawing(){
     points = new ArrayList<PVector>();
     drawingNumber = 0;
   }

   void setDrawingPoints(ArrayList<PVector> _pnts){
     this.points = _pnts;
   }

   void displayDrawing(float _displayDrawingX, float _displayDrawingY, float _drawingScale, int _hue, float _dia){
     noStroke();
     fill(_hue,100,100);
     pushMatrix();
     translate(_displayDrawingX, _displayDrawingY);
     scale(_drawingScale);
     for(int i=0; i<points.size();i++){
       ellipse(points.get(i).x, points.get(i).y, _dia, _dia);
     }
     popMatrix();
   }

 }
