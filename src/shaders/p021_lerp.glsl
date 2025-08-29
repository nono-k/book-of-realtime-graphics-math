precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

varying vec2 vUv;

void main() {
  vec2 pos = vUv;
  vec3 RED = vec3(1.0, 0.0, 0.0);
  vec3 BLUE = vec3(0.0, 0.0, 1.0);
  vec3 col = mix(RED, BLUE, pos.x);
  gl_FragColor = vec4(col, 1.0);
}
