extends Button

func _on_recuse_restart_pressed() -> void:
	var confirm = $"../../MarginRestartConfirm/ConfirmRestart"
	var recuse = $"."
	confirm.visible = not confirm.visible
	recuse.visible = not recuse.visible
