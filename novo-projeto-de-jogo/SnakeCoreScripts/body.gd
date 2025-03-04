extends Node2D

var body_positions: Array = []
var body_positions_P2: Array = []

var block_size = 32

func get_block_size():
	return block_size

func reset_body():
	body_positions.clear()
	body_positions_P2.clear()

func get_head_pos(player: int = 1):
	if player == 1:
		if body_positions.size() > 0:
			var temp:Vector2i = body_positions[0]
			return temp
		else:
			print("O array está vazio!")
	if player == 2:
		if body_positions_P2.size() > 0:
			var temp:Vector2i = body_positions_P2[0]
			return temp
		else:
			print("O array está vazio em P2!")

func get_snake_size(player: int = 1):
	if player == 1:
		return int(body_positions.size())
	if player == 2:
		return int(body_positions_P2.size())

func get_body_positions(player: int = 1):
	if player == 1:
		var temp:Array = body_positions
		return temp
	if player == 2:
		var temp:Array = body_positions_P2
		return temp

func set_block_size(size): 
	block_size = size

func set_head_pos(pos: Vector2i, player:int = 1):
	if player == 1:
		body_positions[0] = pos
	if player == 2:
		body_positions_P2[0] = pos

func start_body(head_pos: Vector2i, player:int = 1):
	if player == 1:
		for i in range(0, 4, +1):
			var temp_x: int = head_pos.x - (block_size * i)
			var temp_y: int = head_pos.y
			var temp_pos: Vector2i = Vector2i(temp_x, temp_y)
			body_positions.insert(i, temp_pos)
	if player == 2:
		for i in range(0, 4, +1):
			var temp_x: int = head_pos.x + (block_size * i)
			var temp_y: int = head_pos.y
			var temp_pos: Vector2i = Vector2i(temp_x, temp_y)
			body_positions_P2.insert(i, temp_pos)
			
	print(body_positions , "player 1")
	print(body_positions_P2 , "player 2")

func update_head(new_head_pos: Vector2i, direction: Vector2i, player: int = 1):
	new_head_pos = new_head_pos + direction * block_size
	if player == 1:
		body_positions.insert(0, Vector2i(new_head_pos))  # Adiciona a nova posição da cabeça
	if player == 2:
		body_positions_P2.insert(0, Vector2i(new_head_pos))

func update_body(body, player:int = 1):
	var bodypositions = body.get_body_positions(player)
	for i in range(0,bodypositions.size() - 1, -1):
		bodypositions[i] = bodypositions[i - 1]
	bodypositions.pop_back()  # Remove a última posição
	#print(body_positions)
