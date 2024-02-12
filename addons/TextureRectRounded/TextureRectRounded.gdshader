shader_type canvas_item;

uniform float corner_radius_bl = 32;
uniform float corner_radius_br = 32;
uniform float corner_radius_tl = 32;
uniform float corner_radius_tr = 32;

// Uniforms to control the crop area
uniform float left_bound : hint_range(0.0, 0.4) = 0.0;
uniform float right_bound : hint_range(0.6, 1.0) = 1.0;
uniform float top_bound : hint_range(0.0, 0.4) = 0.0;
uniform float bottom_bound : hint_range(0.6, 1.0) = 1.0;

bool in_circle(vec2 point, vec2 circle_center, float radius) {
    return distance(point, circle_center) <= radius;
}

int get_quadrant(vec2 point) {
	if (point.y >= 0.5) { // bottom
		if (point.x <= 0.5) { // left
			return 0; // bottom left
		} else { // right
			return 1; // bottom right
		}
	} else { // top
		if (point.x <= 0.5) { // left
			return 2; // top right
		} else { // right
			return 3; // bottom right
		}		
	}
}

bool is_inside_per_quadrant(int quadrant, vec2 uv_scaled, vec2 size, float corner_radius, vec4 bounds) {
	switch (quadrant) {
		case 0:
			return uv_scaled.x - bounds[0] > corner_radius || uv_scaled.y < bounds[3] - corner_radius;
		case 1:
			return uv_scaled.x < bounds[1] - corner_radius || uv_scaled.y < bounds[3] - corner_radius;
		case 2:
			return uv_scaled.x - bounds[0] > corner_radius || uv_scaled.y - bounds[2] > corner_radius;
		case 3:
			return uv_scaled.x < bounds[1] - corner_radius || uv_scaled.y - bounds[2] > corner_radius;
	}
}

void fragment() {
    // Normalize texture coordinates
    vec2 uv = UV;

    // Discard pixels outside the specified bounds
    if (uv.x < left_bound || uv.x > right_bound || uv.y < top_bound || uv.y > bottom_bound) {
        discard;
    }

    vec2 size = vec2(1.0 / TEXTURE_PIXEL_SIZE.x, 1.0 / TEXTURE_PIXEL_SIZE.y);
	
	vec4 bounds = vec4(left_bound * size.x, right_bound * size.x, top_bound * size.y, bottom_bound * size.y);
	
    vec2 uv_scaled = vec2(uv.x * size.x, uv.y * size.y);

	float corner_radius[4] = { corner_radius_bl, corner_radius_br, corner_radius_tl, corner_radius_tr };

    // Define corner centers
    vec2 corners[4];
    corners[0] = vec2(corner_radius_bl + bounds[0], bounds[3] - corner_radius_bl); // Bottom left
    corners[1] = vec2(bounds[1] - corner_radius_br, bounds[3] - corner_radius_br); // Bottom right
    corners[2] = vec2(corner_radius_tl + bounds[0], corner_radius_tl + bounds[2]); // Top left
    corners[3] = vec2(bounds[1] - corner_radius_tr, corner_radius_tr + bounds[2]); // Top right

    // Check if the point is inside any of the corner circles
	int quadrant = get_quadrant(uv);
	bool inside_circle = in_circle(uv_scaled, corners[quadrant], corner_radius[quadrant]);

    // Adjust logic to correctly show the texture within the rounded corners
    if (!inside_circle && !is_inside_per_quadrant(quadrant, uv_scaled, size, corner_radius[quadrant], bounds)) { 
        discard;
    }

    COLOR = texture(TEXTURE, UV);
}