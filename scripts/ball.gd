extends CharacterBody2D

@export var bounciness: float = 1.0
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

const MIN_VELOCITY = 50
const MAX_VELOCITY = 200

func _ready() -> void:
	velocity = get_random_velocity()
	sprite_2d.modulate = get_random_dark_color()

func _physics_process(delta: float) -> void:
	# Move the ball and handle collisions
	var remaining_velocity = move_and_slide()

	# Check for collisions and handle bouncing
	var collision_count = get_slide_collision_count()
	for i in range(collision_count):
		var collision = get_slide_collision(i)
		if collision:
			# Calculate the reflection vector
			var normal = collision.get_normal()
			velocity = velocity.bounce(normal) * bounciness
			break  # React only to the first collision in this example


func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("my_action"):
		handle_mouse_click()

func handle_mouse_click() -> void:
	print("Ball clicked! ID:", get_instance_id())
	# Add your custom logic here

func get_random_dark_color() -> Color:
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

func get_random_velocity() -> Vector2:
	return Vector2(
		randi_range(MIN_VELOCITY, MAX_VELOCITY),
		randi_range(MIN_VELOCITY, MAX_VELOCITY)
)
