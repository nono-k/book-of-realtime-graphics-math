precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

varying vec2 vUv;

const float PI = 3.1415926;

vec2 rot2(vec2 p, float t) {
  return vec2(cos(t) * p.x - sin(t) * p.y, sin(t) * p.x + cos(t) * p.y);
}

vec3 rotX(vec3 p, float t) {
  return vec3(p.x, rot2(p.yz, t));
}

float text(vec2 st) {
  return mod(floor(st.s) + floor(st.t), 2.0);
}


void main() {
  vec2 pos = (2.0 * gl_FragCoord.xy - u_resolution.xy) / min(u_resolution.x, u_resolution.y);

  vec3 cPos = vec3(0.0, 0.0, 0.0);
  float t = -0.5 * PI * (u_mouse.y / u_resolution.y);
  vec3 cDir = rotX(vec3(0.0, 0.0, -1.0), t);
  vec3 cUp = rotX(vec3(0.0, 1.0, 0.0), t);
  vec3 cSide = cross(cDir, cUp);
  float targetDepth = 1.0;
  vec3 ray = cSide * pos.x + cUp * pos.y + cDir * targetDepth - cPos;
  ray = normalize(ray);

  vec3 groundNormal = vec3(0.0, 1.0, 0.0);
  float groundHeight = 1.0 + (u_mouse.x / u_resolution.x);
  vec3 col;

  if (dot(ray, groundNormal) < 0.0) {
    vec3 hit = cPos - ray * groundHeight / dot(ray, groundNormal);
    col = vec3(text(hit.zx));
  } else {
    col = vec3(0.0);
  }

  gl_FragColor = vec4(col, 1.0);
}
