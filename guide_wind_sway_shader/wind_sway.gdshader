shader_type canvas_item;
render_mode blend_mix;

// Primary wind movement (slow, large-scale swaying)
group_uniforms Wind_Primary;
// Overall speed of the wind animation
uniform float wind_speed : hint_range(0.0, 6.0) = 1.6;
// Base horizontal displacement strength
uniform float sway_horizontal : hint_range(0.0, 0.6) = 0.11;
// Optional vertical lift component (positive = slight upward bias)
uniform float sway_vertical : hint_range(-0.25, 0.25) = 0.06;

// Fast micro-movement layer (flutter / rustle)
group_uniforms Flutter;
// Speed multiplier for the flutter oscillation
uniform float flutter_speed : hint_range(0.0, 7.0) = 1.5;
// Strength of the fast flutter layer
uniform float flutter : hint_range(0.0, 0.35) = 0.02;

// Controls where and how strongly the sway affects the sprite
group_uniforms Height_Mask;
// Portion of the bottom that stays mostly fixed (higher = more anchored at base)
uniform float fixed_base : hint_range(0.0, 0.7) = 0.18;
// Exponent shaping how sway intensity increases toward the top
uniform float height_curve : hint_range(0.1, 3.5) = 1.55;

// Technical / rendering controls
group_uniforms Utilities;
// Expands the geometry to give UV sampling margin during strong wind
uniform float mesh_expand : hint_range(1.0, 3.0) = 1.5;
// Time offset for variation between multiple objects
uniform float phase_offset : hint_range(0.0, 25.0) = 0.0;

varying vec4 v_color;

void vertex() {
    v_color = COLOR;
    // Expand vertices to create padding for UV shifting
    float expand_factor = mesh_expand - 1.0;
    VERTEX *= 1.0 + expand_factor;
}

void fragment() {
    // Convert UV to local 0-1 space within the texture region (supports atlases)
    vec2 local_uv = (UV - REGION_RECT.xy) / REGION_RECT.zw;

    // Build height mask: 0 at the fixed base, 1 at the top
    float raw_height = 1.0 - local_uv.y;
    float height_mask = smoothstep(fixed_base, 1.0, raw_height);
    height_mask = pow(height_mask, height_curve);

    // Time value with per-instance phase variation
    float t = TIME * wind_speed + phase_offset;

    // Primary slow sway + fast flutter layer
    float primary = sin(t) * sway_horizontal;
    float secondary = sin(t * flutter_speed) * cos(t * flutter_speed * 0.65) * flutter;

    // Combine displacements (horizontal is dominant)
    float horizontal_displace = (primary + secondary) * height_mask;
    float vertical_displace = cos(t * 0.9) * sway_vertical * height_mask * 0.7;

    // Center and scale UVs to account for expanded geometry, then apply wind offset
    float expand = mesh_expand;
    vec2 centered = (local_uv - 0.5) * expand + 0.5;

    vec2 swayed_uv = centered;
    swayed_uv.x += horizontal_displace;
    swayed_uv.y += vertical_displace;

    // Discard pixels that sample outside the original texture region
    if (swayed_uv.x < 0.0 || swayed_uv.x > 1.0 ||
        swayed_uv.y < 0.0 || swayed_uv.y > 1.0) {
        discard;
    }

    // Convert back to region space and sample
    vec2 final_uv = swayed_uv * REGION_RECT.zw + REGION_RECT.xy;
    COLOR = texture(TEXTURE, final_uv) * v_color;
}