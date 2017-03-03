/*
 * A list of functions
 * Added Canny
 * updated : 01.03.16
 */

////////////////////////////////////////
void computeBlobs() {
  theBlobDetection = new BlobDetection[(int)levels];
  try {
    for (int i=0; i<levels; i++) {
      theBlobDetection[i] = new BlobDetection(img.width, img.height);
      theBlobDetection[i].setThreshold(float(i)/float(levels) * levelMax);
      //theBlobDetection[i].computeBlobs(img.pixels);
      theBlobDetection[i].computeBlobs(img.pixels);
    }
  } 
  catch(Exception e) {
    //println("...just checking...");
  }
}

////////////////////////////////////////
void computeDiagrams() {
  //println("-- computeDiagrams()");
  if (bComputeGlobalDiagram) {
    theDiagrams = new DotDiagram[1];
    theDiagrams[0] = new DotDiagram();
  } else {
    theDiagrams = new DotDiagram[(int)levels];
    for (int i=0; i<levels; i++) {
      //println("-- diagram ["+i+"]");
      theDiagrams[i] = new DotDiagram();
      theDiagrams[i].setDiagramPoints( getPVectorFromBlobDetection( theBlobDetection[i], BLOB_FACTOR_X, BLOB_FACTOR_Y ) );
    }
  }
}

////////////////////////////////////////

void drawContours(int i, int scaleX, int scaleY, int offsetX, int offsetY) {
  Blob b;
  EdgeVertex eA, eB;
  float x, y;

  //if (i == 0 || theBlobDetection[i].getBlobNb() == 0) return;

  //if (is_Partial) {
  /////////////////////// draw only some of drawing
  try {
    if (theBlobDetection != null) {
      pushStyle();
      for (int n=partialFactor; n<theBlobDetection[i].getBlobNb(); n++)
      {
        b=theBlobDetection[i].getBlob(n);

        if (b!=null && (b.w*scaleX)*(b.h*scaleY)>=maxPixelH*maxPixelH)
        {
          stroke((float(i)/float(levels)*colorRange)+colorStart, 100, 100, alphaContours);
          for (int m=partialFactor*partialFine; m<b.getEdgeNb(); m++)
          {
            eA = b.getEdgeVertexA(m);
            eB = b.getEdgeVertexB(m);

            line(eA.x*scaleX, eA.y*scaleY, eB.x*scaleX, eB.y*scaleY);

            if (bDrawContoursVertex)
            {
              rect(eA.x*scaleX, eA.y*scaleY, 4, 4);
            }
          }
        }
      }
      popStyle();
    }
  } 
  catch(Exception e) {
    //println("...just checking...");
  }
}
//////////////// end


////////////////////////////////////////
void filterVisage(int _blur, float _thresh) {
  img = cam.copy();
  if (_blur>0) {
    //img.filter(BLUR, _blur);
    fastblur(img, _blur);
    //fastblur(img, 2);
  }
  if (_thresh>0) {
    img.filter(THRESHOLD, _thresh);
  }
}



//////////////////////////////////////// NB : use kk instead of hh for 24hour time
String getTime() {
  Date dNow = new Date( );
  SimpleDateFormat time = new SimpleDateFormat ("kk"+"_"+"mm"+"_"+"ss");
  println(time.format(dNow));
  String t = time.format(dNow);
  return t;
}

////////////////////////////////////////
ArrayList<PVector> getPVectorFromBlobDetection(BlobDetection bd, int scaleX, int scaleY) {
  ArrayList<PVector> points = new ArrayList<PVector>();
  Blob b;
  EdgeVertex eA, eB;
  try {
    for (int n=0; n<bd.getBlobNb(); n++) {
      b=bd.getBlob(n);

      if (b!=null && (b.w*scaleX)*(b.h*scaleY)>=maxPixelH*maxPixelH)
      {
        for (int m=0; m<b.getEdgeNb(); m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          points.add( new PVector(eA.x*scaleX, eA.y*scaleY) );
        }
      }
    }
  }
  catch(Exception e) {
    //println("...just checking...");
  }
  //println("-- found "+points.size()+ " point(s)");
  return points;
}

////////////////////////////////////////
void keyReleased() {
  if (key == 'h') {
    isGUI =!isGUI;
  }
  if (key == 's') {
    String t = getTime();
    saveFrame("Capture_"+ t +".png");
    println("saved a screen capture :–)");
  }
  if (key == 'n') {
    println("Number of actual dots = "+numberPoints);
  }
  if (key == 'p') {
    //isJsonExport = !isJsonExport;
        takePicture();
        theButton.lastClick = millis();

    //bExportPDF = !bExportPDF;
  }
  if (key == 'a') {
    println(img.width);
    println(img.height);
  }
}