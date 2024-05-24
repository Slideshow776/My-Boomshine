class_name Ball
extends CharacterBody2D


signal state_changed(previous, new)

enum Type {
	RED,
	GREEN,
	BLUE,
}

enum MovementState {
	STRAIGHT,
	CLOCKWISE,
	COUNTERCLOCKWISE,
}

const _MAX_VELOCITY: int = 700
const _MIN_VELOCITY: int = -_MAX_VELOCITY

@export var bounciness: float = 1.0
@export var direction_change_angle: float = deg_to_rad(0)  # Change this value to adjust the curve amount
@export var direction_change_iteration = 0.01
@export var direction_change_max_angle = 1.0

var type = _get_random_type()
var colour = _get_color(type)

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

func _ready(): # override
	velocity = _get_random_velocity()
	sprite_2d.modulate = colour

func _physics_process(delta: float): # override
	move_and_slide()
	_handle_wall_bounce()
	_handle_direction_change(delta)
	

func explode():
	queue_free()
	
func _handle_direction_change(delta: float):
	direction_change_angle = clamp(
		direction_change_angle + randf_range(-direction_change_iteration, direction_change_iteration),
		 -direction_change_max_angle,
		 direction_change_max_angle
	)
	velocity = velocity.rotated(direction_change_angle * delta)
	
func _handle_wall_bounce():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if get_slide_collision(i):			
			var normal = collision.get_normal() # Calculate the reflection vector
			velocity = velocity.bounce(normal) * bounciness
			break  # React only to the first collision in this example

func _get_color(type: Type) -> Color:
	match type:
		Type.RED:
			return Color.RED
		Type.GREEN:
			return Color.GREEN
		Type.BLUE: 
			return Color.BLUE
		_:
			return Color.WHITE

func _get_random_type() -> Type:
	var types = [Type.RED, Type.GREEN, Type.BLUE]
	return types[randi() % types.size()]

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
		randi_range(_MIN_VELOCITY, _MAX_VELOCITY),
		randi_range(_MIN_VELOCITY, _MAX_VELOCITY)
	)
