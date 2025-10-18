precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

varying vec2 vUv;

const float PI = 3.1415926;
const float TAU = 6.2831853;

vec2 rot2(vec2 p, float t) {
  return vec2(cos(t) * p.x - sin(t) * p.y, sin(t) * p.x + cos(t) * p.y);
}

vec3 rotX(vec3 p, float t) {
  return vec3(p.x, rot2(p.yz, t));
}

vec3 rotY(vec3 p, float t) {
  return vec3(p.y, rot2(p.zx, t)).zxy;
}

vec3 rotZ(vec3 p, float t) {
  return vec3(rot2(p.xy, t), p.z);
}

float sphereSDF(vec3 p, vec3 c, float r) {
  return length(p - c) - r;
}

float sceneSDF(vec3 p) {
  vec3 cent = rotY(vec3(0.0, 0.0, -0.5), u_time);
  float scale = 0.3;
  return sphereSDF(p, cent, scale);
}

vec3 gradSDF(vec3 p) {
  float eps = 0.001;
  return normalize(vec3(
    sceneSDF(p + vec3(eps, 0.0, 0.0)) - sceneSDF(p - vec3(eps, 0.0, 0.0)),
    sceneSDF(p + vec3(0.0, eps, 0.0)) - sceneSDF(p - vec3(0.0, eps, 0.0)),
    sceneSDF(p + vec3(0.0, 0.0, eps)) - sceneSDF(p - vec3(0.0, 0.0, eps))
  ));
}

void main() {
  vec2 pos = (2.0 * gl_FragCoord.xy - u_resolution.xy) / min(u_resolution.x, u_resolution.y);

  vec3 cPos = vec3(0.0, 0.0, 2.0);
  vec3 cDir = vec3(0.0, 0.0, -1.0);
  vec3 cUp = vec3(0.0, 1.0, 0.0);
  vec3 cSide = cross(cDir, cUp);

  float targetDepth = 1.0;
  vec3 lDir = rotY(vec3(0.0, 0.0, 1.0), u_time);

  vec3 ray = cSide * pos.x + cUp * pos.y + cDir * targetDepth;
  vec3 rPos = ray + cPos;
  ray = normalize(ray);

  gl_FragColor.rgb = vec3(0.0);

  for (int i = 0; i < 50; i++) {
    if (sceneSDF(rPos) > 0.001) {
      rPos += sceneSDF(rPos) * ray;
    } else {
      float amb = 0.1;
      float diff = 0.9 * max(dot(lDir, gradSDF(rPos)), 0.0);
      vec3 col = vec3(0.0, 1.0, 1.0);
      gl_FragColor.rgb = col * (diff + amb);
      break;
    }
  }

  gl_FragColor.a = 1.0;
}
