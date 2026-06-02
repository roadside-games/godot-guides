# Transition Texture Mask

A smooth, customizable screen transition effect for Godot 4 using a texture mask and shader.
<img width="1080" height="1920" alt="maskgif" src="https://github.com/user-attachments/assets/d082af15-c5d1-4305-919c-c4e1bfbc9175" />

## Files

- `transition_texture_mask.gd` - GDScript that controls the tweening
- `transition_texture_mask.gdshader` - The shader that creates the transition effect

## How to Use

### 1. Setup the Scene

1. Add a **CanvasLayer** node to your scene
2. Add a **ColorRect** as a child of the CanvasLayer
3. Set the ColorRect to cover the full screen:
   - `Layout` → `Full Rect` (or set anchors to full stretch)
4. Attach the `transition_texture_mask.gd` script to the ColorRect

### 2. Add the Shader

1. Select the ColorRect
2. In the Inspector, create a new **ShaderMaterial**
3. Assign the `transition_texture_mask.gdshader` to the material
4. Assign your desired **mask texture** to the `Mask Texture` parameter in the shader

### 3. Configure in the Inspector

You can tweak the following categories:

- **Zoom Settings**
- **Center Settings** 
- **Strength Settings**
- **Duration Settings**

### 4. Triggering the Transition

The transition automatically starts after 3 seconds in `_ready()` for demo purposes.  
You can call the transition manually like this:

```gdscript
# To start the "in" transition
$ColorRect.fade_in()

# Or call it from anywhere using a reference
transition_mask.fade_in()
