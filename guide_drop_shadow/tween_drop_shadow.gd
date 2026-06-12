extends Node2D

# ===================================================
# VARIABLES
# ===================================================
@export_category("Shadow Color Settings")
@export var shadow_color_start: Color = Color(0.0, 0.0, 0.0, 0.6)
@export var shadow_color_end: Color = Color(0.0, 0.0, 0.0, 0.0)
@export var shadow_color_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var shadow_color_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Shadow Intensity Settings")
@export var shadow_intensity_start: float = 1.0
@export var shadow_intensity_end: float = 0.0
@export var shadow_intensity_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var shadow_intensity_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Shadow Distance Settings")
@export var shadow_distance_start: float = 10.0
@export var shadow_distance_end: float = 0.0
@export var shadow_distance_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var shadow_distance_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Shadow Angle Settings")
@export var shadow_angle_start: float = 130.0
@export var shadow_angle_end: float = 130.0
@export var shadow_angle_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var shadow_angle_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Shadow Softness Settings")
@export var shadow_softness_start: float = 2.0
@export var shadow_softness_end: float = 0.0
@export var shadow_softness_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var shadow_softness_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Duration Settings")
@export var duration_in: float = 0.5
@export var duration_out: float = 0.8
@export var await_time: float = 1.0

var _tween: Tween

# ===================================================
# INITIALIZATION
# ===================================================
func _ready() -> void:
	_apply_shader_start()
	fade_in()

# ===================================================
# TWEENING IN AND OUT
# ===================================================
func fade_in() -> void:
	_apply_shader_start()
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.parallel().tween_method(_shader_value_shadow_color, shadow_color_start, shadow_color_end, duration_in).set_trans(shadow_color_tween_type).set_ease(shadow_color_ease_type)
	_tween.parallel().tween_method(_shader_value_shadow_intensity, shadow_intensity_start, shadow_intensity_end, duration_in).set_trans(shadow_intensity_tween_type).set_ease(shadow_intensity_ease_type)
	_tween.parallel().tween_method(_shader_value_shadow_distance, shadow_distance_start, shadow_distance_end, duration_in).set_trans(shadow_distance_tween_type).set_ease(shadow_distance_ease_type)
	_tween.parallel().tween_method(_shader_value_shadow_angle, shadow_angle_start, shadow_angle_end, duration_in).set_trans(shadow_angle_tween_type).set_ease(shadow_angle_ease_type)
	_tween.parallel().tween_method(_shader_value_shadow_softness, shadow_softness_start, shadow_softness_end, duration_in).set_trans(shadow_softness_tween_type).set_ease(shadow_softness_ease_type)
	_tween.tween_callback(fade_out)
	_tween.play()

func fade_out() -> void:
	await get_tree().create_timer(await_time).timeout
	_apply_shader_end()
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.parallel().tween_method(_shader_value_shadow_color, shadow_color_end, shadow_color_start, duration_out).set_trans(shadow_color_tween_type).set_ease(shadow_color_ease_type)
	_tween.parallel().tween_method(_shader_value_shadow_intensity, shadow_intensity_end, shadow_intensity_start, duration_out).set_trans(shadow_intensity_tween_type).set_ease(shadow_intensity_ease_type)
	_tween.parallel().tween_method(_shader_value_shadow_distance, shadow_distance_end, shadow_distance_start, duration_out).set_trans(shadow_distance_tween_type).set_ease(shadow_distance_ease_type)
	_tween.parallel().tween_method(_shader_value_shadow_angle, shadow_angle_end, shadow_angle_start, duration_out).set_trans(shadow_angle_tween_type).set_ease(shadow_angle_ease_type)
	_tween.parallel().tween_method(_shader_value_shadow_softness, shadow_softness_end, shadow_softness_start, duration_out).set_trans(shadow_softness_tween_type).set_ease(shadow_softness_ease_type)
	_tween.play()

# ===================================================
# SET SHADER VALUES
# ===================================================
func _apply_shader_start() -> void:
	material.set_shader_parameter("shadow_color", shadow_color_start)
	material.set_shader_parameter("shadow_intensity", shadow_intensity_start)
	material.set_shader_parameter("shadow_distance", shadow_distance_start)
	material.set_shader_parameter("shadow_angle", shadow_angle_start)
	material.set_shader_parameter("shadow_softness", shadow_softness_start)

func _apply_shader_end() -> void:
	material.set_shader_parameter("shadow_color", shadow_color_end)
	material.set_shader_parameter("shadow_intensity", shadow_intensity_end)
	material.set_shader_parameter("shadow_distance", shadow_distance_end)
	material.set_shader_parameter("shadow_angle", shadow_angle_end)
	material.set_shader_parameter("shadow_softness", shadow_softness_end)

func _shader_value_shadow_color(value: Color) -> void:
	material.set_shader_parameter("shadow_color", value)

func _shader_value_shadow_intensity(value: float) -> void:
	material.set_shader_parameter("shadow_intensity", value)

func _shader_value_shadow_distance(value: float) -> void:
	material.set_shader_parameter("shadow_distance", value)

func _shader_value_shadow_angle(value: float) -> void:
	material.set_shader_parameter("shadow_angle", value)

func _shader_value_shadow_softness(value: float) -> void:
	material.set_shader_parameter("shadow_softness", value)
