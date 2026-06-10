shader_type canvas_item;

// Band appearance
uniform vec3 band_color : source_color = vec3(0.941, 0.655, 0.310);
uniform float band_thickness : hint_range(0.02, 0.5, 0.01) = 0.2;
uniform float band_intensity : hint_range(0.0, 2.0, 0.01) = 1.0;

// Animation
uniform float speed : hint_range(0.14, 1.5, 0.02) = 0.4;
uniform int direction : hint_enum("Right", "Left", "Up", "Down") = 0;
uniform float offset : hint_range(0.0, 1.0, 0.01) = 0.0;   // Phase offset (0-1) to desync multiple instances

// Blending & Polish
uniform int blend_mode : hint_enum("Screen", "Mix", "Additive") = 0; 
// 0 = Screen:    Excellent glowing highlight that preserves dark areas (recommended)
// 1 = Mix:       Blends between original and band color (good for solid tints)
// 2 = Additive:  Brightens the original texture (can overexpose bright areas)
uniform float edge_softness : hint_range(0.0, 0.2, 0.001) = 0.02;

void fragment() {
    vec4 base_texture = texture(TEXTURE, UV);
    
    bool is_vertical = (direction >= 2);
    float direction_sign = ((direction % 2) == 0) ? -1.0 : 1.0;
    
    if (!is_vertical) {
        direction_sign = -direction_sign;
    }
    
    // Progress with offset (key addition)
    float progress = fract(TIME * speed * direction_sign + offset);

    // Band position calculation
    float half_thickness = band_thickness * 0.5;
    float band_center = mix(-half_thickness, 1.0 + half_thickness, progress);
    
    float band_start = band_center - half_thickness;
    float band_end   = band_center + half_thickness;

    // Select UV axis
    float coord = is_vertical ? UV.y : UV.x;

    // Soft edges (anti-aliasing)
    float feather = edge_softness;
    float edge1 = smoothstep(band_start - feather, band_start + feather, coord);
    float edge2 = smoothstep(band_end + feather, band_end - feather, coord);
    float in_band = edge1 * edge2;

    // Band contribution
    vec3 band_contrib = band_color * in_band * band_intensity;

    // Blending
    vec3 final_rgb;
    if (blend_mode == 0) {           // Screen
        final_rgb = 1.0 - (1.0 - base_texture.rgb) * (1.0 - band_contrib);
    } else if (blend_mode == 1) {    // Mix
        final_rgb = mix(base_texture.rgb, band_color, in_band * band_intensity);
    } else if (blend_mode == 2) {    // Additive
        final_rgb = base_texture.rgb + band_contrib;
    }

    COLOR = vec4(final_rgb, base_texture.a);
}