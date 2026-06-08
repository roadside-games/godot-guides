shader_type canvas_item;
render_mode unshaded;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float thickness : hint_range(0.0, 20.0, 0.1) = 1.0;
uniform int sample_count : hint_range(4, 64, 4) = 8;     // Higher = smoother but more expensive
uniform bool inner_outline = false;                      // false = outer outline, true = inner outline

// Safe texture sampling - prevents bleeding when using sprite atlases
vec4 safe_tex(sampler2D tex, vec2 uv) {
    if (uv.x < 0.0 || uv.y < 0.0 || uv.x > 1.0 || uv.y > 1.0) {
        return vec4(0.0);
    }
    return texture(tex, uv);
}

// Checks if the current pixel is on an edge that should receive an outline
bool is_outline_edge(vec2 uv, vec2 pixel_size, sampler2D tex) {
    if (sample_count <= 0) {
        return false;
    }
    
    float angle_step = 6.28318530718 / float(sample_count); // 2 * PI
    
    for (int i = 0; i < sample_count; ++i) {
        float angle = float(i) * angle_step;
        vec2 dir = vec2(cos(angle), sin(angle));
        
        vec2 sample_uv = uv + dir * thickness * pixel_size;
        float sample_a = safe_tex(tex, sample_uv).a;
        
        // For outer: look for opaque neighbor when pixel is transparent
        // For inner: look for transparent neighbor when pixel is opaque
        bool found_opposite = (sample_a <= 0.0) == inner_outline;
        if (found_opposite) {
            return true;
        }
    }
    
    return false;
}

void fragment() {
    vec4 sprite = texture(TEXTURE, UV);
    
    // Determine if this pixel should have the outline applied
    bool should_draw_outline = (sprite.a > 0.0) == inner_outline && 
                               is_outline_edge(UV, TEXTURE_PIXEL_SIZE, TEXTURE);
    
    vec3 final_color = sprite.rgb;
    float final_alpha = sprite.a;
    
    if (should_draw_outline) {
        if (inner_outline) {
            // Inner outline: tint the sprite edge
            final_color = mix(sprite.rgb, outline_color.rgb, outline_color.a);
            final_alpha = sprite.a;
        } else {
            // Outer outline: replace with outline color in transparent areas
            final_color = outline_color.rgb;
            final_alpha = max(sprite.a, outline_color.a);
        }
    }
    
    COLOR = vec4(final_color, final_alpha);
}