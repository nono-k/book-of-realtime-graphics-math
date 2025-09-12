precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

varying vec2 vUv;

const float PI = 3.1415926;

uint k = 0x456789abu;
const uint UINT_MAX = 0xffffffffu;

uint uhash11(uint n) {
  n ^= (n << 1);
  n ^= (n >> 1);
  n *= k;
  n ^= (n << 1);
  return n * k;
}

float hash11(float p) {
  uint n = floatBitsToUint(p);
  return float(uhash11(n)) / float(UINT_MAX);
}

void main() {
  vec2 pos = gl_FragCoord.xy;
  pos += floor(60.0 * u_time);
  vec3 col = vec3(hash11(pos.x));

  gl_FragColor = vec4(col, 1.0);
}
