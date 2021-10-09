extends Particles2D

var Data = ResourceLoader.SaverAndLoader
var MainInstances = ResourceLoader.MainInstances

var Ki = ResourceLoader.Ki

var player_on_me = false

export (Vector2) var Checkpoint

func _ready():
	if Data.load_player_data().bell == true:
		visible = true
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed("tele") and player_on_me == true and Data.load_player_data().bell == true:
		MainInstances.Player.global_position = $Position2D.global_position
		Ki.set_ki(int(Ki.Ki_value * 0.5))

func _on_Guide_body_entered(body):
	player_on_me = true
	$Ring.visible = true
	pass # Replace with function body.


func _on_Guide_body_exited(body):
	player_on_me = false
	$Ring.visible = false
	pass # Replace with function body.
