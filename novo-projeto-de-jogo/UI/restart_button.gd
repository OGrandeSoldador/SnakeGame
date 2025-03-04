extends Button

func _on_pressed_restart_pressed() -> void:
	var confirm = $MarginRestartConfirm/ConfirmRestart
	var recuse = $MarginRecuseRestart/RecuseRestart
	confirm.visible = not confirm.visible
	recuse.visible = not recuse.visible
