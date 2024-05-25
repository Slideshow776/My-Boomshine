extends Node


enum Type {
	NEUTRAL,
	RED,
	GREEN,
	BLUE,	
}

var score: int = 0
var player_got_num_balls: int = 0
var level: int = 1
var level_objective: int = 1
var num_balls: int = 2

func get_color(type: Type):
	match type:
		Type.RED:
			return Color.RED
		Type.GREEN:
			return Color.GREEN
		Type.BLUE:
			return Color.BLUE
		_:
			return Color.WHITE

func get_random_type() -> Type:
	var types = [GameManager.Type.RED, GameManager.Type.GREEN, GameManager.Type.BLUE]
	return types[randi() % types.size()]
