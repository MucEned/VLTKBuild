extends Node

var MainInstances = ResourceLoader.MainInstances

func _ready():
	pass # Replace with function body.

# warning-ignore:unused_argument
func _process(delta):
	if MainInstances.Player != null:
		if 	MainInstances.Player.position.x > 336:
			if Input.is_action_just_pressed("debug_a1"):
				MainInstances.Player.position = $TrapPos.position
			if Input.is_action_just_pressed("debug_a2"):
				MainInstances.Player.position = $RankDPos.position
			if Input.is_action_just_pressed("debug_a3"):
				MainInstances.Player.position = $RankCPos.position
			if Input.is_action_just_pressed("debug_a4"):
				MainInstances.Player.position = $BigTrap.position
			if Input.is_action_just_pressed("debug_a5"):
				MainInstances.Player.position = $RankBPos.position
