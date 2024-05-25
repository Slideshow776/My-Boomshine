extends Camera2D

@export var random_strength = 30.0
@export var shake_fade = 5.0

var _prng = RandomNumberGenerator.new()
var _shake_strength = 0.0


func _process(delta):
	if _shake_strength > 0:
		_shake_strength = lerpf(
			_shake_strength,
			0,
			shake_fade * delta
		)
	
	offset = _random_offset()


func apply_shake():
	print("applying shake")
	_shake_strength = random_strength


func _random_offset() -> Vector2:
	return Vector2(
		_prng.randf_range(-_shake_strength, _shake_strength),
		_prng.randf_range(-_shake_strength, _shake_strength)
	)
