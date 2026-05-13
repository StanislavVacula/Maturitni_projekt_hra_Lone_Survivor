shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount : hint_range(0.0, 5.0) = 0.0;

void fragment() {
    vec4 screen_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
    vec4 rect_color = COLOR;
    COLOR = mix(screen_color, rect_color, rect_color.a);
}