
/*
 @INSTANCIATE
 myPrinter = new Printer();
 @MAIN METHOD, param PGraphics 
 Printer.StartPrinting(PGraphics graphicToPrint);
 */


// @NEXT STEP : printJobAttribute to finetune the printing  
/*

 aset.add(new MediaPrintableArea(2, 2, 210 - 4, 297 - 4, MediaPrintableArea.MM));
 
 PrinterJob pj = PrinterJob.getPrinterJob();
 pj.setPrintable(new PrintTask());
 
 if (pj.printDialog(aset)) {
 try {
 pj.print(aset);
 } 
 catch (PrinterException ex) {
 ex.printStackTrace();
 }
 }
 */

import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.print.PageFormat;
import java.awt.print.Printable;
import java.awt.print.PrinterJob;
    import javax.print.*;

import javax.print.attribute.*;
import javax.print.attribute.standard.*; //format de papier and co


public class Printer implements Printable {
  public PrinterJob printJob;
     PrintRequestAttributeSet printAttribute;
  PGraphics destination;
  public Printer() {
    printAttribute = new HashPrintRequestAttributeSet();
    printAttribute.add(MediaSizeName.ISO_A4);
    printAttribute.add(new PrinterResolution(600, 600, PrinterResolution.DPI));
    printJob = PrinterJob.getPrinterJob();
    printJob.setPrintable(this); //interface printable @java need it
  }
  public void StartPrinting(PGraphics _source)
  {
    destination = _source;
    try {
      printJob.print(printAttribute);
    }
    catch (Exception PrintException) {
      PrintException.printStackTrace();
    }
  }

  public int print(Graphics pg, PageFormat pageFormat, int page) {
    pageFormat.setOrientation(PORTRAIT);
    Graphics2D g2d;
    if (page == 0) {
      g2d = (Graphics2D)pg;
      pg.drawImage(destination.image, 0, 0, null); // Java AWT Image Object caché ds le PGraphics
      return (PAGE_EXISTS);
    } else
      return (NO_SUCH_PAGE);
  }
} 