extends Resource
class_name Ki

var default_ki = 50
var Ki_value = default_ki setget set_ki

signal ki_changed(value)

func init_ki():
	set_ki(default_ki)

func set_ki(value):
	emit_signal("ki_changed", value)
	Ki_value = value
	return value

func _ready():
	pass # Replace with function body.

func ki_calculate(value):
	if Ki_value >= value:
		emit_signal("ki_changed", set_ki(max(Ki_value - value, 0)))
		return true
	else:
		return false 

func ki_check(value):
	if Ki_value >= value:
		return true
	else:
		return false 
