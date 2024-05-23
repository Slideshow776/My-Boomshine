class_name Game
extends Node2D

const BALL = preload("res://scenes/ball.tscn")
const EXPLOSION = preload("res://scenes/explosion.tscn")
const NUM_BALLS: int = 40

@onready var _background = $background
@onready var _camera_2d = $Camera2D
@onready var _red_label = $GUI/Labels/VBoxContainer/Red
@onready var _green_label = $GUI/Labels/VBoxContainer/Green
@onready var _blue_label = $GUI/Labels/VBoxContainer/Blue


func _ready(): # override
	_background.modulate = Color.STEEL_BLUE
	
	for i in range(NUM_BALLS):
		_spawn_ball()	
			
func _process(delta):
	_set_num_ball_labels()
		
func _input(event):	 # override
	if event.is_action_pressed("my_action"):
		_spawn_explosion()
	elif (
			event.is_action_pressed("my_quit") and
			GlobalConfig.IS_DEBUG
	):
		get_tree().quit()
	elif (
			event.is_action_pressed("my_restart") and 
			GlobalConfig.IS_DEBUG
	):
		get_tree().reload_current_scene()
#
func _spawn_explosion(position: Vector2 = Vector2.ZERO, colour: Color = Color.WHITE):
	var explosion = EXPLOSION.instantiate()
	
	if position == Vector2.ZERO:
		explosion.position = get_global_mouse_position()
	else:
		explosion.position = position
	
	explosion.set_colour(colour)
	#explosion.modulate = colour
	
	var balls = get_tree().get_nodes_in_group("balls")
	for ball in balls:
		ball.z_index = explosion.z_index + 1	
	
	explosion.ball_entered.connect(_create_explosion)
	
	explosion.add_to_group("explosions", true)
	add_child(explosion)

func _create_explosion(body):
	_spawn_explosion(body.position, body.colour)
	body.queue_free()

func _spawn_ball():
	var ball = BALL.instantiate()
	ball.position = _get_random_position()	
	ball.add_to_group("balls", true)
	add_child(ball)	

func _set_num_ball_labels():
	var red = 0
	var green = 0
	var blue = 0
	
	var balls = get_tree().get_nodes_in_group("balls")
	for ball in balls:
		match ball.type:
			Ball.Type.RED:
				red +=1
			Ball.Type.GREEN:
				green +=1
			Ball.Type.BLUE:
				blue +=1
	_red_label.text = "REDs: " + str(red)
	_green_label.text = "GREENs: " + str(green)
	_blue_label.text = "BLUEs: " + str(blue)

func _get_random_position() -> Vector2:	
	var camera_width = _camera_2d.get_zoom() * get_viewport_rect().size.x
	var camera_height = _camera_2d.get_zoom() * get_viewport_rect().size.y
	
	#print("camera width: " + str(camera_width) + ", camera height: " + str(camera_height))
	
	return Vector2(
		randf_range(-camera_width.x / 2, camera_width.x / 2),
		randf_range(-camera_width.y / 4, camera_width.y / 4)
	)
