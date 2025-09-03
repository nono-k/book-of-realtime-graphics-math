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

vec3 tex(vec2 st) {
  vec3[3] col3 = vec3[](
    vec3(0.0, 0.0, 1.0),
    vec3(1.0, 0.0, 0.0),
    vec3(1.0)
  );
  st.s = st.s / PI + 1.0;
  int ind = int(st.s);
  vec3 col = mix(col3[ind % 2], col3[(ind + 1) % 2], fract(st.s));
  return mix(col3[2], col, st.t);
}

void main() {
  vec2 pos = vUv;

  pos = 2.0 * pos.xy - vec2(1.0);
  pos = xy2pol(pos);

  gl_FragColor = vec4(tex(pos), 1.0);
}
