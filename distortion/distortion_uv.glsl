uniform float u_tightness;
uniform float u_strength;

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_uv) {
    vec2 c_uv = uv * 2 - vec2(1);
    float m = abs(c_uv.x * c_uv.y);
    m = pow(m, u_tightness);

    uv = uv + c_uv * m * u_strength;
    if (uv.x < 0 || uv.x > 1 || uv.y < 0 || uv.y > 1) {
        return vec4(vec3(0), 1);
    }

    return Texel(tex, uv);
}
