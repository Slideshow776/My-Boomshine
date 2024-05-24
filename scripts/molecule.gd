class_name Molecule
extends Node2D

const BALL = preload("res://scenes/ball.tscn")

var _balls = Array()


func init_molecule(types: Array):		
	for i in range(types.size()):		
		var ball = BALL.instantiate()		
		_balls.append(ball)
		add_child(ball)
		
		ball.set_type(types[i])
		ball.is_explodable = false
		ball.is_physics = false
				
		print(ball.get_size())
				
		if i > 0:
			ball.position.x = 25
			#ball.position.x = _balls[i - 1].get_size().x
						
		
		
