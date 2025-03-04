class_name Effects
extends Node

var _exception: bool = false  

var exception:
	get:
		return _exception
	set(value):
		_exception = value

func wrap_around(snake_body, max_x: int, max_y: int , player:int = 1):
	var temp_pos = snake_body.get_head_pos(player)
	if temp_pos.x >= max_x:
		temp_pos.x = 0
		snake_body.set_head_pos(Vector2i(temp_pos), player)
	elif temp_pos.x <= - 32:
		temp_pos.x = max_x - 32
		snake_body.set_head_pos(Vector2i(temp_pos), player)
	if temp_pos.y >= max_y:
		temp_pos.y = 0
		snake_body.set_head_pos(Vector2i(temp_pos), player)
	elif temp_pos.y <= -32:
		temp_pos.y = max_y - 32
		snake_body.set_head_pos(Vector2i(temp_pos), player)

func grow_snake(body_positions: Array, amount: int):
	for i in range(0 ,amount, +1):
		body_positions.push_back(Vector2i(body_positions[body_positions.size() -1]))

func own_body_collision(snake_body , player:int = 1):
	var snake = snake_body.get_body_positions(player)
	for i in range(1, snake.size() - 1, +1):
		if snake[0] == snake[i]:
			return emit_signal("game_over")
	return false

func body_collision_players(body):
	var snake = body.get_body_positions()
	var snake2 = body.get_body_positions(2)

	for i in range(1, snake2.size() - 1, +1):
		if snake[0] == snake2[0] and exception == false:
			print("empate 2")
		if snake[0] == snake2[i]:
			return emit_signal("game_over")
	
	for i in range(1, snake.size() - 1, +1):
		if snake[0] == snake2[0] and exception == false:
			print("empate 2")
		if snake2[0] == snake[i]:
			return emit_signal("game_over")

func tunnel_through(body,direction,block_size,player: int =1):
	var bodyPos = body.get_body_positions()
	bodyPos[0] = bodyPos[0] + direction * block_size
	body.set_head_pos(bodyPos[0])

signal game_over()
