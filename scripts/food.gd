extends Area2D

var snap = false

func _ready():
	createhitbox()

# this is for grabbing stuff
# anything that is grabbable will have this
func _on_input_event(_viewport, event, _shape_idx):
	if not snap and event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		# updates all variables relating to holding
		variables.holding = true
		variables.itemholding = String(name)
		variables.holdingpivot = get_global_mouse_position()
		variables.holdinginipos = global_position
	if not snap and event is InputEventMouseButton and event.button_index == 1 and not event.pressed:
		# resets all variables relating to holding
		variables.holding = false
		variables.itemholding = null
		variables.holdingpivot = Vector2.ZERO
		variables.holdinginipos = Vector2.ZERO
		if variables.mouthopen:
			variables.savedata["inventory"][String(name)] -= 1 
			for key in variables.foods[String(name)]["values"].keys():
				variables.savedata["status"][key] += variables.foods[String(name)]["values"][key]
				variables.savedata["status"][key] = min(variables.savedata["status"][key], 100)
			get_parent().get_parent().get_node("spawner").updatecount()
			if get_parent().get_parent().get_node("crumbs").get_child_count() < 20:
				get_parent().get_parent().makecrumbs(String(name), randi_range(1, 2))
			get_parent().get_parent().get_node("food").playsound("res://sounds/chomp" + str(randi_range(1, 2)) + ".mp3")
			queue_free()
		else:
			snap = true

func _process(delta):
	if snap:
		# snaps to starting pos
		position = position.move_toward(variables.startingpos, delta * 5000)
	if snap and position == variables.startingpos:
		# when it reaches the starting pos it deletes itself
		queue_free()

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
