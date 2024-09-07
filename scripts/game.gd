extends Node2D

func _ready():
	loadcrumbs(variables.savedata["crumbs"])
	get_node("buy").update()

func _process(_delta):
	if variables.holding:
		var newx = get_global_mouse_position().x - variables.holdingpivot.x + variables.holdinginipos.x
		%foods.get_node(variables.itemholding).position.x = newx
		var newy = get_global_mouse_position().y - variables.holdingpivot.y + variables.holdinginipos.y
		%foods.get_node(variables.itemholding).position.y = newy
	
	if variables.savedata["status"]["hunger"] <= 0 or variables.savedata["status"]["happiness"] <= 0 or variables.savedata["status"]["health"] <= 0:
		variables.gameover = true
		%gameover.visible = true
		%gameover.get_node("vbox/text").text = "[center]mr dillon died from "
		if variables.savedata["status"]["hunger"] <= 0:
			%gameover.get_node("vbox/text").text += "starvation"
		elif variables.savedata["status"]["happiness"] <= 0:
			%gameover.get_node("vbox/text").text += "depression"
		else:
			%gameover.get_node("vbox/text").text += "unhealthiness"
		%happinesstimer.stop()
		%hungertimer.stop()
		%dillon.get_node("eyes").visible = false
		%dillon.get_node("deadeyes").visible = true

func loadcrumbs(crumbvalues):
	for values in crumbvalues:
		var crumb = preload("res://scenes/crumb.tscn").instantiate()
		crumb.global_position = values[0]
		crumb.modulate = values[1]
		%crumbs.add_child(crumb)

func makecrumbs(food, n):
	for i in range(n):
		var crumb = preload("res://scenes/crumb.tscn").instantiate()
		crumb.modulate = variables.foods[food]["crumbcolor"]
		get_node("dillon").get_node("path/follow").progress_ratio = randf()
		crumb.global_position = get_node("dillon").get_node("path/follow").global_position
		variables.savedata["status"]["health"] -= 5
		variables.savedata["crumbs"].append([crumb.global_position, crumb.modulate])
		%crumbs.add_child(crumb)

func _on_arrowleft_input_event(_viewport, event, _shape_idx):
	if not variables.gameover and event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		variables.foodindex = variables.cycleleft(variables.foods, variables.foodindex)
		get_node("spawner").item = variables.foods.keys()[variables.foodindex]
		get_node("spawner").updatesprite()
		get_node("spawner").updatecount()
		get_node("buy").update()

func _on_arrowright_input_event(_viewport, event, _shape_idx):
	if not variables.gameover and event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		variables.foodindex = variables.cycleright(variables.foods, variables.foodindex)
		get_node("spawner").item = variables.foods.keys()[variables.foodindex]
		get_node("spawner").updatesprite()
		get_node("spawner").updatecount()
		get_node("buy").update()

func _on_hungertimer_timeout():
	if variables.savedata["status"]["hunger"] > 0:
		variables.savedata["status"]["hunger"] -= 1

func _on_happinesstimer_timeout():
	if variables.savedata["status"]["happiness"] > 0:
		variables.savedata["status"]["happiness"] -= 1

func _on_play_again_pressed():
	variables.savedata = {
		"inventory": {
			"apple": 5,
			"steak": 0,
			"candy": 0
		},
		"status": {
			"hunger": 75,
			"happiness": 75,
			"health": 100
		},
		"crumbs": [],
		"money": 0
	}
	variables.gameover = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")
