extends Control

var _story = [
		"Always a mask",
		"Held in the slim hand whitely",
		"Always she had a mask before her",
		"face-",
		"Truly the wrist",
		"Holding it lightly",
		"Fitted the task:",
		"Sometimes however",
		"Was there a shiver,",
		"Fingertip quiver,",
		"Ever so slightly-",
		"Holding the mask?",
		"For years and years I",
		"wondered",
		"But dared not ask",
		"And then-",
		"I blundered,",
		"Looked behind the mask,",
		"To find",
		"Nothing-",
		"She had no face.",
		"She had become",
		"Merely a hand",
		"Holding a mask",
		"With grace.",
		"'The Mask'  -author unknown",
	]
var _story_index = 0

@onready var sprite_2d = $Sprite2D
@onready var label = $Label
@onready var animation_player = $AnimationPlayer


func progress():
	if _story_index >= _story.size():
		return
		
	label.text = _story[_story_index]
	_story_index += 1
	
	animation_player.play("show_story")
