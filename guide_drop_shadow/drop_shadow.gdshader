shader_type canvas_item;

// Shadow Appearance
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.6);
uniform float shadow_intensity : hint_range(0.0, 2.0, 0.01) = 1.0;

// Shadow Position
uniform float shadow_distance : hint_range(0.0, 50.0, 0.5) = 2.0;
uniform float shadow_angle : hint_range(0.0, 360.0) = 130.0;

// Shadow Quality
uniform float shadow_softness : hint_range(0.0, 4.0, 0.1) = 0.0;

void vertex() {
    // === Expand bounds so shadow can render outside the original texture ===
    // Calculate how much extra space we need
    float max_offset = shadow_distance + shadow_softness;
    vec2 padding = vec2(max_offset) * TEXTURE_PIXEL_SIZE;
    
    // Expand the vertex in all directions
    vec2 scale_factor = vec2(1.0) + 2.0 * padding;
    VERTEX *= scale_factor;
    
    // Adjust UVs so the original texture stays centered in the expanded area
    UV = UV * scale_factor - padding;
}

void fragment() {
    vec2 base_uv = UV;
    
    // Calculate shadow offset direction
    float angle_rad = radians(shadow_angle);
    vec2 direction = vec2(cos(angle_rad), sin(angle_rad));
    vec2 shadow_offset = direction * shadow_distance * TEXTURE_PIXEL_SIZE;
    
    // Soft shadow sampling (5-sample cross blur)
    float softness = shadow_softness * TEXTURE_PIXEL_SIZE.x;
    vec4 shadow_sample = vec4(0.0);
    
    shadow_sample += texture(TEXTURE, base_uv - shadow_offset);
    shadow_sample += texture(TEXTURE, base_uv - shadow_offset + vec2( softness, 0.0));
    shadow_sample += texture(TEXTURE, base_uv - shadow_offset + vec2(-softness, 0.0));
    shadow_sample += texture(TEXTURE, base_uv - shadow_offset + vec2(0.0,  softness));
    shadow_sample += texture(TEXTURE, base_uv - shadow_offset + vec2(0.0, -softness));
    shadow_sample /= 5.0;
    
    // Sample the original texture
    vec4 main_color = texture(TEXTURE, base_uv);
    
    // Apply shadow color and intensity
    vec4 shadow = shadow_color * shadow_sample.a * shadow_intensity;
    
    // Final compositing: Shadow behind + main texture on top
    vec3 final_rgb = mix(shadow.rgb, main_color.rgb, main_color.a);
    float final_alpha = max(shadow.a, main_color.a);
    
    COLOR = vec4(final_rgb, final_alpha);
}