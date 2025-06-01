uniform vec2 u_mouse_pos;

float boxSDF(vec2 p, vec2 b) {
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_uv) {
    float d = boxSDF(uv - u_mouse_pos, vec2(0.02, 0.02));

    if (d < 0) {
        return vec4(vec2(uv.x, uv.y), 0.0, 1.0);
    }

    return vec4(1);
}
