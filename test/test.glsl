float plotLine(float y, float x) {
    return abs(y - x);
}

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_uv) {
    float y = mod(uv.x, 0.2);
    float d = plotLine(uv.y, y);
    float c = 1 - smoothstep(0, 0.02, d);
    vec3 _c = c * vec3(0, 1, 0);

    return vec4(_c, 1.0);
}
