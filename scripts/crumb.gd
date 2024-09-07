extends Area2D

var sprite = ["res://sprites/crumb1.png", "res://sprites/crumb2.png", "res://sprites/crumb3.png"][randi_range(0, 2)]
var randmoney = 0

func _ready():
	var foodprice = variables.foods[variables.foods.keys()[variables.foodindex]]["price"]
	randmoney = randi_range(round(foodprice * 1.1), round(foodprice * 1.5))
	%sprite.texture = load(sprite)
	createhitbox()
	rotation_degrees = randi_range(0, 360)
	var randomscale = randf_range(1.25, 1.5)
	scale = Vector2(randomscale, randomscale)

func createhitbox():
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(%sprite.texture.get_image())
	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, %sprite.texture.get_size()), 3)
	
	for poly in polys:
		var hitbox = CollisionPolygon2D.new()
		hitbox.polygon = poly
		hitbox.position.x -= bitmap.get_size().x / 2.0
		hitbox.position.y -= bitmap.get_size().y / 2.0
		add_child(hitbox)

func _on_input_event(_viewport, event, _shape_idx):
	if not variables.gameover and event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		variables.savedata["status"]["health"] += 5
		variables.savedata["status"]["health"] = min(variables.savedata["status"]["health"], 100)
		variables.savedata["money"] += randmoney
		var notif = load("res://scenes/notif.tscn").instantiate()
		notif.update(randmoney)
		notif.global_position = global_position
		get_parent().get_parent().add_child(notif)
		get_parent().get_parent().get_node("counter").update()
		for i in range(len(variables.savedata["crumbs"])):
			if global_position in variables.savedata["crumbs"][i]:
				variables.savedata["crumbs"].pop_at(i)
				break
		get_parent().get_parent().get_node("crumb").playsound("res://sounds/pop" + str(randi_range(1, 2)) + ".mp3")
		queue_free()
