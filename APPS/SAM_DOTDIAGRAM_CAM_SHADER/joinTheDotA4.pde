void joinTheDotA4() {
  //String ="Choisir une couleur\n";
  int itemIndex = (int)s1.getValue();
  String algorithm = algorithms[ itemIndex ];
  int DiagramOffY = 300;
  int DiagramOffX = 30;
  int pointCounter = 0;
  float pdfDotSize = 3;

  PGraphics pdf = createGraphics(596, 842, PDF, sketchPath() + "/PDF/" + fileName + ".pdf");
  pdf.beginDraw();
  pdf.fill(150, 100, 100);

  if (theDiagrams != null) {
    for (int i=0; i<theDiagrams.length && i < print_Lvl; i++) {
      //theDiagrams[i].compute(numDots, 20, algorithm); // 10 : SIMPLE [best]
      if (theDiagrams[i].FILTER_PNTS == null) {
        println("pas de points");
        //return;
      } else {
        //pdf.textSize(1);
        pdf.textFont(monoSmall);
        for (int j=0; j<theDiagrams[i].FILTER_PNTS.size () - 1; j++) {
          PVector p1 = theDiagrams[i].FILTER_PNTS.get(j);
          float xOff = float(levels)*1.5;
          float yOff = float(levels)*1.5;
          PVector ps = theDiagrams[i].FILTER_PNTS.get(0);
          PVector pe = theDiagrams[i].FILTER_PNTS.get(theDiagrams[i].FILTER_PNTS .size () - 1);
          float s = 0.5;
          pdf.noStroke();
          pdf.fill(0, 0, 0);
          //draw dots and numbers
          if (j % skipNumber ==0 && bPrintNumbers) {
            pointCounter ++;
            pdf.text(pointCounter, (p1.x*s) + DiagramOffX - xOff, (p1.y*s) - 8 + DiagramOffY);
          }

          if (bShapes) {
            if (i==1) {
              //elipse vide
              pdf.noFill();
              pdf.stroke(0, 0, 0);
              pdf.strokeWeight(0.5);
              pdf.ellipse(p1.x*s + DiagramOffX, p1.y*s + DiagramOffY, pdfDotSize+2, pdfDotSize+2);
              pdf.ellipse(ps.x*s + DiagramOffX, ps.y*s+ DiagramOffY, pdfDotSize+10, pdfDotSize+10);
              pdf.ellipse(pe.x*s + DiagramOffX, pe.y*s+ DiagramOffY, pdfDotSize+10, pdfDotSize+10);
            }
            if (i==2) {
              //elipse pleines

              pdf.noStroke();
              pdf.fill(0, 0, 0);
              pdf.ellipse(p1.x*s + DiagramOffX, p1.y*s + DiagramOffY, pdfDotSize, pdfDotSize);


              pdf.ellipse(p1.x*s + DiagramOffX, p1.y*s + DiagramOffY, pdfDotSize+1, pdfDotSize+1);
              pdf.ellipse(ps.x*s + DiagramOffX, ps.y*s+ DiagramOffY, pdfDotSize+10, pdfDotSize+10);
              pdf.ellipse(pe.x*s + DiagramOffX, pe.y*s+ DiagramOffY, pdfDotSize+10, pdfDotSize+10);
            }
            if (i==3) {
              //rectMode(CENTER);
              pdf.noFill();
              pdf.stroke(0, 0, 0);
              pdf.strokeWeight(0.5);
              float lineLength = 2;

              pdf.line( (p1.x*s) + DiagramOffX + lineLength, (p1.y*s) + DiagramOffY + lineLength, (p1.x*s) + DiagramOffX - lineLength, (p1.y*s) + DiagramOffY - lineLength );
              pdf.line( (p1.x*s) + DiagramOffX + lineLength, (p1.y*s) + DiagramOffY - lineLength, (p1.x*s) + DiagramOffX - lineLength, (p1.y*s) + DiagramOffY + lineLength );

              lineLength = 4;

              pdf.line( (ps.x*s) + DiagramOffX + lineLength, (ps.y*s) + DiagramOffY + lineLength, (ps.x*s) + DiagramOffX - lineLength, (ps.y*s) + DiagramOffY - lineLength );
              pdf.line( (ps.x*s) + DiagramOffX + lineLength, (ps.y*s) + DiagramOffY - lineLength, (ps.x*s) + DiagramOffX - lineLength, (ps.y*s) + DiagramOffY + lineLength );

              pdf.line( (pe.x*s) + DiagramOffX + lineLength, (pe.y*s) + DiagramOffY + lineLength, (pe.x*s) + DiagramOffX - lineLength, (pe.y*s) + DiagramOffY - lineLength );
              pdf.line( (pe.x*s) + DiagramOffX + lineLength, (pe.y*s) + DiagramOffY - lineLength, (pe.x*s) + DiagramOffX - lineLength, (pe.y*s) + DiagramOffY + lineLength );
            }
            if (i==4) {
              //rectMode(CENTER);
              pdf.noFill();
              pdf.stroke(0, 0, 0);
              pdf.strokeWeight(0.5);
              pdf.rect(p1.x*s + DiagramOffX, p1.y*s + DiagramOffY, pdfDotSize+2, pdfDotSize+2);
            }

            if (i==5) {
              //rectMode(CENTER);
              pdf.fill(0, 0, 0);
              pdf.noStroke();
              pdf.rect(p1.x*s + DiagramOffX, p1.y*s + DiagramOffY, pdfDotSize+1, pdfDotSize+1);
            }
          } else {
            pdf.noStroke();
            pdf.fill(0, 0, 0);
            pdf.ellipse(p1.x*s + DiagramOffX, p1.y*s + DiagramOffY, pdfDotSize, pdfDotSize);
            pdf.ellipse(p1.x*s + DiagramOffX, p1.y*s + DiagramOffY, pdfDotSize+1, pdfDotSize+1);
            pdf.ellipse(ps.x*s + DiagramOffX, ps.y*s+ DiagramOffY, pdfDotSize+10, pdfDotSize+10);
            pdf.ellipse(pe.x*s + DiagramOffX, pe.y*s+ DiagramOffY, pdfDotSize+10, pdfDotSize+10);
          }
        }
      }
    }
    pdf.dispose();
    pdf.endDraw();
  }
}