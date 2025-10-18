precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

varying vec2 vUv;

const float PI = 3.1415926;
const float TAU = 6.2831853;

float circleSDF(vec2 p, vec2 c, float r) {
  return length(p - c) - r;
}

float contour(float v) {
  return step(abs(v), 0.002);
}

float point(vec2 p, vec2 c) {
  return step(length(p - c), 0.01);
}

float line(vec2 p, vec2 c, vec2 d) {
  return step(abs(dot(p - c, vec2(-d.y, d.x))), 0.002);
}

void main() {
  vec2 pos = (2.0 * gl_FragCoord.xy - u_resolution.xy) / min(u_resolution.x, u_resolution.y);

  vec2 cPos = vec2(-0.5, 0.0);
  vec2 oPos = vec2(1.0, 0.0);
  vec2 ray = oPos - cPos;
  ray.y += 2.0 * u_mouse.y / u_resolution.y - 1.0;
  ray = normalize(ray);

  float rad = 0.8;
  vec2 rPos = cPos;
  vec3 col;
  col = contour(circleSDF(pos, oPos, rad)) * vec3(1.0);
  col += line(pos, cPos, ray) * vec3(0.0, 0.0, 1.0);

  for (int i = 0; i < 50; i++) {
    col += point(pos, rPos) * vec3(1.0, 0.0, 0.0);
    float dist = circleSDF(rPos, oPos, rad);
    if (dist < 0.01) {
      break;
    }
    col += contour(circleSDF(pos, rPos, dist)) * vec3(0.5, 0.5, 0.0);
    rPos += dist * ray;

    if (rPos.x > oPos.x + rad) {
      break;
    }
  }

  gl_FragColor = vec4(col, 1.0);
}
