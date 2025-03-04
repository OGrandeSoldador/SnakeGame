extends Node

@onready var gameplay = $"../Gameplay"
@onready var pause_animation = $PauseScreen/Pause
@onready var to_comeback_animation = $"PauseScreen/2sec"
@onready var blur = $Blur/TextureRect
@onready var splashscreen = $SplashScreen
@onready var menu = $MenuScreen
@onready var clickonscreen = $SplashScreen/ClickOnScrenAnimation
@onready var fadeout = $SplashScreen/Fadeout

func play_pause_animation():
	var game_on = gameplay.get_playing_game()
	var pause = gameplay.get_is_pause()
	blur.visible = true
	if game_on == true:
		if pause == true:
			to_comeback_animation.stop()
			to_comeback_animation.visible = false
			pause_animation.visible = true
			pause_animation.play("Pause")
			
		else:
			blur.visible = false
			pause_animation.visible = false
			pause_animation.stop()
			to_comeback_animation.visible = true
			to_comeback_animation.play("2sec")
	else: pass

func _on_gameplay_pause() -> void:
	play_pause_animation()

func _on_sec_animation_finished() -> void:
	to_comeback_animation.visible = false

func _click_on_splash_screen_pressed() -> void:
	clickonscreen.visible = false
	fadeout.visible = true
	fadeout.play("FadeOut")
	fadeout.animation_finished.connect(_on_fadeout_finished)

func _on_fadeout_finished():
	fadeout.visible = false
	splashscreen.visible = false
	menu.visible = true
