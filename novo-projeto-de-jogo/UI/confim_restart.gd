extends Button

func _on_pressed() -> void:
	var confirm = $"."
	var recuse = $"../../MarginRecuseRestart/RecuseRestart"
	confirm.visible = not confirm.visible
	recuse.visible = not recuse.visible
