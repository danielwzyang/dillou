extends Area2D

var mouthopen = false

func _on_mouth_area_entered(_area):
	if variables.holding and variables.savedata["status"]["hunger"] < 90:
		mouthopen = true
		updatemouth()

func _on_mouth_area_exited(_area):
	mouthopen = false
	updatemouth()

func _process(_delta):
	updatemouth()
	%head.modulate.a = .25 + variables.savedata["status"]["health"] / 100.0

func updatemouth():
	if mouthopen:
		if %sprite.frame != 3:
			%sprite.frame = 3
		return
	if variables.savedata["status"]["happiness"] > 60:
		if %sprite.frame != 0:
			%sprite.frame = 0
	elif variables.savedata["status"]["happiness"] > 40:
		if %sprite.frame != 1:
			%sprite.frame = 1
	else:
		if %sprite.frame != 2:
			%sprite.frame = 2

func _on_eating_mouse_entered():
	if variables.savedata["status"]["hunger"] < 90:
		variables.mouthopen = true

func _on_eating_mouse_exited():
	variables.mouthopen = false
