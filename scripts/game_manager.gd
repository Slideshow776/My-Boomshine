extends Node


enum Type {
	PURPLE,
	PINK,
	ORANGE,
	GREEN,	
	YELLOW,
	WHITE,
}

var score: int = 0
var player_got_num_balls: int = 0
var level: int = 1
var level_objective: int = 1
var num_balls: int = 20

func get_color(type: Type):
	match type:
		Type.PURPLE:
			return Color("#8854f3")
		Type.PINK:
			return Color("#ff79ae")
		Type.ORANGE:
			return Color("#ff8c5c")
		Type.GREEN:
			return Color("#63ffba")
		Type.YELLOW:
			return Color("#fff982")
		Type.WHITE:
			return Color("#ffffff")
			
func get_random_type() -> Type:
	var types = [Type.PINK, Type.ORANGE, Type.GREEN, Type.YELLOW]
	return types[randi() % types.size()]

func update(is_level_won: bool, level_score: int):
	player_got_num_balls = 0
	
	if is_level_won:
		score += level_score
		level += 1
		num_balls += 2
		level_objective	= int(ceil(num_balls / 2))
