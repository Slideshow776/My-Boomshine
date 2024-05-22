class_name Ball
extends CharacterBody2D

const MAX_VELOCITY: int = 200
const MIN_VELOCITY: int = -200

@export var bounciness: float = 1.0

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D


func _ready(): # override
	velocity = _get_random_velocity()
	sprite_2d.modulate = _get_random_dark_color()

func _physics_process(delta: float): # override
	move_and_slide()
	_handle_wall_bounce()


func explode():
	queue_free()
	
	
func _handle_wall_bounce():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if get_slide_collision(i):			
			var normal = collision.get_normal() # Calculate the reflection vector
			velocity = velocity.bounce(normal) * bounciness
			break  # React only to the first collision in this example

func _get_random_dark_color() -> Color:
	var min_value = randf_range(0, .1)  # Minimum value for color component
	var max_value = 0.5  # Maximum value for color component
	var channel = randi() % 3  # Randomly select a color channel: 0 (red), 1 (green), or 2 (blue)

	# Initialize color components with lower values
	var r = min_value
	var g = min_value
	var b = min_value

	# Set the selected color channel to a higher value
	match channel:
		0:  # Red channel
			r = randf_range(0.5, 1.0)
		1:  # Green channel
			g = randf_range(0.5, 1.0)
		2:  # Blue channel
			b = randf_range(0.5, 1.0)

	return Color(r, g, b)

func _get_random_velocity() -> Vector2:
	return Vector2(
		randi_range(MIN_VELOCITY, MAX_VELOCITY),
		randi_range(MIN_VELOCITY, MAX_VELOCITY)
	)
