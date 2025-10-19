precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

varying vec2 vUv;

const float PI = 3.1415926;
const float TAU = 6.2831853;

float sphereSDF(vec3 p, vec3 c, float r) {
  return length(p - c) - r;
}

float boxSDF(vec3 p, vec3 c, vec3 d, float t) {
  p = abs(p - c);
  return length(max(p - d, vec3(0.0))) + min(max(max(p.x - d.x, p.y - d.y), p.z - d.z), 0.0) - t;
}

float sceneSDF(vec3 p) {
  float[3] smallS, bigS;
  for (int i = 0; i < 3; i++) {
    smallS[i] = sphereSDF(p, vec3(float(i - 1), sin(u_time), 0.0), 0.3);
    bigS[i] = sphereSDF(p, vec3(float(i - 1), 0.0, 0.0), 0.5);
  }
  float cap = max(smallS[0], bigS[0]);
  float cup = min(smallS[1], bigS[1]);
  float minus = max(smallS[2], -bigS[2]);
  return min(min(cap, cup), minus);
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
  vec3 lDir = vec3(0.0, 0.0, 1.0);

  vec3 ray = cSide * pos.x + cUp * pos.y + cDir * targetDepth;
  vec3 rPos = ray + cPos;
  ray = normalize(ray);

  gl_FragColor.rgb = vec3(0.0);

  for (int i = 0; i < 50; i++) {
    if (sceneSDF(rPos) > 0.001) {
      rPos += sceneSDF(rPos) * ray;
    } else {
      float amb = 0.1;
      float diff = 0.9 * max(dot(normalize(lDir), gradSDF(rPos)), 0.0);
      vec3 col = vec3(1.0);
      gl_FragColor.rgb = col * (diff + amb);
      break;
    }
  }

  gl_FragColor.a = 1.0;
}
