extends Label

var Ki = ResourceLoader.Ki
var ki = 0

func _ready():
	ki = Ki.Ki_value
	Ki.connect("ki_changed", self, "_on_ki_changed")
	text = "EP: " + str(ki)
	pass # Replace with function body.

func _on_ki_changed(value):
	ki = value
	text = "EP: " + str(ki)
