uniform float u_tightness;

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_uv) {
    vec2 c_uv = uv * 2 - vec2(1);
    float m = abs(c_uv.x * c_uv.y);
    m = pow(m, u_tightness);

    return vec4(vec3(m), 1.0);
}
