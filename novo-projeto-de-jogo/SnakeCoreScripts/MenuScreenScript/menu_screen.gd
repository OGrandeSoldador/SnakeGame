extends Control

@onready var gameplay = $"../../Gameplay"
@onready var menu = $"."
@onready var gamename = $GameName/SnakeGame
@onready var fadeout = $GameName/FadeOut
@onready var blur = $"../Blur"

func _on_start_pressed() -> void:
	gamename.stop()
	gamename.visible = false
	fadeout.visible = true
	fadeout.play()
	fadeout.animation_finished.connect(_hide_menu)

func _hide_menu():
	blur.visible = false
	menu.visible = false
	gamename.play()
	gamename.visible = true
	fadeout.visible = false
	gameplay.start_game()
