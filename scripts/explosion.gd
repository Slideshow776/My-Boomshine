class_name Explosion
extends Area2D

signal ball_entered
signal explosion_entered

var type = GameManager.Type.PURPLE
var _sprite_opacity = 0.8

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var explosion_sound = $ExplosionSound

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body is Ball and (body as Ball).is_explodable:		
		emit_signal("ball_entered", self, body)
		#print("ball_entered: ", body)
	elif body is Explosion:
		emit_signal("explosion_entered", self, body)
		#print("explosion_entered: ", body)

func set_type(type: GameManager.Type):
	self.type = type
	_set_color(GameManager.get_color(type) )
		

func _set_color(color: Color):
	modulate = color
	modulate.a = _sprite_opacity

func _on_animation_player_animation_finished(anim_name):
	queue_free()
