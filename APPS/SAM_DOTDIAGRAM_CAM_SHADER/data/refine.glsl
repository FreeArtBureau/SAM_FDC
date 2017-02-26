precision mediump float;

varying vec4 vertTexCoord;

uniform sampler2D inputImageTexture;
uniform highp float texelWidth;
uniform highp float texelHeight;
uniform mediump float upperThreshold;
uniform mediump float lowerThreshold;

void main()
{
    vec3 currentGradientAndDirection = texture2D(inputImageTexture, vertTexCoord.st).rgb;
    vec2 gradientDirection = ((currentGradientAndDirection.gb * 2.0) - 1.0) * vec2(texelWidth, texelHeight);

    float firstSampledGradientMagnitude = texture2D(inputImageTexture, vertTexCoord.st + gradientDirection).r;
    float secondSampledGradientMagnitude = texture2D(inputImageTexture, vertTexCoord.st - gradientDirection).r;

    float multiplier = step(firstSampledGradientMagnitude, currentGradientAndDirection.r);
    multiplier = multiplier * step(secondSampledGradientMagnitude, currentGradientAndDirection.r);

    float thresholdCompliance = smoothstep(lowerThreshold, upperThreshold, currentGradientAndDirection.r);
    multiplier = multiplier * thresholdCompliance;
if(multiplier>0){
    gl_FragColor = vec4(0, 0, multiplier, 1.0);
}else{
    gl_FragColor = vec4(0, 0, 0, 0.0);

}
}