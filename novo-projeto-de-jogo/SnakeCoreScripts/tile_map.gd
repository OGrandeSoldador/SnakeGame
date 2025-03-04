extends TileMapLayer

var start_pos = Vector2(0,0)

func _ready() -> void:
	set_cell(start_pos,1,start_pos,0)
	
