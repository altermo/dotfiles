#version 300 es

precision mediump float;
in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 outCol;

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);

    outCol = vec4(
        pixColor[0],
        pixColor[1],
        pixColor[2],
        pixColor[3]
    );
}

