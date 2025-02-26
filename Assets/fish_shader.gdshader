shader_type spatial;

uniform float time_scale = 2.0;
uniform float side_to_side = 0.05;
uniform float pivot = 2.0;
uniform float wave = 0.05;
uniform float twist = 0.1;
uniform float mask_black = 0.0;
uniform float mask_white = 1.0;
uniform sampler2D color_texture;

void vertex(){
	//time_scale is a uniform float
	float time = TIME * time_scale;
	//side_to_side is a uniform float
	VERTEX.z += cos(time) * side_to_side;
	float pivot_angle = cos(time) * 0.1 * pivot;
	mat2 rotation_matrix = mat2(vec2(cos(pivot_angle), -sin(pivot_angle)), vec2(sin(pivot_angle), cos(pivot_angle)));
	VERTEX.xz = rotation_matrix * VERTEX.xz;
	float body = (VERTEX.z + 1.0) / 0.4; //for a fish centered at (0, 0) with a length of 2
	//wave is a uniform float
	VERTEX.z += cos(time + body) * wave;
	//twist is a uniform float
	float twist_angle = cos(time + body) * 0.3 * twist;
	mat2 twist_matrix = mat2(vec2(cos(twist_angle), -sin(twist_angle)), vec2(sin(twist_angle), cos(twist_angle)));
	VERTEX.zy = twist_matrix * VERTEX.zy;
	//mask_black and mask_white are uniforms
	float mask = smoothstep(mask_black, mask_white, 1.0 - body);
	//wave motion with mask
	VERTEX.z += cos(time + body) * mask * wave;
	//twist motion with mask
	VERTEX.zy = mix(VERTEX.zy, twist_matrix * VERTEX.zy, mask);
}

void fragment(){
	vec4 final_color = texture(color_texture, UV);
	float factor = 0.2; // Adjust this value for more or less whitening

    // Blend the color towards white
    vec3 brightened = mix(final_color.rgb, vec3(1.0), factor);
	ALBEDO = brightened;
}