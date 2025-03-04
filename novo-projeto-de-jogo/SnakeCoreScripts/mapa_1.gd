extends Area2D

@onready var wall_1: CollisionShape2D = $Wall_1
@onready var wall_2: CollisionShape2D = $Wall_2
@onready var gameplay = $".."

var map1_walls = []
var _walls_grid_pos = []
var _walls_amount: int
var block_size = 32

@export var walls_amount: int:
	get: return _walls_amount
	set(value): 
		_walls_amount = max(0,value)

@export var walls_pos: Array:
	get: return _walls_grid_pos
	set(value):
		_walls_grid_pos = value

func get_walls_amount():
	return _walls_amount

func set_walls_amount(amount: Array):
	_walls_amount = amount.size() 

func get_walls_pos():
	return _walls_grid_pos

func set_walls_pos(list):
	_walls_grid_pos = list

func get_collision_positions(collision_shapes: Array, grid_size: int) -> Array:
	var result = []
	if collision_shapes.size() == 0:
		print("Erro: Nenhuma parede encontrada.")  # Print de erro se não houver paredes.
		return result
	for i in range(collision_shapes.size()):
		var wall = collision_shapes[i]
		if wall == null or wall.shape == null:
			print("Erro: CollisionShape2D ou Shape não encontrados para índice", i)
			continue  # Pula para a próxima parede caso encontre um erro
		var wall_pos = wall.position - (wall.shape.extents * 2) / 2  # Ajuste para o canto superior esquerdo
		var wall_size = wall.shape.extents * 2  # Tamanho total
		for x in range(wall_pos.x, wall_pos.x + wall_size.x, grid_size):
			for y in range(wall_pos.y, wall_pos.y + wall_size.y, grid_size):
				result.append(Vector2i(x, y))  # Armazena a posição gerada
	return result

func start_game():
		wall_1.visible = true
		wall_2.visible = true
		map1_walls = [wall_1,wall_2]
		set_walls_pos(get_collision_positions(map1_walls, block_size))
		print(get_collision_positions(map1_walls, block_size))
