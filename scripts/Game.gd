class_name Game
extends Node2D

const BALL = preload("res://scenes/ball.tscn")
const NUM_BALLS: int = 5

@onready var background = $background
@onready var camera_2d = $Camera2D


func _ready(): # override
	background.modulate = Color.STEEL_BLUE
	
	for i in range(NUM_BALLS):
		_spawn_ball()

func _input(event):	 # override
	#if event.is_action_pressed("my_action"):
		#spawn_explosion()
	if (
			event.is_action_pressed("my_quit") and
			GlobalConfig.IS_DEBUG
	):
		get_tree().quit()

#func spawn_explosion():
	#var explosion = EXPLOSION.instantiate()
	#explosion.position = get_global_mouse_position()
	#add_child(explosion)


func _spawn_ball(position: Vector2 = Vector2()):
	var ball = BALL.instantiate()
	ball.position = _get_random_position()	
	add_to_group("balls", true)
	add_child(ball)

func _get_random_position() -> Vector2:	
	var camera_width = camera_2d.get_zoom() * get_viewport_rect().size.x
	var camera_height = camera_2d.get_zoom() * get_viewport_rect().size.y
	
	return Vector2(
		randf_range(-camera_width.x / 2, camera_width.x / 2),
		randf_range(-camera_width.y / 4, camera_width.y / 4)
	)
