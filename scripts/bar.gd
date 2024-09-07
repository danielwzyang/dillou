extends TextureProgressBar

func _ready():
	%value.text = str(value) + "%"
	value = variables.savedata["status"][String(name)]
	tint_progress = lerp(Color("FF776D"), Color("2BFFA3"), get_as_ratio())

func _process(_delta):
	if %value.visible:
		%value.global_position = get_global_mouse_position()
		%value.global_position.x -= 30
		%value.global_position.y -= 30
	if value != variables.savedata["status"][String(name)]:
		value = variables.savedata["status"][String(name)]
		%value.text = str(value) + "%"
		tint_progress = lerp(Color("FF776D"), Color("2BFFA3"), get_as_ratio())

func _on_hover_mouse_entered():
	if not variables.gameover:
		%value.visible = true

func _on_hover_mouse_exited():
	%value.visible = false
