shader_type spatial;
// Prevent the quad from being affected by lighting and fog. This also improves performance.
render_mode unshaded, fog_disabled;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float pixel_scale;
uniform float depth_scale;
uniform float depth_min;
uniform float depth_max;

void vertex() {
  POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	vec2 screen_chunk = round(SCREEN_UV * pixel_scale) / pixel_scale;
	float depth = texture(depth_texture, screen_chunk).r;
	ALBEDO.rgb = vec3(texture(screen_texture, screen_chunk).rgb);
	ALBEDO.rgb *= min(depth_max, max(depth_min, depth * depth_scale));
}