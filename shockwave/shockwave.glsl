uniform vec2 u_aspect;
uniform vec2 u_mouse_pos;
uniform float u_time;

const float maxRadius = 0.2;

float circleSDF(vec2 p, float r) {
    return length(p) - r;
}

// get wave strength based on time t and direction
float waveStrength(float t, vec2 dir) {
    float dist = circleSDF(dir / u_aspect, t * maxRadius);
    // str based on distance
    float str = (1 - smoothstep(0, 0.05, abs(dist))) * dist;
    // str based on time
    str *= smoothstep(0, 0.05, t);
    str *= 1 - smoothstep(0.5, 1, t);
    return str;
}

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_uv) {
    vec2 dir = uv - u_mouse_pos;
    float str = waveStrength(u_time, dir);
    dir = normalize(dir);

    return Texel(tex, uv + dir * str);
}
