precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

varying vec2 vUv;

const float PI = 3.1415926;

float atan2(float y, float x) {
  return x == 0.0 ? sign(y) * PI / 2.0 : atan(y, x);
}

vec2 xy2pol(vec2 xy) {
  return vec2(atan2(xy.y, xy.x), length(xy));
}

vec2 pol2xy(vec2 pol) {
  return pol.y * vec2(cos(pol.x), sin(pol.x));
}

vec3 hsv2rgb(vec3 c) {
  vec3 rgb = clamp(abs(mod(c.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
  return c.z * mix(vec3(1.0), rgb, c.y);
}

void main() {
  vec2 pos = vUv;

  pos = 2.0 * pos.xy - vec2(1.0);
  pos = xy2pol(pos);
  pos.x = mod(0.5 * pos.x / PI, 1.0);

  gl_FragColor = vec4(hsv2rgb(vec3(pos, 1.0)), 1.0);
}
