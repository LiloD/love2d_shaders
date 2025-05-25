local M = {}

M.simple_gradient = [[
vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_uv) {
    return vec4(uv.x, uv.y, 0, 1.0);
}
]]

M.distance = [[
vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_uv) {
    float d = distance(uv, vec2(0.5));  // distance from 0.5,0.5 (center of tex)
    return vec4(vec3(s), 1);
}
]]

M.step = [[
uniform float u_slider;

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_uv) {
    float d = distance(uv, vec2(0.5));  // distance from 0.5,0.5 (center of tex)
    float s = step(0.25, d);
    float m = mix(d, s, u_slider);
    return vec4(vec3(m), 1);
}
]]

M.circle_sdf = [[
uniform float u_slider;

float circleSDF(vec2 p, float r) {
    return length(p) - r;
}

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_uv) {
    float d = circleSDF(uv - vec2(0.5), u_slider);
    vec3 c = vec3(1.0, 0.6, 0.2);
    if (d < 0.0) {
        c = vec3(0.0, 0.6, 0.6);
    }

    return vec4(c, 1.0);
}
]]

M.circle_sdf_union = [[
uniform float u_slider;

float circleSDF(vec2 p, float r) {
    return length(p) - r;
}

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_uv) {
    float d1 = circleSDF(uv - vec2(0.6), 0.2);
    float d2 = circleSDF(uv - vec2(0.4), 0.2);
    vec3 c = vec3(0);

    float d = min(d1, d2);
    if (d < 0) {
        c.r = step(0, d1);
        c.g = step(0, d2);

        if (d1 < 0 && d2 < 0) {
            c.rg = vec2(1);
        }
    }


    return vec4(c, 1.0);
}
]]

M.circle_sdf_union_smin = [[
uniform float u_slider;

// Polynomial smooth min
float smin(float a, float b, float k) {
    float h = max( k-abs(a-b), 0.0 )/k;
    return min( a, b ) - h*h*k*(1.0/4.0);
}

// circle sdf
float circleSDF(vec2 p, float r) {
    return length(p) - r;
}

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_uv) {

    // The SDF for each disk
    float d1 = circleSDF(vec2(0.65) - uv, 0.2);
    float d2 = circleSDF(vec2(0.35) - uv, 0.2);

    // Union of disks
    float k = u_slider/3.0 + 0.001;
    if (k > 1.0) {
        k = 1.0;
    }
    float d = 1. - smoothstep(0., 0.01, smin(d1, d2, k));
    return vec4(vec3(d), 1.0);
}
]]

M.dynamic_sdf_union = [[
uniform float u_time;

// Polynomial smooth min
float smin(float a, float b, float k) {
    float h = max( k-abs(a-b), 0.0 )/k;
    return min( a, b ) - h*h*k*(1.0/4.0);
}

// circle sdf
float circleSDF(vec2 p, float r) {
    return length(p) - r;
}

float trignorm(float v, float start, float end) {
    return start + (v + 1.0) * (end - start) / 2.0;
}

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_uv) {
    float t = u_time;
    vec2 c1 = vec2(trignorm(sin(t), 0.3, 0.4), 0.3);
    vec2 c2 = vec2(trignorm(cos(t), 0.6, 0.7), 0.4);
    vec2 c3 = vec2(0.4, trignorm(sin(t), 0.3, 0.5));

    vec2 center[3] = vec2[3](c1, c2, c3);

    float d = 99.;

    for (int i = 0; i < 3; i++) {
        vec2 c = center[i];
        float sdf = circleSDF(uv - c, 0.15);
        //d = min(sdf, d);
        d = smin(sdf, d, 0.2);
    }


    float c = 1 - smoothstep(0.0, 0.01, d);
    return vec4(vec3(c), 1.0);
}
]]

M.rect_sdf = [[
uniform vec2 u_mouse_pos;

float boxSDF(vec2 p, vec2 b) {
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_uv) {
    float d = boxSDF(uv - u_mouse_pos, vec2(0.02, 0.02));

    if (d < 0) {
        return vec4(vec2(uv.x, uv.y), 0.0, 1.0);
    }

    return vec4(1);
}

]]

return M
