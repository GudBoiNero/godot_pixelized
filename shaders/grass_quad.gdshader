shader_type spatial;
render_mode cull_back, depth_draw_opaque, depth_prepass_alpha;

uniform sampler2D tex : filter_nearest;
uniform vec3 color : source_color;

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	VERTEX = vec3(VERTEX.xy, 0.0);
}

void fragment() {
	vec4 tex_color = texture(tex, UV);
	ALBEDO = color;
	ALPHA = tex_color.a;
}

void light() {
	DIFFUSE_LIGHT = vec3(SPECULAR_AMOUNT);
}