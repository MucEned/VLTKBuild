extends Node2D

func _ready():
	pass # Replace with function body.

# warning-ignore-all:unused_argument
func _on_Area2D_body_entered(body):
	$Label.visible = true
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	$Label.visible = false
	pass # Replace with function body.
