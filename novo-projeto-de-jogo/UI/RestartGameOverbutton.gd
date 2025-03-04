extends AnimatedSprite2D


var is_on_button: bool = true
var is_pressed: bool = false
var waiting_for_release: bool = false  # Novo controle
var next_animation: String = ""  # Armazena a animação seguinte

func _ready():
	animation_finished.connect(_on_animation_finished)  # Conecta o sinal

func _on_restart_button_down() -> void:
	play("Click")
	is_on_button = true
	is_pressed = true
	waiting_for_release = false  # Resetar quando pressionado

func _on_restart_button_up() -> void:
	if is_on_button and is_pressed:
		play("Release")
	elif not waiting_for_release:  # Só toca "UnFocus" se não tiver soltado antes
		play("UnFocus")
	is_pressed = false

func _on_restart_mouse_exited() -> void:
	if is_pressed:
		play("Release")  # Toca "Release" primeiro
		next_animation = "UnFocus"  # Guarda "UnFocus" para rodar depois
		waiting_for_release = true  # Marca que a animação já foi tocada
	else:
		play("UnFocus")
	is_on_button = false
	is_pressed = false

func _on_restart_mouse_entered() -> void:
	play("Focus")

func _on_animation_finished():
	if next_animation != "":  # Se houver animação pendente, toca ela
		play(next_animation)
		next_animation = ""  # Reseta o estado
