extends Area2D

var item = "apple"

func _ready():
	item = variables.foods.keys()[variables.foodindex]
	updatesprite()
	createhitbox()
	updatecount()

func updatecount():
	%count.text = "[center]x" + str(variables.savedata["inventory"][item])

func updatesprite():
	%sprite.texture = load(variables.foods[item]["sprite"])
	for i in range(2, get_child_count()):
		get_child(i).queue_free()
	createhitbox()

# this creates the hitbox so food can be dynamic
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
	if not variables.gameover and event is InputEventMouseButton and event.button_index == 1 and event.pressed and get_parent().get_node("foods").get_child_count() == 0:
		if variables.savedata["inventory"][item] > 0:
			var food = load("res://scenes/food.tscn").instantiate()
			food.name = StringName(item)
			food.get_node("sprite").texture = load(variables.foods[item]["sprite"])
			food.position = variables.startingpos
			food.scale = scale
			variables.holding = true
			variables.itemholding = item
			variables.holdingpivot = get_global_mouse_position()
			variables.holdinginipos = global_position
			get_parent().get_node("foods").add_child(food)
