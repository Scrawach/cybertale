shader_type canvas_item;
render_mode blend_mix;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float gray = clamp((tex.r + tex.g + tex.b) * 0.3333f, 0.0, 1.0);
	float step_val = step(0.75, 1.0 - gray) / 2.0;
	vec3 color = vec3(step_val);
	COLOR = vec4(color, 1.0);
}
