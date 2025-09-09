precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

varying vec2 vUv;

const float PI = 3.1415926;

float fractSin11(float x) {
  return fract(1000.0 * sin(x));
}

void main() {
  vec2 pos = gl_FragCoord.xy;
  pos += floor(60.0 * u_time);
  vec3 col = vec3(fractSin11(pos.x));

  gl_FragColor = vec4(col, 1.0);
}
