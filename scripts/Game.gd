extends Node2D

@onready var background = $background
const BALL = preload("res://scenes/ball.tscn")

func _ready():
	background.modulate = Color.STEEL_BLUE
	
	for i in range(5):
		spawn_ball()

func _input(event):
	if event.is_action_pressed("my_action"):
		print("you clicked the mouse!")
	elif event.is_action_pressed("my_quit") and GlobalConfig.IS_DEBUG:
		get_tree().quit()

func spawn_ball():
	var ball = BALL.instantiate()
	ball.position = get_random_position()	
	add_child(ball)

func get_random_position() -> Vector2:
	return Vector2(
		randi() % int(get_viewport().size.x),
		randi() % int(get_viewport().size.y)
	)
