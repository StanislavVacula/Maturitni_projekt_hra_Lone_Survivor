shader_type canvas_item;

uniform float lod: hint_range(0.0, 5.0) = 0.0;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
// Nové proměnné pro červený efekt:
uniform vec4 red_color : source_color = vec4(0.7, 0.1, 0.1, 1.0);
uniform float mix_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 color = textureLod(screen_texture, SCREEN_UV, lod);
    // Tady se přimíchá červená barva k rozmazanému obrazu
    color.rgb = mix(color.rgb, red_color.rgb, mix_amount);
    COLOR = color;
}