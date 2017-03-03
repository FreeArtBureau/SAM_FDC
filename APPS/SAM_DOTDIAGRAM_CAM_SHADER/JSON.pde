/*
 * READS JSON FILES
 * updated : 01.03.16
 */

class JsonData {

  ArrayList<PVector> pnts;
  JSONObject json;
  JSONArray arrayOfCoords;
  JSONObject values;
  int idIndex;
  String portraitName;
  boolean isSave;
  int arraySize;

  JsonData(int _idIndex) {
    json = new JSONObject();
    arrayOfCoords = new JSONArray();
    //arrayOfLevels = new JSONArray();
    this.idIndex = _idIndex;
    //json.setInt("id",idIndex);
    isSave = false;
  }

  void setData(ArrayList<PVector> _pnts, int _idx, boolean _b) {
    isSave = _b;
    pnts = _pnts;

      for (int i=0; i<pnts.size(); i++) {
        JSONObject data = new JSONObject();
        data.setInt("index", i);
        data.setFloat("x", pnts.get(i).x);
        data.setFloat("y", pnts.get(i).y);

        // add data to JSON array
        arrayOfCoords.setJSONObject(i, data);
    }
    json.setJSONArray("coordinates", arrayOfCoords);

    // add portrait data to array
    //coordinates.setJSONObject(idIndex, portrait);
    if (isSave) {
      String jsonTimeFile = getTime(); // getting current timestamp !
      saveJSONObject(json, filePath+"SAM_dessin_" + fileName+ ".json");
      println("SAVED JSON");
      //jsonFileIndex++;
    }
  }

  int getSize() {
    JSONArray dataJSON = values.getJSONArray("coordinates");
    arraySize = dataJSON.size();
    return arraySize;
  }

  void loadData(int _id) {
    idIndex = _id;
    values = loadJSONObject("data/jsonDataPortraits.json");
    println(values);
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