shader_type spatial;
// Prevent the quad from being affected by lighting and fog. This also improves performance.
render_mode unshaded, fog_disabled;
uniform sampler2D albedo_texture : filter_nearest;
//uniform sampler2D noise_texture : filter_nearest;
uniform float pixel_scale;
//uniform float distort_scale;
//uniform float distort_freq;

void fragment() {
	//vec4 noise = texture(noise_texture, UV * distort_freq);
	//vec2 distortion = noise.rg * distort_scale;
	vec2 uv = UV;
	//uv += distortion
	vec2 uv_chunk = round(uv * pixel_scale) / pixel_scale;
	vec4 pixel = texture(albedo_texture, uv_chunk);
	ALBEDO = pixel.rgb;
	ALPHA = pixel.a;
}