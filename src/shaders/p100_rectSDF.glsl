precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

varying vec2 vUv;

const float PI = 3.1415926;

float rect(vec2 p, vec2 c, vec2 d) {
  p = abs(p - c);
  return length(max(p - d, vec2(0.0))) + min(max(p.x - d.x, p.y - d.y), 0.0);
}

vec3 contour(float v, float interval) {
  return abs(v) < 0.01 ? vec3(0.0) :
    mod(v, interval) < 0.01 ? vec3(1.0) :
    mix(vec3(0.0, 0.0, 1.0), vec3(1.0, 0.0, 0.0), atan(v) / PI + 0.5);
}

void main() {
  vec2 pos = (2.0 * gl_FragCoord.xy - u_resolution.xy) / min(u_resolution.x, u_resolution.y);
  pos *= 1.3;

  float interval = 0.1;

  vec3 col = vec3(contour(rect(pos, vec2(0.0), vec2(0.5)), interval));
  gl_FragColor = vec4(col, 1.0);
}
