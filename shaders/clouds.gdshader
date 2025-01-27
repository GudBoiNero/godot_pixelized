shader_type spatial;
uniform sampler2D noise;
uniform sampler2D bump : hint_normal;
uniform float threshold : hint_range(0.0, 1.0) = 0.5;
uniform float speed : hint_range(0.0, 16.0) = 1.0;
uniform float speed2 : hint_range(0.0, 16.0) = 0.1;
uniform float distortion_value : hint_range(0.0, 16.0) = 1.0;
uniform vec2 uv_scale = vec2(1.0, 1.0);
uniform vec2 uv_detail_scale = vec2(0.5, 0.5);
varying vec2 uv_normal;

void vertex()
{
	uv_normal = (UV * uv_detail_scale) + TIME * speed2;
	UV = (UV * uv_scale) + TIME * speed;
}

void fragment(){
	vec3 distortion = texture(bump, uv_normal).rgb * distortion_value;
ALPHA = texture(noise, UV + distortion.xy).r;
	ALPHA_SCISSOR_THRESHOLD = threshold;
}