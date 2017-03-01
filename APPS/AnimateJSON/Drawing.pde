/*
 * Class for saving & displaying drawings
 *
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

   void displayDrawing(float _displayDrawingX, float _displayDrawingY, float _drawingScale, int _hue, float _dia, boolean _line){

     pushMatrix();
     translate(_displayDrawingX, _displayDrawingY);
     scale(_drawingScale);
     for(int i=1; i<points.size();i++){
       float h = map(i, 0, points.size(), 1, 360);
       if(_line){
        PVector p1 = new PVector(points.get(i-1).x, points.get(i-1).y);
        PVector p2 = new PVector(points.get(i).x, points.get(i).y);
        float d = dist(p1.x, p1.y, p2.x, p2.y);
        if(d<40){
        stroke(h,100,100);
        line(p1.x, p1.y, p2.x, p2.y);
      }
      }else{
        noStroke();
             fill(_hue,100,100);
        ellipse(points.get(i).x, points.get(i).y, _dia, _dia);
       }
     }
     popMatrix();
   }

 }
