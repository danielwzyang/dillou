extends Node

var gameover = false

var savedata = {
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

# saving and loading data
func saveg():
	var savefile = FileAccess.open("user://savefile.save", FileAccess.WRITE)
	savefile.store_var(savedata)

func loadg():
	if FileAccess.file_exists("user://savefile.save"):
		var savefile = FileAccess.open("user://savefile.save", FileAccess.READ)
		var grabbeddata = savefile.get_var()
		for key in savedata.keys():
			if key not in grabbeddata:
				grabbeddata[key] = savedata[key]
			else:
				if savedata[key] is Dictionary:
					for key2 in savedata[key].keys():
						if key2 not in grabbeddata[key].keys():
							grabbeddata[key][key2] = savedata[key][key2]
		savedata = grabbeddata

# loading on start
func _ready():
	loadg()

# saving on quit
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		saveg()
		get_tree().quit()

# grabbing stuff
var holding = false
var itemholding = null
var holdingpivot = Vector2.ZERO
var holdinginipos = Vector2.ZERO
var startingpos = Vector2(960, 980)

# food cycling
var mouthopen = false
var foods = {
	"apple": {
		"sprite": "res://sprites/apple.png",
		"values": {
			"hunger": 5,
			"happiness": 5,
		},
		"crumbcolor": Color("#ffea91"), 
		"price": 3
	},
	"steak": {
		"sprite": "res://sprites/steak.png",
		"values": {
			"hunger": 25,
			"happiness": 10,
		},
		"crumbcolor": Color("#5d3013"),
		"price": 15
	},
	"candy": {
		"sprite": "res://sprites/candy.png",
		"values": {
			"happiness": 5,
		},
		"crumbcolor": Color("#eabfff"),
		"price": 2
	}
}
var foodindex = 0

# cycling functions
func cycleright(arr, index):
	if index != len(arr.keys()) - 1:
		index += 1
	else:
		index = 0
	return index

func cycleleft(arr, index):
	if index != 0:
		index -= 1
	else:
		index = len(arr.keys()) - 1
	return index
