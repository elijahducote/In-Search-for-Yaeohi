shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform int strength: hint_range(1, 512) = 2;

vec4 soft_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
}

void fragment(){
	vec4 textured = textureLod(SCREEN_TEXTURE, SCREEN_UV,0.0);
	vec4 mytex = texture(TEXTURE, UV);
	COLOR = soft_light(textured,mytex);
}