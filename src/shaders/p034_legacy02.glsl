precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

varying vec2 vUv;

const float PI = 3.1415926;

float fractSin21(vec2 xy) {
  return fract(sin(dot(xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void main() {
  vec2 pos = gl_FragCoord.xy;
  pos += floor(60.0 * u_time);
  vec3 col = vec3(fractSin21(pos.xy / u_resolution.xy));

  gl_FragColor = vec4(col, 1.0);
}
