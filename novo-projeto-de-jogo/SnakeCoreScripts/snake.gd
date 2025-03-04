extends CharacterBody2D

@onready var gameplay = get_parent()
@onready var snake_body: Node2D = $Body
@onready var items: Node2D = $"../Items"
@onready var effects: Node2D = $Body/Effects
@onready var map: Area2D = $"../Mapa_1"

@onready var time_on_game: Timer = $"../GameTime"
@onready var move_timer: Timer = $"../Player1_Timer/GameVelocity"
@onready var dash_cooldown = $"../Player1_Timer/Dash_Coodown"
@onready var dash_duration_timer = $"../Player1_Timer/Dash_duration"
@onready var dig_duration = $"../Player1_Timer/Dig_Duration"
@onready var dig_cooldown = $"../Player1_Timer/Dig_Cooldown"

@onready var dash_duration_timer_P2 = $"../Player2_Timer/Dash_duration_P2"
@onready var dash_cooldown_P2 = $"../Player2_Timer/Dash_Coodown_P2"
@onready var move_timer_P2 = $"../Player2_Timer/GameVelocity"

@onready var tile_sets = $"../../SnakeTiles"

@onready var head_coll: CollisionShape2D = $Head_Coll
@onready var sprite_head: Sprite2D = $HeadSprite
@onready var sprite: Sprite2D = $Body/BodySprite

@onready var head_coll_P2: CollisionShape2D = $Head_Coll_P2
@onready var sprite_head_p2 = $HeadSprite_P2
@onready var sprite_body_p2 = $Body/BodySprite2

@onready var label_time = $"../../UI_SideMenu/SideMenu/Time"
@onready var label_score = $"../../UI_SideMenu/SideMenu/Score"

var size_screen_x = 1024
var size_screen_y = 640

var snake_speed = 0.3
var block_size: int = 32

var dash_duration = 0.35  # Tempo do dash em segundos
var dash_aceleration = 4.5
var dash_cooldown_time = 2

var is_dashing_P2 = false
var can_dash_P2 = true
var is_dashing = false
var can_dash = true

var underground: Array = []
var store_part: Array = []

var can_dig = true

var snake_sprites = []  # Lista para armazenar os sprites
var snake_sprites_P2 = []

var input = false
var inputP2 = false

var direction: Vector2i = Vector2i.RIGHT
var direction_P2: Vector2i = Vector2i.LEFT

var snake_size: int
var snake_size_P2: int 

var start_coords: Vector2i = Vector2i(5,4)
var start_coords_P2: Vector2i = Vector2i(26,13)
var head_pos = Vector2i()
var amount_to_grow = 1
var game_time_hundredth = 0

var gamemode: int = 2
var start: bool

	### SKILL DASH ###

func start_dash(player: int = 1):
	if player == 1: 
		if not is_dashing and can_dash == true:
			_dash_cooldown_timer()
			is_dashing = true
			dash_duration_timer.start()
			move_timer.wait_time = snake_speed / dash_aceleration
	if player == 2:
		if not is_dashing_P2 and can_dash_P2 == true:
			_on_dash_coodown_P2()
			is_dashing_P2 = true
			dash_duration_timer_P2.start()
			move_timer_P2.wait_time = snake_speed / dash_aceleration

func _on_dash_coodown_P2() -> void:
	can_dash_P2 = false
	dash_cooldown_P2.wait_time = dash_cooldown_time
	dash_cooldown_P2.start()
	if dash_cooldown_P2.is_connected("timeout", _dash_reset_P2):
		dash_cooldown_P2.disconnect("timeout", _dash_reset_P2)

	dash_cooldown_P2.connect("timeout", _dash_reset_P2)

func _dash_cooldown_timer():
	can_dash = false
	dash_cooldown.wait_time = dash_cooldown_time
	dash_cooldown.start()
	if dash_cooldown.is_connected("timeout", _dash_reset):
		dash_cooldown.disconnect("timeout", _dash_reset)

	dash_cooldown.connect("timeout", _dash_reset)

func _on_dash_duration_p_2_timeout() -> void:
	move_timer_P2.wait_time = snake_speed
	is_dashing_P2 = false

func _on_dash_duration_timeout() -> void:
	move_timer.wait_time = snake_speed
	is_dashing = false

func _dash_reset_P2():
	can_dash_P2 = true
	dash_cooldown_P2.stop()

func _dash_reset():
	can_dash = true
	dash_cooldown.stop()

#________________________#

	### SKILL DIG ###

	### SKILL DIG ###

func start_dig(player: int =1):
	var temp = snake_body.get_body_positions()
	effects.tunnel_through(snake_body,direction,block_size)
	underground.push_front(temp[0])
	store_part.push_front(temp[temp.size()-1])
	temp.pop_back()
	

#________________________#

func get_game_time_hundredth():
	return game_time_hundredth

func set_start_pos(start_pos):
	start_pos = start_pos * block_size
	return Vector2i(start_pos)

func set_amount_to_grow(valor):
	amount_to_grow = valor

func get_snake_size():
	return snake_size


func input_player_move():
	if Input.is_action_just_pressed("skill_1_P1"):
		start_dig()

	if Input.is_action_just_pressed("move_right") and direction != Vector2i.LEFT:
		if direction == Vector2i.RIGHT and can_dash == true:
			start_dash() 
	if Input.is_action_just_pressed("move_left") and direction != Vector2i.RIGHT :
		if direction == Vector2i.LEFT and can_dash == true:
			start_dash() 
	if Input.is_action_just_pressed("move_up") and direction != Vector2i.DOWN :
		if direction == Vector2i.UP and can_dash == true:
			start_dash() 
	if Input.is_action_just_pressed("move_down") and direction != Vector2i.UP:
		if direction == Vector2i.DOWN and can_dash == true:
			start_dash() 

	if input == false:
		if Input.is_action_just_pressed("move_right") and direction != Vector2i.LEFT:
			direction = Vector2i.RIGHT
			input = true
		if Input.is_action_just_pressed("move_left") and direction != Vector2i.RIGHT :
			direction = Vector2i.LEFT
			input = true
		if Input.is_action_just_pressed("move_up") and direction != Vector2i.DOWN :
			direction = Vector2i.UP
			input = true
		if Input.is_action_just_pressed("move_down") and direction != Vector2i.UP:
			direction = Vector2i.DOWN
			input = true

func input_player_move_P2():
	if Input.is_action_just_pressed("skill_1_P2"):
		effects.tunnel_through(snake_body,direction,block_size)

	if Input.is_action_just_pressed("move_right_p2") and direction_P2 != Vector2i.LEFT :
		if direction_P2 == Vector2i.RIGHT and can_dash == true:
			start_dash(gamemode)
	if Input.is_action_just_pressed("move_left_p2") and direction_P2 != Vector2i.RIGHT :
		if direction_P2 == Vector2i.LEFT and can_dash == true:
			start_dash(gamemode)
	if Input.is_action_just_pressed("move_up_p2") and direction_P2 != Vector2i.DOWN :
		if direction_P2 == Vector2i.UP and can_dash == true:
			start_dash(gamemode)
	if Input.is_action_just_pressed("move_down_p2") and direction_P2 != Vector2i.UP:
		if direction_P2 == Vector2i.DOWN and can_dash == true:
			start_dash(gamemode)

	if inputP2 == false:
		if Input.is_action_just_pressed("move_right_p2") and direction_P2 != Vector2i.LEFT:
			direction_P2 = Vector2i.RIGHT
			inputP2 = true
		if Input.is_action_just_pressed("move_left_p2") and direction_P2 != Vector2i.RIGHT :
			direction_P2 = Vector2i.LEFT
			inputP2 = true
		if Input.is_action_just_pressed("move_up_p2") and direction_P2 != Vector2i.DOWN :
			direction_P2 = Vector2i.UP
			inputP2 = true
		if Input.is_action_just_pressed("move_down_p2") and direction_P2 != Vector2i.UP:
			direction_P2 = Vector2i.DOWN
			inputP2 = true


func draw_head(head,spritehead):
	if head != null:
		spritehead.position = Vector2i(head)
	else:
		print("sem pos")
		pass

func draw_snake(snakebody,snakesprites, spritebody):
	# Criar sprites suficientes para cada segmento do corpo
	while snakesprites.size() < snakebody.size():
		var new_sprite = Sprite2D.new()
		new_sprite.texture = spritebody.texture
		new_sprite.scale = Vector2(0.5, 0.5)
		new_sprite.z_index = 3
		add_child(new_sprite)
		snakesprites.append(new_sprite)

	# Atualizar a posição de cada sprite
	for i in range(snakebody.size()):
		snakesprites[i].position = snakebody[i]

	# Remover sprites extras caso a cobra diminua
	while snakesprites.size() > snakebody.size():
		var removed_sprite = snakesprites.pop_back()
		removed_sprite.queue_free()

func update_head_coll(headpos, headcoll):
	headcoll.position = headpos

func _counter_game_time():
	game_time_hundredth = game_time_hundredth + 1
	if game_time_hundredth == 10:
		gameplay.time_on_game()
		game_time_hundredth = 0
	else:
		gameplay.time_on_game()


func reset_game():
	game_time_hundredth = 0
	snake_body.reset_body()
	direction = Vector2i.RIGHT
	head_coll.position = Vector2i(-block_size,-block_size)

func start_game(mode: int = 1):
	reset_game()
	snake_body.set_block_size(block_size)
	snake_body.start_body(set_start_pos(start_coords))
	snake_size = snake_body.get_snake_size()
	move_timer.wait_time = snake_speed
	move_timer.timeout.connect(_on_move_timer_timeout)
	time_on_game.timeout.connect(_counter_game_time)
	#tile_sets.initialize_body_types(snake_body.get_body_positions().size(), direction)
	#tile_sets.apply_tile_set(snake_body.get_body_positions())
	if mode == 2:
		snake_body.start_body(set_start_pos(start_coords_P2), mode)
		snake_size = snake_body.get_snake_size(mode)
		move_timer_P2.wait_time = snake_speed
		move_timer_P2.timeout.connect(_on_move_timer_timeout_P2)

	map.start_game()
	items.start_game(snake_speed)
	
	start = true


func _on_move_timer_timeout():
	snake_body.update_head(snake_body.get_head_pos(), direction)
	snake_body.update_body(snake_body)
	effects.body_collision_players(snake_body)
	effects.own_body_collision(snake_body)
	effects.wrap_around(snake_body,size_screen_x,size_screen_y)
	update_head_coll(snake_body.get_head_pos(),head_coll)
	input = false
	
	#tile_sets.find_curves_and_straight(snake_body.get_body_positions(), block_size)
	#tile_sets.update_body_types(snake_body.get_body_positions(), direction)
	#tile_sets.apply_tile_set(snake_body.get_body_positions())

func _on_move_timer_timeout_P2():
	snake_body.update_head(snake_body.get_head_pos(gamemode), direction_P2, gamemode)
	snake_body.update_body(snake_body, gamemode)
	effects.body_collision_players(snake_body)
	effects.own_body_collision(snake_body, gamemode)
	effects.wrap_around(snake_body,size_screen_x,size_screen_y,gamemode)
	update_head_coll(snake_body.get_head_pos(gamemode), head_coll_P2)
	inputP2 = false

func transition_to_start():
	move_timer.start()
	move_timer_P2.start()
	time_on_game.start()
	label_time.visible = true
	label_score.visible = true
	items.start_apple_timer()
	items.start = true


func _process(delta: float) -> void:
	delta = delta
	if gameplay.get_game_over() == false and gameplay.get_playing_game() == true and start == true:
		input_player_move()
		draw_snake(snake_body.get_body_positions(), snake_sprites, sprite)
		draw_head(snake_body.get_head_pos(), sprite_head)
		if gamemode == 2:
			input_player_move_P2()
			draw_snake(snake_body.get_body_positions(gamemode), snake_sprites_P2, sprite_body_p2)
			draw_head(snake_body.get_head_pos(gamemode), sprite_head_p2)
		label_time.update_time_display(gameplay.get_time_on_game())
		label_score.update_points_side_menu(items.get_total_points())


func _on_items_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	items.generate_apple_pos(items.valid_item_pos(snake_body, map))
	items.start = true
	if body_shape_index == 0:
		effects.grow_snake(snake_body.get_body_positions(), gameplay.get_grow_size())
	elif body_shape_index == 1:  # Shape do corpo, por exemplo
		effects.grow_snake(snake_body.get_body_positions(gamemode), gameplay.get_grow_size())
	else:
		print("Outro shape foi atingido!")


func _on_mapa_1_body_collision(body: Node2D) -> void:
	emit_signal("game_over")


signal game_over()
