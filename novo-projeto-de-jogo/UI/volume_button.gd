extends Button

func _on_volume_button_pressed() -> void:
	var vslider = $VSlider
	vslider.visible = not vslider.visible
