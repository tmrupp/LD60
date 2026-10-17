shader_type canvas_item;

uniform float limit;
uniform vec4 color_1 : source_color;
uniform vec4 color_2 : source_color;
uniform vec4 color_3 : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 centered = UV - 0.5;
	float radius = length(centered);
	float angle = atan(centered.x, centered.y);
	
	float max_value = ((limit * 2.0 - 1.0) * PI);
	
	//angle < limit - 0.1 || angle > limit + 0.1
	if (radius > 0.5 || radius < 0.4 || angle > max_value) {
		discard;
	}
	
	if (limit > 0.66) {
		COLOR = color_1;
	}
	else if (limit > 0.33) {
		COLOR = color_2;
	}
	else {
		COLOR = color_3;
	}
}
