extends Node

var MainInstances = ResourceLoader.MainInstances

#onready var currentArea = $Area_00

func _ready():
	VisualServer.set_default_clear_color(Color.black)
	MainInstances.Player.connect("hit_door", self, "_on_Player_hit_door")
#
#func change_area(door):
#	var offset = currentArea.position
#	currentArea.queue_free()
#	var NewArea = load(door.new_area_path)
#	var newArea = NewArea.instance()
#	add_child(newArea)
#	var newDoor = get_door_with_connection(door, door.connection)
#	var exit_position = newDoor.position - offset
#	newArea.position  = door.position - exit_position

func get_door_with_connection(notDoor, connection):
	var doors = get_tree().get_nodes_in_group("Door")
	for door in doors:
		if door.connection == connection and door != notDoor:
			return door
	return null

func _on_Player_hit_door(door):
	call_deferred("change_area", door)


func _on_Key_tree_exited():
	$Game/Thanks.visible = true
	pass # Replace with function body.
