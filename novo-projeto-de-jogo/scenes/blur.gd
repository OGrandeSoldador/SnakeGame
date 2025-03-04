extends CanvasLayer

@export var focus_index : int = 5  # Controla a camada de visibilidade via Z-index

func _ready():
	# Ajuste o Z-index do nó que contém o shader
	self.z_index = focus_index
