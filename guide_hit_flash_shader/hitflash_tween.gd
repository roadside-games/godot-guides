extends Sprite2D

# ===================================================
# VARIABLES
# ===================================================
@export_category("Flash Color Settings")
@export var flash_color_start: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var flash_color_end: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var flash_color_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var flash_color_ease_type: Tween.EaseType = Tween.EASE_OUT

@export_category("Flash Amount Settings")
@export var flash_amount_start: float = 0.0
@export var flash_amount_end: float = 1.0
@export var flash_amount_tween_type: Tween.TransitionType = Tween.TRANS_SINE
@export var flash_amount_ease_type: Tween.EaseType = Tween.EASE_OUT

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
	_tween.parallel().tween_method(_shader_value_flash_color, flash_color_start, flash_color_end, duration_in).set_trans(flash_color_tween_type).set_ease(flash_color_ease_type)
	_tween.parallel().tween_method(_shader_value_flash_amount, flash_amount_start, flash_amount_end, duration_in).set_trans(flash_amount_tween_type).set_ease(flash_amount_ease_type)
	_tween.tween_callback(fade_out)
	_tween.play()

func fade_out() -> void:
	await get_tree().create_timer(await_time).timeout
	_apply_shader_end()
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.parallel().tween_method(_shader_value_flash_color, flash_color_end, flash_color_start, duration_out).set_trans(flash_color_tween_type).set_ease(flash_color_ease_type)
	_tween.parallel().tween_method(_shader_value_flash_amount, flash_amount_end, flash_amount_start, duration_out).set_trans(flash_amount_tween_type).set_ease(flash_amount_ease_type)
	_tween.play()

# ===================================================
# SET SHADER VALUES
# ===================================================
func _apply_shader_start() -> void:
	material.set_shader_parameter("flash_color", flash_color_start)
	material.set_shader_parameter("flash_amount", flash_amount_start)

func _apply_shader_end() -> void:
	material.set_shader_parameter("flash_color", flash_color_end)
	material.set_shader_parameter("flash_amount", flash_amount_end)

func _shader_value_flash_color(value: Color) -> void:
	material.set_shader_parameter("flash_color", value)

func _shader_value_flash_amount(value: float) -> void:
	material.set_shader_parameter("flash_amount", value)
