class_name Gameplay
extends Node2D

@onready var pause_animation = $"../UI_Manager/PauseScreen"
@onready var move_timer: Timer = $Player1_Timer/GameVelocity
@onready var transition_timer = $TransitionPause
@onready var game_time = $GameTime
@onready var trasition_start = $"../UI_Manager/PauseScreen/2sec"

@onready var snake_core = $SnakeCore
@onready var game_over_screen = $"../UI_Manager/GameOverScreen"
@onready var finalscore = $"../UI_Manager/GameOverScreen/FinalScoreTable"
@onready var blur = $"../UI_Manager/Blur"
@onready var items = $Items

@onready var final_score_label = $"../UI_Manager/GameOverScreen/FinalScoreTable/Score"
@onready var score_side_menu = $"../UI_SideMenu/SideMenu/Score"
@onready var label_time = $"../UI_SideMenu/SideMenu/Time"
@onready var label_final_time = $"../UI_Manager/GameOverScreen/FinalScoreTable/Time"


var gamemode: int = 2
var screen_size_x: int = 1024
var screen_size_y: int = 640 
var _grow_size: int = 1
var game_over: bool = false
var is_pause: bool = false
var playing_game: bool = false
var time: Array = [0,0,0,0]


func get_playing_game( ):
	return playing_game

func set_playing_game(valor):
	playing_game = valor

func get_is_pause():
	return is_pause

func get_time_on_game():
	return time

func set_is_pause(valor):
	is_pause = valor

func get_grow_size():
	return _grow_size

func get_game_over():
	return game_over

func set_game_over(valor):
	game_over = valor


func input_pause():
	if Input.is_action_just_pressed("pause_game") or Input.is_action_just_pressed("pause_game_2"):
		pause_timer()

func time_on_game():
	var hundredth = snake_core.get_game_time_hundredth()
	if time[3] < 60:
		time[0] = hundredth
		if time[0] == 10:
			time[1] = time[1] + 1
		if time[1] == 60:
			time[2] = time[2] + 1
			time[1] = 0

		if time[0] == 10:
			time[0] = 0
		if time[2] == 60:
			time[2] = 0
			time[3] = time[3] + 1
	else: 
		game_over = true

func pause_timer():
	is_pause = !is_pause
	emit_signal("pause")
	if is_pause == true:
		game_time.set_paused(true)
		transition_timer.stop()
		move_timer.set_paused(true)
	else:
		transition_to_pause()

func start_game():
	pause_animation.visible = true
	set_is_pause(true)
	set_game_over(false)
	time = [0,0,0,0]
	snake_core.start_game(gamemode)
	visible = true
	set_playing_game(true)
	pause_timer()
	trasition_start.play("2sec")
	trasition_start.visible = true
	trasition_start.animation_finished.connect(_on_sec_animation_finished)

func gameover():
	final_score_label.text = str(int(items.get_total_points() * 10))
	label_final_time.text = "%02d:%02d.%d" % [time[2], time[1], time[0]]
	items.game_over()
	playing_game = false
	set_game_over(true)
	move_timer.stop()
	game_time.stop()
	game_over_screen.gameover_restart(blur, game_over_screen, finalscore)
	label_time.visible = false
	score_side_menu.visible = false


func _process(delta):
	delta = delta
	if playing_game == true:
		input_pause()
	else: 
		pass

func transition_to_pause():
	transition_timer.start()


func _on_pause_button_pressed() -> void:
	if playing_game == true:
		pause_timer()
	else: pass

func _on_transition_pause_timeout() -> void:
	move_timer.set_paused(false)
	game_time.set_paused(false)
	is_pause = false

func _on_snake_core_game_over() -> void:
	gameover()

func _on_sec_start_animation_finished() -> void:
	pass # Replace with function body.

func _on_sec_animation_finished() -> void:
	snake_core.transition_to_start()

signal pause
