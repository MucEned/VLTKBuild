extends Label

var Data = ResourceLoader.SaverAndLoader

func _ready():
	var my_weapons = Data.load_player_data().weapons
	for i in my_weapons.size():
		if my_weapons[i] == true:
			visible = true
	pass # Replace with function body.
