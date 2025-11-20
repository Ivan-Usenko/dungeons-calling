shader_type canvas_item;

uniform vec3 tint_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float tint_strength : hint_range(0.0, 1.0, 0.1) = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 tinted = tint_color * COLOR.rgb;
	vec3 color = tinted * tint_strength + COLOR.rgb * (1.0 - tint_strength);
	COLOR = vec4(color, COLOR.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
