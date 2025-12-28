// from https://github.com/hyprwm/Hyprland/issues/1140#issuecomment-1546245134
// modified to work on 3.00 ES

#version 300 es

precision mediump float;
in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 outCol;

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);

    outCol = vec4(
        pixColor[0] * 0.299 + pixColor[1] * 0.587 + pixColor[2] * 0.114,
        pixColor[0] * 0.299 + pixColor[1] * 0.587 + pixColor[2] * 0.114,
        pixColor[0] * 0.299 + pixColor[1] * 0.587 + pixColor[2] * 0.114,
        pixColor[3]
    );
}
