uniform float u_time;

#define SCALE 10

vec3 rgb(float a, float b, float c) {
    return vec3(a / 255, b / 255, c / 255);
}

vec2 remap(vec2 p) {
    vec2 uv = p * 2 - vec2(1);
    uv.y *= -1;

    uv = uv * SCALE;

    return uv;
}

// y = f(x)
// d = y - f(x)
float plotLine(float y, float fx) {
    float d = abs(y - fx);
    return d;
}

// f(x)
float fx(float x) {
    return 3 * sin(x) / x;
}

// f(x, t)
float fxt(float x, float t) {
    return 4 + 4 * smoothstep(0, 0.7, sin(x + t));
}

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_uv) {
    uv = remap(uv);

    vec3 c = rgb(34, 34, 34);

    float d1 = plotLine(uv.y, fx(uv.x));
    float d2 = plotLine(uv.y, fxt(uv.x, u_time));

    if (d1 < 0.02 * SCALE) {
        c = rgb(154, 119, 49);
    }

    if (d2 < 0.02 * SCALE) {
        c = rgb(160, 255, 192);
    }

    return vec4(c, 1);
}
