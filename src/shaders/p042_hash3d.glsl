precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

varying vec2 vUv;

const float PI = 3.1415926;

const uint UINT_MAX = 0xffffffffu;
uvec3 k = uvec3(0x456789abu, 0x6789ab45u, 0x89ab4567u);
uvec3 u = uvec3(1, 2, 3);

uvec3 uhash33(uvec3 n){
  n ^= (n.yzx << u);
  n ^= (n.yzx >> u);
  n *= k;
  n ^= (n.yzx << u);
  return n * k;
}

vec3 hash33(vec3 p){
  uvec3 n = floatBitsToUint(p);
  return vec3(uhash33(n)) / vec3(UINT_MAX);
}

void main() {
  float time = floor(60.0 * u_time);
  vec2 pos = gl_FragCoord.xy + time;
  vec3 col = vec3(hash33(vec3(pos, 1.0)));

  gl_FragColor = vec4(col, 1.0);
}
