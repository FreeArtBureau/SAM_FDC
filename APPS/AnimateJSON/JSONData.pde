/*
 * READS JSON DATA
 */

class JsonData {

  ArrayList<PVector> pnts;
  JSONObject json;
  JSONArray arrayOfCoords;
  JSONObject values;
  String fileName;
  int idIndex;
  String portraitName;
  boolean isSave;
  int arraySize;

  JsonData() {
    json = new JSONObject();
    arrayOfCoords = new JSONArray();
    json.setJSONArray("coordinates", arrayOfCoords);
    //this.fileName = _fileName;
    //this.idIndex = _idIndex;

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

 // need to add an argument for loading indexed files
  void loadData(String _fileName) {
    //idIndex = _id;
    //values = loadJSONObject( filePath + "jsonDataPortraits_"+idIndex+".json");
    this.fileName = _fileName;
    println(fileName);
    values = loadJSONObject( filePath + fileName);
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
