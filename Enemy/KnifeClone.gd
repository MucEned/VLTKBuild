extends "res://Enemy/Knife.gd"


func _on_Timer_timeout():
	call_deferred("remove_this_object")
	pass # Replace with function body.
