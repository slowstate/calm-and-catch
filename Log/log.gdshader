shader_type canvas_item;

uniform sampler2D noise1: repeat_enable;
uniform sampler2D noise2: repeat_enable;
uniform vec2 scroll1 = vec2(-0.04, 0.02);
uniform vec2 scroll2 = vec2(-0.05, -0.02);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform float distortion_strength : hint_range(-1.0, 1.0) = 0.2;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	if (UV.y > 0.5) {
		float depth = texture(noise1, UV + scroll1 * TIME).r * texture(noise2, UV + scroll2 * TIME).r;
		vec4 screen_col = texture(TEXTURE, UV + distortion_strength * vec2(depth));
		COLOR = screen_col;
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
