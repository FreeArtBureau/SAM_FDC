import java.awt.Rectangle;
import java.awt.image.BufferedImage;

PImage source, result;
SkeletonFilter filterSkelt;
Rectangle r;
int s = 1;
float invs = 1.0/s;//inverse scale

PImage resizeImage(PImage in, int factor) {
  PImage out = createImage(in.width/factor, in.height/factor, RGB);
  for (int y=0; y<out.height; y++) {
    for (int x=0; x<out.width; x++) {
      PImage segment = in.get(x*factor, y*factor, factor, factor);
      color c = averageColor(segment);
      int index = x + y * out.width;
      out.pixels[index] = c;
    }
  }
  return out;
}

color averageColor(PImage in) {
  int r = 0, g = 0, b = 0;
  for (int i=0; i<in.pixels.length; i++) {
    color c = in.pixels[i];
    int rPixel = (c >> 16)&0xff;
    int gPixel = (c >> 8)&0xff;
    int bPixel = (c)&0xff;
    r += rPixel;
    g += gPixel;
    b += bPixel;
  }
  r /= in.pixels.length;
  g /= in.pixels.length;
  b /= in.pixels.length;
  return color(r, g, b);
}
PImage skeletonize(PImage source) {
  PImage result = source.get();
  int previousCount = source.pixels.length+1;
  int diff = source.pixels.length;
  while (diff > 0) {
    result = filterSkelt.filter(result, 1);
    int currentCount = pixelCount(result, 0xFFFFFFFF);
    diff = abs(previousCount-currentCount);
    previousCount = currentCount;
  }
  return result;
}

Rectangle getBounds(PImage source, int chroma) {
  int minX = width, minY = height, maxX = 0, maxY = 0;
  int numPixels = source.pixels.length, w = source.width, h = source.height;
  for (int i = 0; i < numPixels; i++) {
    int x = i%w;
    int y = i/w;
    int c = source.pixels[i];
    if (c != chroma) {
      if (x < minX) minX = x;
      if (x > maxX) maxX = x;
      if (y < minY) minY = y;
      if (y > maxY) maxY = y;
    }
  }
  return new Rectangle(minX, minY, maxX-minX, maxY-minY);
}

int pixelCount(PImage src, int clr) {
  int result = 0;
  int numPixels = src.pixels.length;
  for (int i = 0; i < numPixels; i++) if (src.pixels[i] == clr) result++;
  return result;
}
import java.awt.*;
import java.awt.image.*;
// Jerry Huxtable's SkeletonFilter http://www.jhlabs.com/ip/filters/ modified for PImage (rather than casting to BufferedImage back and forth)
// Based on an algorithm by Zhang and Suen (CACM, March 1984, 236-239).
public class SkeletonFilter {
  int newColor = 0xffffffff;
  int colormap;
  private final byte[] skeletonTable = {
    0, 0, 0, 1, 0, 0, 1, 3, 0, 0, 3, 1, 1, 0, 1, 3,
    0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 3, 0, 3, 3,
    0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0,
    2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 3, 0, 2, 2,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0,
    3, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 2, 0,
    0, 1, 3, 1, 0, 0, 1, 3, 0, 0, 0, 0, 0, 0, 0, 1,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    2, 3, 1, 3, 0, 0, 1, 3, 0, 0, 0, 0, 0, 0, 0, 1,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    2, 3, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    3, 3, 0, 1, 0, 0, 0, 0, 2, 2, 0, 0, 2, 0, 0, 0
  };
  public SkeletonFilter() {
    newColor = 0xffffffff;
  }
  PImage filter(PImage source, int iterations) {
    PImage out = createImage(source.width, source.height, RGB);
    try {
      int width = source.width;
      int height = source.height;
      int[] inPixels = source.pixels;
      int[] outPixels = new int[width * height];
      int count = 0;
      int black = 0xff000000;
      int white = 0xffffffff;
      for (int i = 0; i < iterations; i++) {
        count = 0;
        for (int pass = 0; pass < 2; pass++) {
          for (int y = 1; y < height-1; y++) {
            int offset = y*width+1;
            for (int x = 1; x < width-1; x++) {
              int pixel = inPixels[offset];
              if (pixel == black) {
                int tableIndex = 0;
                if (inPixels[offset-width-1] == black)
                  tableIndex |= 1;
                if (inPixels[offset-width] == black)
                  tableIndex |= 2;
                if (inPixels[offset-width+1] == black)
                  tableIndex |= 4;
                if (inPixels[offset+1] == black)
                  tableIndex |= 8;
                if (inPixels[offset+width+1] == black)
                  tableIndex |= 16;
                if (inPixels[offset+width] == black)
                  tableIndex |= 32;
                if (inPixels[offset+width-1] == black)
                  tableIndex |= 64;
                if (inPixels[offset-1] == black)
                  tableIndex |= 128;
                int code = skeletonTable[tableIndex];
                if (pass == 1) {
                  if (code == 2 || code == 3) {
                    pixel = newColor;
                    count++;
                  }
                } else {
                  if (code == 1 || code == 3) {
                    pixel = newColor;
                    count++;
                  }
                }
              }
              outPixels[offset++] = pixel;
            }
          }
          if (pass == 0) {
            inPixels = outPixels;
            outPixels = new int[width * height];
          }
        }
        if (count == 0)
          break;
      }
      out.pixels = outPixels;
    }
    catch (Exception e) {
      e.printStackTrace();
    }
    return out;
  }
}
