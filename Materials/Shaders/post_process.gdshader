shader_type spatial;
// Prevent the quad from being affected by lighting and fog. This also improves performance.
render_mode unshaded, fog_disabled;
uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D screen_texture : hint_screen_texture;
uniform float pixel_scale;
uniform float depth_scale;

void vertex() {
  POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	vec2 screen_chunk = round(SCREEN_UV * pixel_scale) / pixel_scale;
	ALBEDO.rgb = vec3(texture(screen_texture, screen_chunk).rgb);
	ALBEDO.rgb *= texture(depth_texture, screen_chunk).r * depth_scale;
}