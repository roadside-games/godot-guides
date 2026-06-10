extends Control

# ===================================================
# VARIABLES
# ===================================================
@export_category("Band Color Settings")
@export var band_color_start: Color = Color(0.941, 0.655, 0.310, 1.0)
@export var band_color_end: Color = Color(0.941, 0.655, 0.310, 0.0)
@export var band_color_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var band_color_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Band Thickness Settings")
@export var band_thickness_start: float = 0.2
@export var band_thickness_end: float = 0.02
@export var band_thickness_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var band_thickness_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Band Intensity Settings")
@export var band_intensity_start: float = 1.0
@export var band_intensity_end: float = 0.0
@export var band_intensity_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var band_intensity_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Speed Settings")
@export var speed_start: float = 0.4
@export var speed_end: float = 0.14
@export var speed_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var speed_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Offset Settings")
@export var offset_start: float = 0.0
@export var offset_end: float = 0.0
@export var offset_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var offset_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Edge Softness Settings")
@export var edge_softness_start: float = 0.02
@export var edge_softness_end: float = 0.02
@export var edge_softness_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var edge_softness_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Direction Settings")
@export var direction_start: int = 0
@export var direction_end: int = 0

@export_category("Blend Mode Settings")
@export var blend_mode_start: int = 0
@export var blend_mode_end: int = 0

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
	_tween.parallel().tween_method(_shader_value_band_color, band_color_start, band_color_end, duration_in).set_trans(band_color_tween_type).set_ease(band_color_ease_type)
	_tween.parallel().tween_method(_shader_value_band_thickness, band_thickness_start, band_thickness_end, duration_in).set_trans(band_thickness_tween_type).set_ease(band_thickness_ease_type)
	_tween.parallel().tween_method(_shader_value_band_intensity, band_intensity_start, band_intensity_end, duration_in).set_trans(band_intensity_tween_type).set_ease(band_intensity_ease_type)
	_tween.parallel().tween_method(_shader_value_speed, speed_start, speed_end, duration_in).set_trans(speed_tween_type).set_ease(speed_ease_type)
	_tween.parallel().tween_method(_shader_value_offset, offset_start, offset_end, duration_in).set_trans(offset_tween_type).set_ease(offset_ease_type)
	_tween.parallel().tween_method(_shader_value_edge_softness, edge_softness_start, edge_softness_end, duration_in).set_trans(edge_softness_tween_type).set_ease(edge_softness_ease_type)
	_tween.tween_callback(fade_out)
	_tween.play()

func fade_out() -> void:
	await get_tree().create_timer(await_time).timeout
	_apply_shader_end()
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.parallel().tween_method(_shader_value_band_color, band_color_end, band_color_start, duration_out).set_trans(band_color_tween_type).set_ease(band_color_ease_type)
	_tween.parallel().tween_method(_shader_value_band_thickness, band_thickness_end, band_thickness_start, duration_out).set_trans(band_thickness_tween_type).set_ease(band_thickness_ease_type)
	_tween.parallel().tween_method(_shader_value_band_intensity, band_intensity_end, band_intensity_start, duration_out).set_trans(band_intensity_tween_type).set_ease(band_intensity_ease_type)
	_tween.parallel().tween_method(_shader_value_speed, speed_end, speed_start, duration_out).set_trans(speed_tween_type).set_ease(speed_ease_type)
	_tween.parallel().tween_method(_shader_value_offset, offset_end, offset_start, duration_out).set_trans(offset_tween_type).set_ease(offset_ease_type)
	_tween.parallel().tween_method(_shader_value_edge_softness, edge_softness_end, edge_softness_start, duration_out).set_trans(edge_softness_tween_type).set_ease(edge_softness_ease_type)
	_tween.play()

# ===================================================
# SET SHADER VALUES
# ===================================================
func _apply_shader_start() -> void:
	material.set_shader_parameter("band_color", Vector3(band_color_start.r, band_color_start.g, band_color_start.b))
	material.set_shader_parameter("band_thickness", band_thickness_start)
	material.set_shader_parameter("band_intensity", band_intensity_start)
	material.set_shader_parameter("speed", speed_start)
	material.set_shader_parameter("offset", offset_start)
	material.set_shader_parameter("edge_softness", edge_softness_start)
	material.set_shader_parameter("direction", direction_start)
	material.set_shader_parameter("blend_mode", blend_mode_start)

func _apply_shader_end() -> void:
	material.set_shader_parameter("band_color", Vector3(band_color_end.r, band_color_end.g, band_color_end.b))
	material.set_shader_parameter("band_thickness", band_thickness_end)
	material.set_shader_parameter("band_intensity", band_intensity_end)
	material.set_shader_parameter("speed", speed_end)
	material.set_shader_parameter("offset", offset_end)
	material.set_shader_parameter("edge_softness", edge_softness_end)
	material.set_shader_parameter("direction", direction_end)
	material.set_shader_parameter("blend_mode", blend_mode_end)

func _shader_value_band_color(value: Color) -> void:
	material.set_shader_parameter("band_color", Vector3(value.r, value.g, value.b))

func _shader_value_band_thickness(value: float) -> void:
	material.set_shader_parameter("band_thickness", value)

func _shader_value_band_intensity(value: float) -> void:
	material.set_shader_parameter("band_intensity", value)

func _shader_value_speed(value: float) -> void:
	material.set_shader_parameter("speed", value)

func _shader_value_offset(value: float) -> void:
	material.set_shader_parameter("offset", value)

func _shader_value_edge_softness(value: float) -> void:
	material.set_shader_parameter("edge_softness", value)
