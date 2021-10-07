extends Control

var bug_catcher = false

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func _on_StartButton_pressed():
# warning-ignore:return_value_discarded
	if not bug_catcher:
		get_tree().change_scene("res://World/World.tscn")
		bug_catcher = true

func _on_LoadButton_pressed():
	pass # Replace with function body.

func _on_QuitButton_pressed():
	get_tree().quit()
