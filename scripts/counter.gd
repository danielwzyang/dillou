extends Node2D

func _ready():
	update()

func update():
	%value.text = str(variables.savedata["money"])
