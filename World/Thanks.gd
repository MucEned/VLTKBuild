extends Label

export (Array) var textArray
var current_text = 0

func _ready():
	text = textArray[current_text]
	pass # Replace with function body.

func _process(delta):
	text = textArray[current_text]

func _on_Switch_timeout():
	if current_text < 9:
		current_text += 1
	pass # Replace with function body.


func _on_Thanks_visibility_changed():
	current_text = 0;
	pass # Replace with function body.
