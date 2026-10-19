shader_type canvas_item;

uniform bool enabled;

void fragment() {
	if (!enabled) {
		discard;
	}
	
	vec2 from_center = UV - 0.5;
	float val = mix(0.7, 0.0, (1.0 - from_center.x * from_center.x) * (1.0 - from_center.y * from_center.y));
	COLOR = vec4(1.0, 0.0, 0.0, val);
}
