extends Node


enum Type {
	NEUTRAL,
	RED,
	GREEN,
	BLUE,	
}

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
