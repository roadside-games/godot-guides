extends ColorRect

# ===================================================
# VARIABLES
# ===================================================
@export_category("Radius Settings")
@export var radius_start: float = 3.0
@export var radius_end: float = 0.5
@export var radius_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var radius_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Softness Settings")
@export var softness_start: float = 0.5
@export var softness_end: float = 0.5
@export var softness_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var softness_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Color Settings")
@export var color_start: Color = Color(0.0, 0.0, 0.0, 1.0)
@export var color_end: Color = Color(0.0, 0.0, 0.0, 1.0)
@export var color_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var color_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Duration Settings")
@export var duration_in: float = 0.5
@export var duration_out: float = 0.8
@export var await_time: float = 1.0

var _tween: Tween

# ===================================================
# INITIALIZATION
# ===================================================
func _ready() -> void:
	size = get_viewport_rect().size
	z_index = 1000
	mouse_filter = MOUSE_FILTER_IGNORE
	visible = true
	_set_shader_values(radius_start, softness_start, color_start)
	await get_tree().create_timer(3.0).timeout
	fade_in()

# ===================================================
# TWEENING IN AND OUT
# ===================================================
func fade_in() -> void:
	_set_shader_values(radius_start, softness_start, color_start)
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.parallel().tween_method(_shader_value_radius, radius_start, radius_end, duration_in).set_trans(radius_tween_type).set_ease(radius_ease_type)
	_tween.parallel().tween_method(_shader_value_softness, softness_start, softness_end, duration_in).set_trans(softness_tween_type).set_ease(softness_ease_type)
	_tween.parallel().tween_method(_shader_value_color, color_start, color_end, duration_in).set_trans(color_tween_type).set_ease(color_ease_type)
	_tween.tween_callback(fade_out)
	_tween.play()

func fade_out() -> void:
	await get_tree().create_timer(await_time).timeout
	_set_shader_values(radius_end, softness_end, color_end)
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.parallel().tween_method(_shader_value_radius, radius_end, radius_start, duration_out).set_trans(radius_tween_type).set_ease(radius_ease_type)
	_tween.parallel().tween_method(_shader_value_softness, softness_end, softness_start, duration_out).set_trans(softness_tween_type).set_ease(softness_ease_type)
	_tween.parallel().tween_method(_shader_value_color, color_end, color_start, duration_out).set_trans(color_tween_type).set_ease(color_ease_type)
	_tween.play()

# ===================================================
# SET SHADER VALUES
# ===================================================
func _set_shader_values(radius_value: float, softness_value: float, color_value: Color) -> void:
	material.set_shader_parameter("vignette_radius", radius_value)
	material.set_shader_parameter("vignette_softness", softness_value)
	material.set_shader_parameter("vignette_color", color_value)

func _shader_value_radius(value: float) -> void:
	material.set_shader_parameter("vignette_radius", value)

func _shader_value_softness(value: float) -> void:
	material.set_shader_parameter("vignette_softness", value)

func _shader_value_color(value: Color) -> void:
	material.set_shader_parameter("vignette_color", value)
