extends Button

func _on_pressed() -> void:
	var confirm = $"../../MarginContainer/ConfirmQuit"
	var recuse = $"."
	confirm.visible = not confirm.visible
	recuse.visible = not recuse.visible
