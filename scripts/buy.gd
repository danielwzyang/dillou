extends Sprite2D

func _ready():
	%sprite.modulate = Color("#ffffff")

func update():
	var food = variables.foods.keys()[variables.foodindex]
	%food.texture = load(variables.foods[food]["sprite"])
	%name.text = "[center]" + food
	if "happiness" in variables.foods[food]["values"]:
		%happiness.visible = true
		%happiness.text = "[center][img]res://sprites/happiness.png[/img] +" + str(variables.foods[food]["values"]["happiness"])
	else:
		%happiness.visible = false
	if "hunger" in variables.foods[food]["values"]:
		%hunger.visible = true
		%hunger.text = "[center][img]res://sprites/hunger.png[/img] +" + str(variables.foods[food]["values"]["hunger"])
	else:
		%hunger.visible = false
	%price.text = "[center][img]res://sprites/dilloncoin.png[/img]" + str(variables.foods[food]["price"])


func _on_button_input_event(_viewport, event, _shape_idx):
	if not variables.gameover and event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		var food = variables.foods.keys()[variables.foodindex]
		if variables.savedata["money"] >= variables.foods[food]["price"]:
			variables.savedata["money"] -= variables.foods[food]["price"]
			variables.savedata["inventory"][food] += 1
			get_parent().get_node("spawner").updatecount()
			get_parent().get_node("counter").update()
			get_parent().get_node("cash").playsound("res://sounds/buy.mp3")

func _on_button_mouse_entered():
	if not variables.gameover:
		%sprite.modulate = Color("#ececec")

func _on_button_mouse_exited():
	if not variables.gameover:
		%sprite.modulate = Color("#ffffff")
