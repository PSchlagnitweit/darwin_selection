shader_type canvas_item;

uniform bool mouse_pressed = false;
uniform int mouse_button_index;
uniform vec2 mouse_position = vec2(0., 0.);
// uniform float fireProbability;
// uniform float treeProbability;
uniform float click_threshold = 1.0;

uniform bool run = false;

uniform float waterProbability;
uniform float waterNeighbourThreshold;

uniform float landProbability;
uniform float landNeighbourThreshold;

uniform float foodProbability;
uniform float foodNeighbourThreshold;

const int LEFT_CLICK = 1;
const int RIGHT_CLICK = 2;
const int MIDDLE_CLICK = 3;

const vec4 food = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 land = vec4(0.0, 1.0, 0.0, 1.0);
const vec4 water = vec4(0.0, 0.0, 1.0, 1.0);

const vec2 top_left_offset = vec2(-1.0, -1.0);
const vec2 top_middle_offset = vec2(0.0, -1.0);
const vec2 top_right_offset = vec2(1.0, -1.0);
const vec2 center_left_offset = vec2(-1.0, 0.0);
const vec2 center_right_offset = vec2(1.0, 0.0);
const vec2 bottom_left_offset = vec2(-1.0, 1.0);
const vec2 bottom_middle_offset = vec2(0.0, 1.0);
const vec2 bottom_right_offset = vec2(1.0, 1.0);

const vec4 epsilon = vec4(0.001);

// https://godotshaders.com/snippet/random-value/
float random (vec2 uv) {
	uv =  sin(uv + TIME);
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}


void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 sz = SCREEN_PIXEL_SIZE;
		
	vec4 cell = texture(TEXTURE, SCREEN_UV);
	if(cell.a < 1.0) {
		cell = land;
	} 
		
	vec4 result = cell;
	
	if(mouse_pressed && length((uv / sz) - mouse_position) < click_threshold) {
		if (mouse_button_index == LEFT_CLICK) {
			result = water;
		} else if(mouse_button_index == RIGHT_CLICK) {
			result = land;
		} else if(mouse_button_index == MIDDLE_CLICK) {
			result = food;
		}
	} else if(run) {
		vec4 neighbours = 
			texture(TEXTURE, SCREEN_UV + top_left_offset * SCREEN_PIXEL_SIZE) +
			texture(TEXTURE, SCREEN_UV + top_middle_offset * SCREEN_PIXEL_SIZE) +
			texture(TEXTURE, SCREEN_UV + top_right_offset * SCREEN_PIXEL_SIZE) +
			texture(TEXTURE, SCREEN_UV + center_left_offset * SCREEN_PIXEL_SIZE) +
			texture(TEXTURE, SCREEN_UV + center_right_offset * SCREEN_PIXEL_SIZE) +
			texture(TEXTURE, SCREEN_UV + bottom_left_offset * SCREEN_PIXEL_SIZE) + 
			texture(TEXTURE, SCREEN_UV + bottom_middle_offset * SCREEN_PIXEL_SIZE) +
			texture(TEXTURE, SCREEN_UV + bottom_right_offset * SCREEN_PIXEL_SIZE);

		if(cell.r > 0.0) {
			// food
			if(neighbours.b >= waterNeighbourThreshold && random(uv) < foodProbability) {
				result = water;
			} 
			// if(neighbours.g >= landNeighbourThreshold && random(uv) < landProbability) {
			// 	result = land;
			// }

		} else if(cell.g > 0.0) {
			// land
			if(neighbours.b >= waterNeighbourThreshold && random(uv) < waterProbability) {
				result = water;
			} 
			else if(neighbours.b >= foodNeighbourThreshold && random(uv) < foodProbability) {
				result = food;
			}
			// else if(neighbours.r >= foodNeighbourThreshold && random(uv) < foodProbability) {
			// 	result = food;
			// }
		} else {
			// water
			if(neighbours.g >= landNeighbourThreshold && random(uv) < landProbability) {
				result = land;
			}
		}
	}
	
	// TODO generation logic
	
//	else if (cell.g > 0.0) {
//
//		// Moore Neighbourhood
////			int neighbourFireCount = 
////				(texture(TEXTURE, SCREEN_UV + top_left_offset * SCREEN_PIXEL_SIZE).r > 0.0 ? 1 : 0) +
////				(texture(TEXTURE, SCREEN_UV + top_middle_offset * SCREEN_PIXEL_SIZE).r > 0.0 ? 1 : 0) +
////				(texture(TEXTURE, SCREEN_UV + top_right_offset * SCREEN_PIXEL_SIZE).r > 0.0 ? 1 : 0) +
////				(texture(TEXTURE, SCREEN_UV + center_left_offset * SCREEN_PIXEL_SIZE).r > 0.0 ? 1 : 0) +
////				(texture(TEXTURE, SCREEN_UV + center_right_offset * SCREEN_PIXEL_SIZE).r > 0.0 ? 1 : 0) +
////				(texture(TEXTURE, SCREEN_UV + bottom_left_offset * SCREEN_PIXEL_SIZE).r > 0.0 ? 1 : 0) +
////				(texture(TEXTURE, SCREEN_UV + bottom_middle_offset * SCREEN_PIXEL_SIZE).r > 0.0 ? 1 : 0) +
////				(texture(TEXTURE, SCREEN_UV + bottom_right_offset * SCREEN_PIXEL_SIZE).r > 0.0 ? 1 : 0);
//		// Von Neumann neighbourhood
//		int neighbourFireCount = 
//			(texture(TEXTURE, SCREEN_UV + top_middle_offset * SCREEN_PIXEL_SIZE).r > 0.0 ? 1 : 0) +
//			(texture(TEXTURE, SCREEN_UV + center_left_offset * SCREEN_PIXEL_SIZE).r > 0.0 ? 1 : 0) +
//			(texture(TEXTURE, SCREEN_UV + center_right_offset * SCREEN_PIXEL_SIZE).r > 0.0 ? 1 : 0) +
//			(texture(TEXTURE, SCREEN_UV + bottom_middle_offset * SCREEN_PIXEL_SIZE).r > 0.0 ? 1 : 0);
//
//		// A cell containing a tree will catch on fire, if at least one neighbor is on fire
//		// A cell containing a tree without a neighbor on fire will catch fire with a probability
//		if(neighbourFireCount > 0) {
//			result = fire;
//		} else if(random(uv) < fireProbability) {
//			result = fire;
//		}		
//	} else if (cell.r > 0.0) {
//		// A cell with a burning tree will become empty
//		result = empty;
//	} else if(random(uv) < treeProbability) {
//		// An empty cell will grow a new tree with a probability
//		result = tree;
//	}

	COLOR = result;	
}