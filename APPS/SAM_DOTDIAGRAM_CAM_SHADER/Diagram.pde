/*
 * Displays a join the dot diagram
 * Added Canny
 * updated : 01.03.16
 */


class DotDiagram {
  ArrayList<PVector> SIMPLE_PNTS; // original points
  ArrayList<PVector> FILTER_PNTS; // filtered points
  float startEndpntSize= 5;

  DotDiagram() {
    SIMPLE_PNTS = new ArrayList<PVector>();
  }

  /*
   * set points data
   */
  void setDiagramPoints(ArrayList<PVector> _pnts) {
    SIMPLE_PNTS = _pnts;
  }

  int getNumPoints() {
    int n = 0;
    if (FILTER_PNTS != null ){
      n = FILTER_PNTS.size();
    }
    return n;
  }

  ArrayList <PVector> getFilterPoints(){
    return FILTER_PNTS;
  }


  PVector getPoint(int _i){
     PVector p = FILTER_PNTS.get(_i);
     return p;
  }


  void compute(int _step, int _mult, String _type){
    if (SIMPLE_PNTS == null || SIMPLE_PNTS.size() == 0) return;

    if (_type.equals("SIMPLE")) {
      FILTER_PNTS = SIMPLIFY_POLY(SIMPLE_PNTS, _step, SIMPLE_PNTS.size()/20);
    } else if (_type.equals("RADIAL")) {
      FILTER_PNTS = simplifyRadialDist(SIMPLE_PNTS, _step * _mult); //(_mult was 10)
    } else if (_type.equals("PEUCKER")) {
      FILTER_PNTS = simplifyDouglasPeucker(SIMPLE_PNTS, _step * _mult);
    }
  }

  /*
   * Displays diagram
   * @param _t is step for num of vertices
   * @param _tMax is threshold limit for line drawing
   * @param _isDots for showing dots + numbers
   */
  void displayDotDiagram(float _tMax, boolean _isLines, boolean _isDotsNum, int _levl) {
    if (FILTER_PNTS == null ) return;

    for (int i=0; i<FILTER_PNTS.size () - 1; i++) {
      PVector p1 = FILTER_PNTS.get(i);
      PVector p2 = FILTER_PNTS.get(i+1);
      float d = calculateDistance(p1, p2);

      if (_isLines) {
        if (d<_tMax) {
          stroke(((float(_levl)*colorRange)+colorStart)%360, 100, 100);
          line(p1.x, p1.y, p2.x, p2.y);
        }
      }
      if (_isDotsNum) {
        noStroke();
        fill(((float(_levl)*colorRange)+colorStart)%360, 100, 100);
        float xOff = float(_levl)*1.5;
        float yOff = float(_levl)*1.5;
        textSize(txtSize);
        text(i, p1.x-xOff, p1.y-8);
        //fill(((float(_levl)*colorRange)+colorStart)%360, 100, 100);
        ellipse(p1.x, p1.y, dotSize, dotSize);

        // draw start & end points
        fill(150, 100, 100);
        PVector ps = FILTER_PNTS.get(0);
        ellipse(ps.x, ps.y, dotSize+startEndpntSize, dotSize+startEndpntSize);
        fill(260, 100, 100);
        PVector pe = FILTER_PNTS.get(FILTER_PNTS.size () - 1);
        ellipse(pe.x, pe.y, dotSize+startEndpntSize, dotSize+startEndpntSize);
      }
    }
  }

  // square distance between 2 points
  public float getSqDist(PVector p1, PVector p2) {
    float dx = p1.x - p2.x,
      dy = p1.y - p2.y;
    return dx * dx + dy * dy;
  }

  // square distance from a point to a segment
  public float getSqSegDist(PVector p, PVector p1, PVector p2) {
    float x = p1.x,
      y = p1.y,
      dx = p2.x - x,
      dy = p2.y - y;
    if (dx != 0 || dy != 0) {
      float t = ((p.x - x) * dx + (p.y - y) * dy) / (dx * dx + dy * dy);
      if (t > 1) {
        x = p2.x;
        y = p2.y;
      } else if (t > 0) {
        x += dx * t;
        y += dy * t;
      }
    }
    dx = p.x - x;
    dy = p.y - y;
    return dx * dx + dy * dy;
  }

  // basic distance-based simplification
  public ArrayList<PVector> simplifyRadialDist(ArrayList<PVector> points, float sqTolerance) {
    PVector prevPoint = points.get(0);
    ArrayList<PVector> newPoints = new ArrayList<PVector>();
    newPoints.add(prevPoint);
    PVector point = new PVector();
    for (int i = 1, len = points.size (); i < len; i++) {
      point = points.get(i);

      if (getSqDist(point, prevPoint) > sqTolerance) {
        newPoints.add(point);
        prevPoint = point;
      }
    }
    if (prevPoint.x != point.x && prevPoint.y != point.y) newPoints.add(point);
    return newPoints;
  }

  public void simplifyDPStep(ArrayList<PVector> points, int first, int last, float sqTolerance, ArrayList<PVector> simplified) {
    float maxSqDist = sqTolerance;
    int index = 0;
    for (int i = first + 1; i < last; i++) {
      float sqDist = getSqSegDist(points.get(i), points.get(first), points.get(last));
      if (sqDist > maxSqDist) {
        index = i;
        maxSqDist = sqDist;
      }
    }
    if (maxSqDist > sqTolerance) {
      if (index - first > 1) simplifyDPStep(points, first, index, sqTolerance, simplified);
      simplified.add(points.get(index));
      if (last - index > 1) simplifyDPStep(points, index, last, sqTolerance, simplified);
    }
  }


  // simplification using Ramer-Douglas-Peucker algorithm
  public ArrayList<PVector> simplifyDouglasPeucker(ArrayList<PVector> points, float sqTolerance) {
    int last = points.size() - 1;
    ArrayList<PVector> simplified = new ArrayList<PVector>();
    simplified.add(points.get(0));
    simplifyDPStep(points, 0, last, sqTolerance, simplified);
    simplified.add(points.get(last));
    return simplified;
  }

  /**
   *
   * returns a new simplified list of points, from a given pvector
   * author: thomas diewald
   *
   * @param polyline to simplify
   * @param step    the number of vertices in a row, that are checked for the maximum offset
   * @param max_offset maximum offset a vertice can have
   * @return new simplified polygon
   */
  public ArrayList<PVector> SIMPLIFY_POLY(  ArrayList<PVector> polyline, int step, float max_offset ) {
    ArrayList<PVector> poly_simp = new ArrayList<PVector>();
    int index_cur  = 0;
    int index_next = 0;
    poly_simp.add(polyline.get(index_cur));

    while ( index_cur != polyline.size ()-1 ) {
      index_next = ((index_cur + step) >= polyline.size()) ? (polyline.size()-1) :  (index_cur + step);

      PVector p_cur  = polyline.get(index_cur);
      PVector p_next = polyline.get(index_next);

      while ( (++index_cur < index_next) &&  (max_offset > abs(distancePoint2Line(p_cur, p_next, polyline.get(index_cur))) ) );
      poly_simp.add(polyline.get(index_cur));
    }
    return poly_simp;
  }

  /**
   * author: thomas diewald
   * returns the shortest distance of a point(p3) to a line (p1-p2)
   */

  public float distancePoint2Line(PVector p1, PVector p2, PVector p3 ) {
    float x1 = p2.x-p1.x, y1 = p2.y-p1.y;
    if ( x1 == 0 && y1 == 0)
      return 0;
    float x2 = p3.x-p1.x, y2 = p3.y-p1.y;
    if ( x2 == 0 && y2 == 0)
      return 0;
    float A = x1*y2 - x2*y1;
    if ( A == 0)
      return 0;
    float p1p2_mag = (float)Math.sqrt(x1*x1 + y1*y1);
    return A/p1p2_mag;
  }
}
/////////////////////////////////////////////////////////// CLASS END
// does what it says ;–)
float calculateDistance(PVector _last, PVector _target) {
  float d = _last.dist( _target );
  return d;
}

void calculateTotalDiaPoints(int _levels){
  //levels = _levels;
  numberPoints = 0;
  for(int i=0; i<_levels; i++) {
    numberPoints += theDiagrams[i].getNumPoints();
  }
}


void calculateJSON(int _levels, boolean _b){
  ArrayList<PVector> ALL_PNTS = new ArrayList<PVector>(); // all points
  levels = _levels;
  /*
  for(int i=1; i<_levels; i++) {
    for(int j=0;j<theDiagrams[i].FILTER_PNTS.size();j++){
    ALL_PNTS.add(theDiagrams[i].FILTER_PNTS.get(j));
    }
  }
*/
  //ArrayList<PVector> points = new ArrayList<PVector>();
  for (int i=0; i<_levels; i++) {
    ALL_PNTS.addAll( getPVectorFromBlobDetection( theBlobDetection[i] ) );
}

  if(CANNY){
  myTSP.applyTSP(getBlackPoints());
  for(int i=0; i<myTSP.SAVED_PNTS.size();i++){
    PVector cannyPoints = myTSP.SAVED_PNTS.get(i);
    ALL_PNTS.add(cannyPoints);
  }
}
    DATA.setData(ALL_PNTS, _levels, _b);

}

// quick n' dirty
ArrayList<PVector> getBlackPoints() {
  ArrayList<PVector> blackPoints = new ArrayList<PVector>();
  loadPixels();
  for (int x = 5; x < width-5; x++) {
    for (int y = 5; y < height-5; y++) {
      if (brightness(pixels[y*width+x])<33) {
        blackPoints.add(new PVector(x, y));
      }
    }
  }
  return blackPoints;
}
