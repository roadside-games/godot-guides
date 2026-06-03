# Vignette Shader

A smooth, customizable screen vignette effect for Godot 4 using a shader on a ColorRect.

## Files

- `vignette_tween.gd` - GDScript that controls the tweening
- `vignette.gdshader` - The shader that creates the vignette

## How to Use

### 1. Setup the Scene

1. Add a **CanvasLayer** node to your scene
2. Add a **ColorRect** as a child of the CanvasLayer
3. Set the ColorRect to cover the full screen:
   - `Layout` → `Full Rect` (or set anchors to full stretch)
4. Attach the `vignette_tween.gd` script to the ColorRect

### 2. Add the Shader

1. Select the ColorRect
2. In the Inspector, create a new **ShaderMaterial**
3. Assign the `vignette.gdshader` to the material

### 3. Configure in the Inspector

You can tweak the following categories:

- **Radius Settings**
- **Softness Settings**
- **Color Settings**