extends Control

func _on_restart_button_pressed() -> void:
	var confirmQuit = $SideButtons/MarginQuit/QuitButton/MarginContainer/ConfirmQuit
	var recuseQuit = $SideButtons/MarginQuit/QuitButton/MarginContainer2/RecuseQuit
	var vslider = $SideButtons/MarginVolume/VolumeButton/VSlider
	confirmQuit.visible = false
	recuseQuit.visible = false
	vslider.visible = false

func _on_pause_button_pressed() -> void:
	pass

func _on_quit_button_pressed() -> void:
	var confirmRest = $SideButtons/MarginRestart/RestartButton/MarginRestartConfirm/ConfirmRestart
	var recuseRest = $SideButtons/MarginRestart/RestartButton/MarginRecuseRestart/RecuseRestart
	var vslider = $SideButtons/MarginVolume/VolumeButton/VSlider
	confirmRest.visible = false
	recuseRest.visible = false
	vslider.visible = false

func _on_volume_button_pressed() -> void:
	var confirmRest = $SideButtons/MarginRestart/RestartButton/MarginRestartConfirm/ConfirmRestart
	var recuseRest = $SideButtons/MarginRestart/RestartButton/MarginRecuseRestart/RecuseRestart
	var confirmQuit = $SideButtons/MarginQuit/QuitButton/MarginContainer/ConfirmQuit
	var recuseQuit = $SideButtons/MarginQuit/QuitButton/MarginContainer2/RecuseQuit
	confirmRest.visible = false
	recuseRest.visible = false
	confirmQuit.visible = false
	recuseQuit.visible = false


func _on_click_on_screen_pressed() -> void:
	pass # Replace with function body.
