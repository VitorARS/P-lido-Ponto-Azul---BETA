shader_type canvas_item;

uniform bool active = true;

void fragment() {
	vec4 previus_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(1.0, 1.0, 1.0, previus_color.a);
	vec4 new_color = previus_color;
	if (active == true) {
		new_color = white_color;
	}
	COLOR = new_color;
}