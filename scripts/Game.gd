class_name Game
extends Node2D


const BALL = preload("res://scenes/ball.tscn")
const MOLECULE = preload("res://scenes/molecule.tscn")
const EXPLOSION = preload("res://scenes/explosion.tscn")

var _is_player_input = false
var _is_win = false
var _score_this_level = 0
var _is_ready_to_flash = true
var _total_explosions_made = 0

@onready var _background = $background
@onready var _background_animation_player = $background/AnimationPlayer
@onready var _camera_2d = $Camera2D
@onready var _red_label = $GUI/Labels/VBoxContainer/Red
@onready var _green_label = $GUI/Labels/VBoxContainer/Green
@onready var _blue_label = $GUI/Labels/VBoxContainer/Blue
@onready var score = $GUI/Labels/Stats/Score
@onready var catches = $GUI/Labels/Stats/Catches
@onready var objective = $GUI/Labels/Stats/Objective
@onready var level = $GUI/Labels/Stats/Level


func _ready():	
	_add_balls()	
	_set_level(GameManager.level)
	_set_objective(GameManager.level_objective)
			
func _process(delta):
	_set_num_ball_labels()
	
	if _is_level_complete():
		_restart_level()
		
	if _is_level_won() and _is_ready_to_flash:
		_is_ready_to_flash = false
		_background_animation_player.play("flash")
		
func _input(event):
	if (
		event.is_action_pressed("my_action") and
		!_is_player_input
	):
		_is_player_input = true
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

func _is_level_won() -> bool:
	if GameManager.level_objective >= _get_balls().size():
		return true
	else:
		return false

func _restart_level():
	_is_player_input = false
	_is_ready_to_flash = true
	GameManager.update(_is_level_won(), _score_this_level)
	_score_this_level = 0
	_total_explosions_made = 0
		
	_remove_all_balls()
	_add_balls()
	
	_set_level(GameManager.level)
	_set_objective(GameManager.level_objective)	
	_set_score(GameManager.score)
	_set_catches(0)

func _remove_all_balls():
	for ball in _get_balls():
		ball.remove_from_group("balls")
		ball.queue_free()

func _add_balls():
	for i in range(GameManager.num_balls):
		_spawn_ball()

func _is_level_complete() -> bool:
	if (
		_is_player_input and 
		_get_explosions().size() == 0
	):
		return true
	else:
		return false

func _set_level(i: int):
	level.text = "Level: "  + str(i)

func _set_objective(i: int):
	objective.text = (
		"Catch " +
		str(GameManager.level_objective) + 
		" of " + 
		str(_get_balls().size()) +
		" balls!"
	)

func _set_catches(i: int):
	catches.text = "You got: " + str(i)

func _set_score(i: int):	
	score.text = "Score: " + str(i)

func _get_balls() -> Array:
	return get_tree().get_nodes_in_group("balls")

func _get_explosions() -> Array:
	return get_tree().get_nodes_in_group("explosions")
	
func _spawn_explosion(position: Vector2 = Vector2.ZERO, type: GameManager.Type = GameManager.Type.WHITE):
	var explosion = EXPLOSION.instantiate()
	explosion.add_to_group("explosions", true)
	add_child(explosion)
	_total_explosions_made += 1
	
	if position == Vector2.ZERO:
		explosion.position = get_global_mouse_position()
	else:
		explosion.position = position
	
	explosion.set_type(type)
	
	var min_scale = 0.25
	var max_scale = 8.0
	var scale = _total_explosions_made * min_scale * 0.3
	explosion.explosion_sound.pitch_scale = clamp(scale, min_scale, max_scale)
		
	explosion.explosion_sound.volume_db = 0 - _total_explosions_made * .04
	print(str(scale) + ", " + str(explosion.explosion_sound.pitch_scale))
	explosion.explosion_sound.play()
	
	#var temp = log(0.25 * _total_explosions_made) / log(10)
	#explosion.explosion_sound.pitch_scale = 4 #0.25 * _total_explosions_made
	#explosion.explosion_sound.play()
	
	for ball in _get_balls():
		ball.z_index = explosion.z_index + 1	
	
	explosion.ball_entered.connect(_create_explosion)	
	explosion.explosion_entered.connect(_create_explosion)	

func _create_explosion(explosion: Explosion, body):
	if body is Ball:
		body.is_explodable = false
		_spawn_explosion(body.position, body.type)
		body.queue_free()
		
		_score_this_level += body.score
		_set_score(GameManager.score + _score_this_level)		
		
		GameManager.player_got_num_balls += 1
		_set_catches(GameManager.player_got_num_balls)
		
		_camera_2d.apply_shake()
		
		#if explosion.type == GameManager.Type.NEUTRAL:
			#return
		#
		#_spawn_molecule(explosion, body)
		#
	#elif body is Explosion:
		#print("body is Explosion")

func _spawn_ball():
	var ball = BALL.instantiate()
	ball.add_to_group("balls", true)
	add_child(ball)	
	
	ball.position = _get_random_position()	
	ball.set_type(GameManager.get_random_type())	

func _spawn_molecule(body_a, body_b):       
	var molecule = MOLECULE.instantiate()   
	molecule.add_to_group("molecules", true)
	add_child(molecule) 
	
	molecule.init_molecule([body_a.type, body_b.type])
	molecule.position = body_a.position	

func _set_num_ball_labels():
	var red = 0
	#var green = 0
	#var blue = 0
	#
	#var balls = get_tree().get_nodes_in_group("balls")
	#for ball in balls:
		#match ball.type:
			#GameManager.Type.RED:
				#red +=1
			#GameManager.Type.GREEN:
				#green +=1
			#GameManager.Type.BLUE:
				#blue +=1
	#_red_label.text = "REDs: " + str(red)
	#_green_label.text = "GREENs: " + str(green)
	#_blue_label.text = "BLUEs: " + str(blue)

func _get_random_position() -> Vector2:	
	var camera_width = _camera_2d.get_zoom() * get_viewport_rect().size.x
	var camera_height = _camera_2d.get_zoom() * get_viewport_rect().size.y
	
	#print("camera width: " + str(camera_width) + ", camera height: " + str(camera_height) + ", camera zoom: " + str(_camera_2d.get_zoom()))
	
	return Vector2(
		randf_range(0, camera_width.x),
		randf_range(0, camera_height.x)
	)
