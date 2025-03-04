extends Node

var last_mode = DisplayServer.WINDOW_MODE_WINDOWED
var screen_size = Vector2i(1152,640)

@onready var gameplay = $Gameplay
@onready var credits = $UI_Manager/CreditsLabel
@onready var splash_screen = $UI_Manager/SplashScreen
@onready var pause = $UI_Manager/PauseScreen
@onready var blur = $UI_Manager/Blur/TextureRect
@onready var gameover = $UI_Manager/GameOverScreen
@onready var menu = $UI_Manager/MenuScreen
@onready var items = $Gameplay/Items

func _ready():
	set_screen_mode(screen_size, DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
#	creditsscreen()
	#blur.visible = true
	#pause.visible = false

func creditsscreen():
	credits.visible = true
	var timer = Timer.new()
	timer.wait_time = 3.0
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	credits.visible = false
	splash_screen.visible = true

func set_screen_mode(size: Vector2i, mode):
	if last_mode == mode:
		return
	DisplayServer.window_set_size(size)
	DisplayServer.window_set_mode(mode)
	last_mode = mode

func enable_fullscreen():
	set_screen_mode(screen_size, DisplayServer.WINDOW_MODE_FULLSCREEN)

func enable_borderless():
	set_screen_mode(screen_size, DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func enable_windowed():
	set_screen_mode(screen_size, DisplayServer.WINDOW_MODE_WINDOWED)

func _on_fullscreen_button_pressed() -> void:
	enable_fullscreen()

func _on_borderless_button_pressed() -> void:
	enable_borderless()

func _on_windowed_button_pressed() -> void:
	enable_windowed()


func _on_restart_pressed() -> void:
	gameover.visible = false
	menu.visible = true
	gameplay.visible = false 


func _on_confirm_restart_pressed() -> void:
	if gameplay.get_playing_game() == true and gameplay.get_game_over() == false:
		items.game_over()
		pause.visible = false
		gameplay.snake_core.move_timer.stop()
		gameplay.trasition_start.stop()
		gameplay.set_playing_game(false) 
		gameplay.set_game_over(true)
		gameplay.move_timer.stop()
		gameplay.game_time.stop()
		menu.visible = true
		gameplay.snake_core.reset_game()
		gameplay.visible = false
