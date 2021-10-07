extends Node2D

var Ki = ResourceLoader.Ki

func _ready():
	pass

func _on_Timer_timeout():
	Ki.init_ki()
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	pass # Replace with function body.
