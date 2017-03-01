
/*
 * Some simple examples of custom drawing strategies
 * Can by written easily by others by extending the above main abstract class
 * SOFT used for Fête du Code Pompidou March 2017
 */

//////////////////////////////////////////////////
// >> Globals shared with these classes
int SEGMENT;
int INTERVALLE;
String FILE_DIR = "/Users/markwebster/Google Drive/Pomp_Files/json/";
String JSONFileName = "SAM_dessin_11_20_41.json";


public class FreeDraw extends DrawingStrategy {
  public void setup() {
    AUTHOR = "Mark";
    TITLE = "FreeDraw";
    background(0);
  }
  public void draw() {
    if (mousePressed) {
      int x = mouseX;
      int y = mouseY;
      fill(0, 0, 255);
      noStroke();
      ellipse(x, y, 3, 3);
      PVector drawingCoords = new PVector(x, y);

      // add coordinates
      PVector savedCoords = new PVector(x, y, 0);
      addCoords(savedCoords);
    }
  }
}

public class RandomPoints extends DrawingStrategy {
  public void setup() {
    AUTHOR = "Mark";
    TITLE = "RandomPoints";
    background(0);
  }
  public void draw() {
    randomSeed(1);
    drawPoints();
  }

  void drawPoints() {
    background(0);
    for (int i=0; i<20; i++) {
      float xPos = random(50, width-50);
      float yPos = random(50, height-50);
      PVector p = new PVector(xPos, yPos);
      fill(0, 200, 255);
      ellipse(p.x, p.y, 15, 15);

      // add coordinates
      if (SAVE_DRAWING_COORDS) {
        addCoords(p);
      }
    }
    if (SAVE_DRAWING_COORDS) {
      SAVE_DRAWING_COORDS =!SAVE_DRAWING_COORDS;
    }
  }
}


public class GeoType extends DrawingStrategy {
  RFont f;
  RShape s;
  RShape polyshp;
  RPoint[] points;
  int widthTranslate;
  int heightTranslate;

  public void setup() {
    f = new RFont("SourceSansPro-Bold.ttf", 233);
    s = f.toShape("sam");
    points = s.getPoints();
    AUTHOR = "Mark";
    TITLE = "GeoType";
    widthTranslate = width/8;
    heightTranslate = height/2;
    //println("W = "+widthTranslate+"\n H = "+heightTranslate);
  }

  public void draw() {
    background(0);
    pushMatrix();
    translate(widthTranslate, heightTranslate);

    RCommand.setSegmentLength(SEGMENT);
    polyshp = RG.polygonize(s);
    RPoint[] points = s.getPoints();

    for (int i=0; i<points.length; i++) {
      // add coordinates
      if (SAVE_DRAWING_COORDS) {
        PVector savedCoords = new PVector((points[i].x+widthTranslate), (points[i].y+heightTranslate));
        addCoords(savedCoords);
      }
      noFill();//
      strokeWeight(6);
      stroke(55, 200, 255);
      point(points[i].x, points[i].y);
    }
    if (SAVE_DRAWING_COORDS) {
      SAVE_DRAWING_COORDS =!SAVE_DRAWING_COORDS;
    }
    popMatrix();
  }
}

public class AnneAlgo extends DrawingStrategy {
  RShape polyshp;
  RPoint[] points;

  public void setup() {
    AUTHOR = "Mark";
    TITLE = "AnneALgo";
    IMGName = "anne_algo.svg";
    SHP = RG.loadShape(IMGName);

  }

  public void draw() {
    background(0);
    noFill();
    strokeWeight(2);
    stroke(55, 200, 255);
    RCommand.setSegmentLength(SEGMENT);
    polyshp = RG.polygonize(SHP);
    RPoint[] points = SHP.getPoints();

    for (int i=0; i<points.length; i+=INTERVALLE) {
      // add coordinates
      if (SAVE_DRAWING_COORDS) {
        PVector savedCoords = new PVector((int)(points[i].x), (int)(points[i].y));
        addCoords(savedCoords);
      }
      // Display coords as points
      point(points[i].x, points[i].y);
    }

    if (SAVE_DRAWING_COORDS) {
      SAVE_DRAWING_COORDS =!SAVE_DRAWING_COORDS;
    }
  }
}

/*
 * JSON drawing : ADDED 02.2017
 */

 public class JDraw extends DrawingStrategy {

   JsonData data;
   ArrayList<PVector> POINTS;

   public void setup() {
     AUTHOR = "Mark";
     TITLE = "JDraw";
     POINTS = new ArrayList<PVector>();
     data = new JsonData(0);
     data.loadData(0);
     println("JSON data size = "+data.getSize());
     POINTS=data.getPoints();

   }

   public void draw() {
     background(0);
     noFill();
     strokeWeight(2);
     stroke(55, 200, 255);

     for (int i=0; i<POINTS.size(); i++) {
       PVector savedCoords = new PVector(POINTS.get(i).x, POINTS.get(i).y);
       // add coordinates
       if (SAVE_DRAWING_COORDS) {
         addCoords(savedCoords);
       }
       // Display coords as points
       point(POINTS.get(i).x, POINTS.get(i).y);
     }

     if (SAVE_DRAWING_COORDS) {
       SAVE_DRAWING_COORDS =!SAVE_DRAWING_COORDS;
     }
   }
 }

/*
 * JSON drawing with offset : ADDED 02.2017
 */

 public class JDrawWithOffset extends DrawingStrategy {

   JsonData data;
   ArrayList<PVector> POINTS;
   PVector offset;

   public void setup() {
     AUTHOR = "Mark";
     TITLE = "JDraw";
     POINTS = new ArrayList<PVector>();
     data = new JsonData(0);
     data.loadData(0);
     println("JSON data size = "+data.getSize());
     POINTS=data.getPoints();
     offset = new PVector(0,0);
   }

   public void draw() {
     background(0);
     noFill();
     strokeWeight(2);
     stroke(55, 200, 255);

     for (int i=0; i<POINTS.size(); i++) {
       PVector savedCoords = new PVector(POINTS.get(i).x, POINTS.get(i).y); //addoffset
       // add coordinates
       if (SAVE_DRAWING_COORDS) {
         addCoords(savedCoords);
       }
       // Display coords as points
       point(POINTS.get(i).x, POINTS.get(i).y);
     }

     if (SAVE_DRAWING_COORDS) {
       SAVE_DRAWING_COORDS =!SAVE_DRAWING_COORDS;
     }
   }
 }


 /*
  *  A JSON class for reading JSON data from files
  */

  class JsonData {

    ArrayList<PVector> pnts;
    JSONObject json;
    JSONArray arrayOfCoords;
    JSONObject values;
    //String id;
    int idIndex;
    String portraitName;
    boolean isSave;
    int arraySize;

    JsonData(int _idIndex) {
      json = new JSONObject();
      arrayOfCoords = new JSONArray();
      json.setJSONArray("coordinates", arrayOfCoords);

      this.idIndex = _idIndex;

      // portrait.setInt("id",idIndex);
      isSave = false;
    }

    void setData(ArrayList<PVector> _pnts, boolean _b) {
      isSave = _b;
      pnts = _pnts;
      for (int i=0; i<pnts.size(); i++) {
        JSONObject data = new JSONObject();
        //PVector p =
        data.setInt("index", i);
        data.setFloat("x", pnts.get(i).x);
        data.setFloat("y", pnts.get(i).y);
        // add data to JSON array
        arrayOfCoords.setJSONObject(i, data);
      }
      // add portrait data to array
      //coordinates.setJSONObject(idIndex, portrait);
      if (isSave) {
        saveJSONObject(json, "data/jsonDataPortraits.json");
      }
    }

    int getSize() {
      JSONArray dataJSON = values.getJSONArray("coordinates");
      arraySize = dataJSON.size();
      return arraySize;
    }

    void loadData(int _id) {
      idIndex = _id;
      values = loadJSONObject(FILE_DIR+JSONFileName);
      //values = loadJSONObject("jsonDataPortraits.json");
      //println(values);
      println("JSON data loaded ;–)");
    }

    ArrayList<PVector> getPoints() {
      ArrayList<PVector> points = new ArrayList<PVector>();
      JSONArray dataJSON = values.getJSONArray("coordinates");
      for (int i=0; i<dataJSON.size (); i++) {
           JSONObject content =  dataJSON.getJSONObject(i);

            float x = content.getFloat("x");
            float y = content.getFloat("y");
            PVector p = new PVector(x, y);
            points.add(p);
      }
      return points;
    }
  }
