extends Node2D

var fading = false

func update(x):
	%text.text = "[right]+" + str(x)

func _on_life_timer_timeout():
	fading = true
	%fade.start()

func _process(_delta):
	if fading:
		modulate.a = %fade.get_time_left()
		if %fade.get_time_left() == 0:
			queue_free()
