extends Button

func _on_quit_button_pressed() -> void:
	var confirm = $MarginContainer/ConfirmQuit
	var recuse = $MarginContainer2/RecuseQuit
	confirm.visible = not confirm.visible
	recuse.visible = not recuse.visible
