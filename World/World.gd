extends Node

var MainInstances = ResourceLoader.MainInstances

func _ready():
	VisualServer.set_default_clear_color(Color.black)
	MainInstances.Player.connect("hit_door", self, "_on_Player_hit_door")

func get_door_with_connection(notDoor, connection):
	var doors = get_tree().get_nodes_in_group("Door")
	for door in doors:
		if door.connection == connection and door != notDoor:
			return door
	return null

func _on_Player_hit_door(door):
	call_deferred("change_area", door)


func _on_Key_tree_exited():
	$Game/Guide/Thanks.visible = true
	pass # Replace with function body.
