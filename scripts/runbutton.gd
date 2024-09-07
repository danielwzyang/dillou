extends Area2D

var clickable = true

func _on_input_event(_viewport, event, _shape_idx):
	if clickable and event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		get_parent().get_node("runningdillon").step()
