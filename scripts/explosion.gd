class_name Explosion
extends Area2D

signal ball_entered

enum _State {
	IDLE,
	SCALING_UP,
	SCALING_DOWN,
}

var _state = _State.SCALING_UP
var _target_scale = Vector2(1, 1) # Target scale
var _scale_duration = 0.6 # Duration of scaling animation (in seconds)
var _idle_duration = 0.8
var _time = 0.0
var _queue_free_threshold = 0.001
var _sprite_opacity = 0.8

@onready var sprite_2d = $Sprite2D

func _ready():
	connect("body_entered", _on_body_entered)
	scale = Vector2()

func _on_body_entered(body):
	emit_signal("ball_entered", body)

func _process(delta):
	_time += delta	
	
	match _state:
		_State.IDLE:
			_idle()
		_State.SCALING_UP:
			_scale_up()
		_State.SCALING_DOWN:
			_scale_down()
		

func set_colour(color: Color):
	modulate = color
	modulate.a = _sprite_opacity		
		
func _idle():
	if _time >= _idle_duration:
		setState(_State.SCALING_DOWN)
		
func _scale_up():
	scale = lerp(Vector2.ZERO, _target_scale, _calculate_interpolation_factor())	
	if scale >= _target_scale:
		setState(_State.IDLE)

func _scale_down():	
	scale = lerp(_target_scale, Vector2.ZERO, _calculate_interpolation_factor())
	if scale.distance_to(Vector2.ZERO) <= _queue_free_threshold:
		queue_free()
		
func _calculate_interpolation_factor():
	return clamp(_time / _scale_duration, 0, 1)
	
func setState(state: _State):
	_state = state
	_time = 0.0
