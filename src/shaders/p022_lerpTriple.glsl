precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

varying vec2 vUv;

void main() {
  vec2 pos = vUv;

  vec3[3] col3 = vec3[](
    vec3(1.0, 0.0, 0.0),
    vec3(0.0, 0.0, 1.0),
    vec3(0.0, 1.0, 0.0)
  );

  pos.x *= 2.0;
  int ind = int(pos.x);

  vec3 col = mix(col3[ind], col3[ind + 1], fract(pos.x));
  gl_FragColor = vec4(col, 1.0);
}
