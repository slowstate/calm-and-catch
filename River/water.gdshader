shader_type canvas_item;

uniform sampler2D noise1: repeat_enable;
uniform sampler2D noise2: repeat_enable;
uniform vec2 scroll1 = vec2(-0.04, 0.02);
uniform vec2 scroll2 = vec2(-0.05, -0.02);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform float distortion_strength : hint_range(-1.0, 1.0) = 0.2;
uniform vec4 tone_color : source_color;
uniform vec4 top_color : source_color;
uniform float light_start : hint_range(0.0, 1.0) = 0.2;
uniform float light_end : hint_range(0.0, 1.0) = 0.35;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	//vec4 noise_value = texture(noise1, UV);
	float depth = textureLod(noise1, UV + scroll1 * TIME, 0.0).r * textureLod(noise2, UV + scroll2 * TIME, 0.0).r * clamp(0.75-SCREEN_UV.y, 0.0, 0.6);
	vec4 screen_col = textureLod(SCREEN_TEXTURE, SCREEN_UV + distortion_strength * vec2(depth), 0.0);
	vec4 top_light = smoothstep(light_start, light_end, depth) * top_color;
	COLOR = screen_col + top_light;
	COLOR.a = 1.0;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
