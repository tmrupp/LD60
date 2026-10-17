shader_type canvas_item;

uniform float limit;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 centered = UV - 0.5;
	float radius = length(centered);
	float angle = atan(centered.y, centered.x) + PI/2.0;
	if (angle < 0.0) {
		1.5*PI + angle;
	}
	
	float range = (sin(2.0 * TIME) + 1.0) * PI;
	
	if (radius > 0.5 || radius < 0.4 || angle < range - 0.1 || angle > range + 0.1) {
		discard;
	}
	COLOR = vec4(1.0, 0.0, 0.0, 1.0);
}
