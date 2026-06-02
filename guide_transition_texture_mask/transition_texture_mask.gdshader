// =============================================================================
// 
// Script written by Roadside Games
// 
// This script is completely free to use, modify, and distribute.
// No attribution required, though it's always appreciated!
// 
// =============================================================================
shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D mask_texture : source_color, filter_linear;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float zoom : hint_range(0.0, 2.0) = 1.0;
uniform float strength : hint_range(0.0, 1.0) = 0.0;
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
    // Get screen and texture aspects
    vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
    float screen_aspect = screen_size.x / screen_size.y;
    
    vec2 tex_size = vec2(textureSize(mask_texture, 0));
    float tex_aspect = tex_size.x / tex_size.y;
    
    // Branchless aspect correction factor
    float aspect_ratio = screen_aspect / tex_aspect;
    vec2 correction = vec2(1.0, 1.0);
    correction.x = mix(aspect_ratio, 1.0, step(1.0, aspect_ratio));  // If screen wider
    correction.y = mix(1.0 / aspect_ratio, 1.0, step(aspect_ratio, 1.0)); // If texture wider
    
    // Adjust UV (preserves aspect, letterboxed)
    vec2 adjusted_uv = (UV - 0.5) * correction + 0.5;
    
    // Apply zoom
    vec2 zoomed_uv = (adjusted_uv - center) / zoom + center;
    
    // Sample mask using alpha
    vec4 mask = texture(mask_texture, zoomed_uv);
    float mask_alpha = mask.a;
    
    // Black outside, screen inside
    vec4 screen_color = texture(screen_texture, SCREEN_UV);
    vec4 final_color = mix(vec4(0.0, 0.0, 0.0, 1.0), screen_color, mask_alpha);
    
    // Apply progress
    COLOR = final_color;
    COLOR.a = mix(1.0, mask_alpha, strength);
}