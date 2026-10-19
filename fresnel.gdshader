shader_type spatial;
render_mode unshaded;

uniform float bias;
uniform float gain;
uniform vec3 color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float value = 1.0 - dot(NORMAL, VIEW);
	ALBEDO = color;
	ALPHA = clamp((value - bias) / gain, 0.0, 1.0);
}
