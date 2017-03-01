/*
 * FUNCTIONS THAT MANAGE INCOMING DATA
 * Could implement the following : https://docs.oracle.com/javase/tutorial/essential/io/notification.html
 * as an alternative for DataLoadTask
 *
 */

 File[] listOfFiles;
 int folderSize;
 String currentFileInUse;
 String lastModifiedFile;

Timer timerLoadData;
 boolean isNewData = false;
 boolean redrawBG = false;

 ///////////////////////////// FUNCTIONS// TimerTask class lets us schedule & time java tasks.
 class DataLoadTask extends TimerTask{
   public void run() {
    println("run called");
    isNewData = checkNewData();
    //println(isNewData);

    if(isNewData) {
      saveFrame("Capture_###.png");
      redrawBG = true;
      println("Hey, we got some new data !");
      getData();
      isNewData=false;
    }else {
      //println("We are still waiting for new data Roger !");
    }
   }
 }

  void getData(){
     listOfFiles = folder.listFiles();
     Arrays.sort(listOfFiles);
     File lastFile = getLatestFilefromDir(filePath);
     currentFileInUse = lastFile.getName();
     //printCurrentFolderFiles();

     theData = new JsonData();
     theData.loadData(currentFileInUse);
     println("File: "+currentFileInUse);

     //add a new drawing Agent
     addNewAgent();
     addNewDrawing(theData.getPoints());
  }


  boolean checkNewData(){
    boolean test = false;
    File[] listOfFiles = folder.listFiles();
    int numElements = listOfFiles.length;
    //println("Latest number of elements in folder = "+numElements);
    //println("Last number of elements in folder = "+folderSize);

    if(folderSize<numElements){
      test = true;
      folderSize = numElements; // UPDATE folderSize ?
    }else {
       test = false;
    }
    return test;
  }

  void initFolder(){
  listOfFiles = folder.listFiles();
  Arrays.sort(listOfFiles);
  //printCurrentFolderFiles();
  folderSize = listOfFiles.length;

  File lastFile = getLatestFilefromDir(filePath);
  currentFileInUse = lastFile.getName();
  //currentFileInUse = "jsonDataPortraits_10_33_58.json";
}

  // Checks file names
  boolean isSame(String _s){
    if(_s.equals(currentFileInUse)){
    return true;
    }
    else return false;

  }

  /*
   * Gets last modified file in directory
   */

   File getLatestFilefromDir(String dirPath){
    File dir = new File(dirPath);
    // FileNameFilter filters out system files or any files
    File[] files = dir.listFiles(new FilenameFilter() {
     @Override
     public boolean accept(File dir, String name) {
         return !name.equals(".DS_Store");
     }
 });

    if (files == null || files.length == 0) {
        return null;
    }
   File lastModifiedFile = files[0];
    for (int i = 1; i < files.length; i++) {
       if ((lastModifiedFile.lastModified() < files[i].lastModified())) {
          lastModifiedFile = files[i];
       }
    }
    return lastModifiedFile;
 }

   void printCurrentFolderFiles(){
     for (int i = 0; i < listOfFiles.length; i++) {
       System.out.println(listOfFiles[i].getName());
       //System.out.println(listOfFiles[i].getName()+"\t"+new Date(listOfFiles[i].lastModified()));
     }
   }
