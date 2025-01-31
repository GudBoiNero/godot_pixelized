shader_type spatial;
render_mode cull_back;

uniform bool billboard_enabled;
uniform sampler2D tex : filter_nearest;
uniform vec3 color : source_color;

void vertex() {
	if (billboard_enabled) {
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	}
}

void fragment() {
	vec4 tex_color = texture(tex, UV);
	ALBEDO = color;
	ALPHA = tex_color.a;
}

void light() {
	// Amount of light on pixel
	float light = clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION;
	DIFFUSE_LIGHT += light;
}