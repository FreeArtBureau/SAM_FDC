
uniform sampler2D tex;
varying vec4 vertTexCoord;


float threshold(in float thr1, in float thr2 , in float val) {
 if (val < thr1) {return 0.0;}
 if (val > thr2) {return 1.0;}
 return val;
}

// averaged pixel intensity from 3 color channels
float avg_intensity(in vec4 pix) {
 return (pix.r + pix.g + pix.b)/3.;
}

vec4 get_pixel(in vec2 coords, in float dx, in float dy) {
 return texture2D(tex,coords + vec2(dx, dy));
}

// returns pixel color
float IsEdge(in vec2 coords){
  float dxtex = 1.0 / 640.0 /*image width*/;
  float dytex = 1.0 / 480.0 /*image height*/;
  float pix[9];
  int k = -1;
  float delta;

  // read neighboring pixel intensities
  for (int i=-1; i<2; i++) {
   for(int j=-1; j<2; j++) {
    k++;
    pix[k] = avg_intensity(get_pixel(coords,float(i)*dxtex,float(j)*dytex));
   }
  }

  // average color differences around neighboring pixels
  delta = (
  		abs(pix[1]-pix[7]) +
  		abs(pix[5]-pix[3]) +
        abs(pix[0]-pix[8]) +
        abs(pix[2]-pix[6])
        )/4.;

  return threshold(0,1,clamp(1.8*delta,0.0,1.0));
}


float get_r(in vec4 pix ){
	return pix.r;
}

vec4 canny(in vec2 coords){
  float dxtex = 1.0 / 640.0 /*image width*/;
  float dytex = 1.0 / 480.0 /*image height*/;
  float pix[9];
  int k = -1;
  float delta;

  // read neighboring pixel intensities
  for (int i=-1; i<2; i++) {
   for(int j=-1; j<2; j++) {
    k++;
    pix[k] =  get_r(get_pixel( coords , float(i)*dxtex , float(j)*dytex )) ;
   }
  }


   float bottomLeftIntensity = pix[2];
   float topRightIntensity = pix[6];
   float topLeftIntensity = pix[0];
   float bottomRightIntensity = pix[8];
   float leftIntensity = pix[1];
   float rightIntensity = pix[7];
   float bottomIntensity = pix[5];
   float topIntensity = pix[3];



	vec2 gradientDirection;
    gradientDirection.x = -bottomLeftIntensity - 2.0 * leftIntensity - topLeftIntensity + bottomRightIntensity + 2.0 * rightIntensity + topRightIntensity;
    gradientDirection.y = -topLeftIntensity - 2.0 * topIntensity - topRightIntensity + bottomLeftIntensity + 2.0 * bottomIntensity + bottomRightIntensity;

    float gradientMagnitude = length(gradientDirection);
    vec2 normalizedDirection = normalize(gradientDirection);
    normalizedDirection = sign(normalizedDirection) * floor(abs(normalizedDirection) + 0.617316); // Offset by 1-sin(pi/8) to set to 0 if near axis, 1 if away
    normalizedDirection = (normalizedDirection + 1.0) * 0.5; // Place -1.0 - 1.0 within 0 - 1.0
    return vec4(gradientMagnitude, normalizedDirection.x, normalizedDirection.y, 1.0);
}

/*

void main()
{
  vec4 color = vec4(0.0,0.0,0.0,1.0);
  float c = isEdge(vertTexCoord.xy);
  color.rgb = vec3(c,c,c);
  gl_FragColor = color;
}

*/
void main()
{
  vec4 uv = vertTexCoord;
  uv.y = 1 - uv.y ;
  vec4 color = canny(uv.xy);
  gl_FragColor = color;
}






