class_name OutlineTween
extends Sprite2D

# ===================================================
# VARIABLES
# ===================================================
@export_category("Outline Color Settings")
@export var outline_color_start: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var outline_color_end: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var outline_color_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var outline_color_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Thickness Settings")
@export var thickness_start: float = 5.0
@export var thickness_end: float = 5.0
@export var thickness_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var thickness_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Sample Count Settings")
@export var sample_count_start: float = 4.0
@export var sample_count_end: float = 4.0
@export var sample_count_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var sample_count_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Inner Outline Settings")
@export var inner_outline_start: bool = false
@export var inner_outline_end: bool = false

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
	_tween.parallel().tween_method(_shader_value_outline_color, outline_color_start, outline_color_end, duration_in).set_trans(outline_color_tween_type).set_ease(outline_color_ease_type)
	_tween.parallel().tween_method(_shader_value_thickness, thickness_start, thickness_end, duration_in).set_trans(thickness_tween_type).set_ease(thickness_ease_type)
	_tween.parallel().tween_method(_shader_value_sample_count, sample_count_start, sample_count_end, duration_in).set_trans(sample_count_tween_type).set_ease(sample_count_ease_type)
	_tween.tween_callback(fade_out)
	_tween.play()

func fade_out() -> void:
	await get_tree().create_timer(await_time).timeout
	_apply_shader_end()
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.parallel().tween_method(_shader_value_outline_color, outline_color_end, outline_color_start, duration_out).set_trans(outline_color_tween_type).set_ease(outline_color_ease_type)
	_tween.parallel().tween_method(_shader_value_thickness, thickness_end, thickness_start, duration_out).set_trans(thickness_tween_type).set_ease(thickness_ease_type)
	_tween.parallel().tween_method(_shader_value_sample_count, sample_count_end, sample_count_start, duration_out).set_trans(sample_count_tween_type).set_ease(sample_count_ease_type)
	_tween.play()

# ===================================================
# SET SHADER VALUES
# ===================================================
func _apply_shader_start() -> void:
	material.set_shader_parameter("outline_color", outline_color_start)
	material.set_shader_parameter("thickness", thickness_start)
	material.set_shader_parameter("sample_count", int(sample_count_start))
	material.set_shader_parameter("inner_outline", inner_outline_start)

func _apply_shader_end() -> void:
	material.set_shader_parameter("outline_color", outline_color_end)
	material.set_shader_parameter("thickness", thickness_end)
	material.set_shader_parameter("sample_count", int(sample_count_end))
	material.set_shader_parameter("inner_outline", inner_outline_end)

func _shader_value_outline_color(value: Color) -> void:
	material.set_shader_parameter("outline_color", value)

func _shader_value_thickness(value: float) -> void:
	material.set_shader_parameter("thickness", value)

func _shader_value_sample_count(value: float) -> void:
	material.set_shader_parameter("sample_count", int(value))
