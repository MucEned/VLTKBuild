extends Node2D

var Ki = ResourceLoader.Ki

func _ready():
	pass # Replace with function body.

func _on_ResetTime_timeout():
	Ki.init_ki()
	get_tree().reload_current_scene()
	pass # Replace with function body.
