import java.io.*;
import javax.print.*;
import javax.print.attribute.*; 
import javax.print.attribute.standard.*; 


void Print(String _path) {
  FileInputStream psStream = null;
  try {
    psStream = new FileInputStream(_path );
  } 
  catch (FileNotFoundException ffne) {
    ffne.printStackTrace();
  }
  if (psStream == null) {
    return;
  }
  
  DocFlavor psInFormat = DocFlavor.INPUT_STREAM.AUTOSENSE;
  Doc myDoc = new SimpleDoc(psStream, psInFormat, null);  
  PrintRequestAttributeSet aset = new HashPrintRequestAttributeSet();
  
  aset.add(MediaSizeName.ISO_A4);
  aset.add(new PrinterResolution(300, 300, PrinterResolution.DPI));
  aset.add(OrientationRequested.PORTRAIT);

  // this step is necessary because I have several printers configured
  PrintService myPrinter = PrintServiceLookup.lookupDefaultPrintService();


  if (myPrinter != null) {            
    DocPrintJob job = myPrinter.createPrintJob();
    try {
      job.print(myDoc, aset);
    } 
    catch (Exception pe) {
      pe.printStackTrace();
    }
  } else {
    System.out.println("no printer services found");
  }
}