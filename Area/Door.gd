extends Area2D

export (Resource) var connection = null
export (String, FILE, "*.tscn") var new_area_path = ""
var active = true

func _on_Door_body_entered(Player):
	print("ok")
	if active == true:
		Player.emit_signal("hit_door", self)
		active = false
