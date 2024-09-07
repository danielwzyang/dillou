extends Node2D

var rots = [0, 5, 0, -5]
var roti = 0

func step():
	global_position.x += 40.5
	if roti != 3:
		roti += 1
	else:
		roti = 0
	rotation_degrees = rots[roti]
	if global_position.x == 1770:
		get_parent().get_node("runbutton").clickable = false
