shader_type spatial;
// Prevent the quad from being affected by lighting and fog. This also improves performance.
render_mode unshaded, fog_disabled;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float pixel_scale;
uniform float depth_scale;
uniform float depth_min;
uniform float depth_max;
uniform float depth_floor;

void vertex() {
  POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	float depth = max(depth_floor, texture(depth_texture, SCREEN_UV).r);
	float chunk_size = mix(256, 1, (depth - depth_floor) / (1.0 - depth_floor));
	vec2 screen_chunk = round(SCREEN_UV * pixel_scale) / pixel_scale;
	// depth = texture(depth_texture, screen_chunk).r;
	ALBEDO.rgb = vec3(texture(screen_texture, screen_chunk).rgb);
	ALBEDO.rgb *= max(depth_min, min(depth_max, depth * depth_scale));
}