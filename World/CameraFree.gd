extends Area2D

const InvicibleGate = preload("res://World/InvincibleGate.tscn")
onready var gatePotition = $GateSpawn

func _ready():
	pass # Replace with function body.

# warning-ignore:unused_argument
func _on_CameraFree_body_entered(body):
	Utils.call_deferred("instance_scene_on_main", InvicibleGate, gatePotition.global_position)
