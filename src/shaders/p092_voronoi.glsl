precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

varying vec2 vUv;

const float PI = 3.1415926;

uvec3 k = uvec3(0x456789abu, 0x6789ab45u, 0x89ab4567u);
uvec3 u = uvec3(1, 2, 3);
const uint UINT_MAX = 0xffffffffu;

uint uhash11(uint n){
  n ^= (n << u.x);
  n ^= (n >> u.x);
  n *= k.x;
  n ^= (n << u.x);
  return n * k.x;
}

uvec2 uhash22(uvec2 n){
  n ^= (n.yx << u.xy);
  n ^= (n.yx >> u.xy);
  n *= k.xy;
  n ^= (n.yx << u.xy);
  return n * k.xy;
}

uvec3 uhash33(uvec3 n){
  n ^= (n.yzx << u);
  n ^= (n.yzx >> u);
  n *= k;
  n ^= (n.yzx << u);
  return n * k;
}

float hash11(float p){
  uint n = floatBitsToUint(p);
  return float(uhash11(n)) / float(UINT_MAX);
}

float hash21(vec2 p){
  uvec2 n = floatBitsToUint(p);
  return float(uhash22(n).x) / float(UINT_MAX);
}

float hash31(vec3 p){
  uvec3 n = floatBitsToUint(p);
  return float(uhash33(n).x) / float(UINT_MAX);
}

vec2 hash22(vec2 p){
  uvec2 n = floatBitsToUint(p);
  return vec2(uhash22(n)) / vec2(UINT_MAX);
}

vec3 hash33(vec3 p){
  uvec3 n = floatBitsToUint(p);
  return vec3(uhash33(n)) / vec3(UINT_MAX);
}

vec2 voronoi2(vec2 p) {
  vec2 n = floor(p + 0.5);
  float dist = sqrt(2.0);
  vec2 id;
  for (float j = 0.0; j <= 2.0; j++) {
    vec2 grid;
    grid.y = n.y + sign(mod(j, 2.0) - 0.5) * ceil(j * 0.5);
    if (abs(grid.y - p.y) - 0.5 > dist) {
      continue;
    }
    for (float i = -1.0; i <= 1.0; i++) {
      grid.x = n.x + i;
      vec2 jitter = hash22(grid) - 0.5;
      if (length(grid + jitter - p) <= dist) {
        dist = length(grid + jitter - p);
        id = grid;
      }
    }
  }
  return id;
}

vec3 voronoi3(vec3 p) {
  vec3 n = floor(p + 0.5);
  float dist = sqrt(3.0);
  vec3 id;
  for (float k = 0.0; k <= 2.0; k++) {
    vec3 grid;
    grid.z = n.z + sign(mod(k, 2.0) - 0.5) * ceil(k * 0.5);
    if (abs(grid.z - p.z) - 0.5 > dist) {
      continue;
    }
    for (float j = 0.0; j <= 2.0; j++) {
      grid.y = n.y + sign(mod(j, 2.0) - 0.5) * ceil(j * 0.5);
      if (abs(grid.y - p.y) - 0.5 > dist) {
        continue;
      }
      for (float i = -1.0; i <= 1.0; i++) {
        grid.x = n.x + i;
        vec3 jitter = hash33(grid) - 0.5;
        if (length(grid + jitter - p) <= dist) {
          dist = length(grid + jitter - p);
          id = grid;
        }
      }
    }
  }
  return id;
}

void main() {
  vec2 pos = gl_FragCoord.xy / min(u_resolution.x, u_resolution.y);
  int channel = int(2.0 * gl_FragCoord.x / u_resolution.x);
  pos = 20.0 * pos + u_time;

  vec3 col = channel == 0 ? vec3(hash22(voronoi2(pos)), 1.0) : vec3(hash33(voronoi3(vec3(pos, u_time))));

  gl_FragColor = vec4(col, 1.0);
}
