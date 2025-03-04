extends Label

@onready var points = $"../../../Gameplay/Items"
@onready var score = $"."

func update_points_side_menu(point):
	score.text = str(point * 10)
