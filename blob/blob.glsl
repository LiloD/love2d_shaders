uniform vec2 u_mouse;
uniform float u_time;

#define LEN 3

float circleSDF(vec2 p, float r) {
    return length(p) - r;
}

float smin(float a, float b, float k) {
    float h = max(k - abs(a - b), 0.0) / k;
    return min(a, b) - h * h * k * (1.0 / 4.0);
}

vec2 remap(vec2 p) {
    return p * 2 - vec2(1);
}

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_uv) {
    vec2 uv_norm = remap(uv);
    vec2 m_norm = remap(u_mouse);

    float sin_d = sin(u_time) * 0.1;
    float cos_d = cos(u_time) * 0.1;

    vec2 p[LEN] = vec2[LEN](
            vec2(-0.25 + sin_d, -0.25),
            vec2(0.25, 0.25 + cos_d),
            m_norm
        );

    float d1 = 99;
    float d2 = 99;
    for (int i = 0; i < LEN; i++) {
        d1 = smin(d1, circleSDF(uv_norm - p[i], 0.5), 0.2);
        d2 = min(d2, circleSDF(uv_norm - p[i], 0.5));
    }

    d1 = smoothstep(0, 0.005, abs(d1));
    d2 = smoothstep(0, 0.005, abs(d2));

    vec3 c = mix(vec3(1), mix(vec3(1), vec3(0), d2), d1);

    return vec4(c, 1);
}
