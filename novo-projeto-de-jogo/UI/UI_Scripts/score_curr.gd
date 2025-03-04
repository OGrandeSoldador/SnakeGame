extends Label

@onready var tempo_label: Label = $"."
@onready var snake_time = $"../../../Gameplay"

func update_time_display(time: Array):
	tempo_label.text = "%02d:%02d.%d" % [time[2], time[1], time[0]]
