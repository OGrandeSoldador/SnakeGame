extends Area2D

@onready var body = $"../SnakeCore/Body"
@onready var map = $"../Mapa_1"
@onready var apple_sprite: Sprite2D = $Apple_Sprite
@onready var apple_coll: CollisionShape2D = $Apple_Coll
@onready var gameplay = $".."
@onready var apple_timer: Timer = $TimeToCollect

var combo_count: int = 0  
var points_current: int = 5
var total_points_current: float = 0
var start:bool

func get_total_points():
	return total_points_current

func get_apple_col_pos():
	return Vector2i(apple_sprite.position)

func set_apple_col_pos(pos: Vector2i):
	apple_coll.set_position(pos)

func generate_apple_pos(valid_pos: Vector2i):
	set_apple_col_pos(valid_pos)
	draw_apple(valid_pos)
	if start == true:
		combo_count = combo_count + 1
	if start == true and combo_count > 0:
		total_points_current = total_points_current + float(points_apple_collected(points_current))
	points_current = 5

func _on_apple_timer_timeout():
	if  points_current> 0:
		points_current -= 1  # Diminui os pontos em 1 a cada segundo
	if points_current == 0:
		combo_count = 0

func start_apple_timer():
	apple_timer.timeout.connect(_on_apple_timer_timeout)
	apple_timer.start()
	points_current = 5

func draw_apple(pos: Vector2):
	apple_sprite.set_position(pos)
	print(pos)

func random_pos() -> Vector2i:
	randomize()
	var x = randi() % 31 * 32
	var y = randi() % 19 * 32
	return Vector2i(x, y)

func valid_item_pos(bodys, maps):
	var _is_valid = false
	var new_item_pos: Vector2i = random_pos()
	
	while maps.walls_pos.has(new_item_pos) or bodys.get_body_positions().has(new_item_pos):
		print("posicao invalida", new_item_pos)
		new_item_pos = random_pos()
		
	return new_item_pos

func start_game(snakespeed):
	total_points_current = 0
	generate_apple_pos(valid_item_pos(body, map))
	apple_timer.wait_time = snakespeed * 50.0

func game_over():
	apple_timer.stop()
	combo_count = 0
	start = false

func points_apple_collected(base_points):
	if  combo_count > 0:
		# Calcula o multiplicador com base no número de combos
		var multiplier: float = 1.0  # Começa com multiplicador de 1.0
		if combo_count >= 100:
			multiplier = 4.0  # Mantém o máximo a partir de 100 combos
		elif combo_count >= 50:
			multiplier = 2.0
		elif combo_count >= 40:
			multiplier = 1.8
		elif combo_count >= 30:
			multiplier = 1.4
		elif combo_count >= 20:
			multiplier = 1.2
		elif combo_count >= 10:
			multiplier = 1.1

		var points = base_points * multiplier  # Calcula a pontuação com o multiplicador
		return points
