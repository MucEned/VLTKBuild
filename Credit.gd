extends Node2D

var hitcount = 10
var MainInstances = ResourceLoader.MainInstances
const HitEffect = preload("res://Effect/HitEffect.tscn")

func _ready():
	pass # Replace with function body.
	
func _on_HurtBox_hit(damage):
	hitcount -= 1
	Utils.instance_scene_on_main(HitEffect, global_position)
	if hitcount <= 0:
		MainInstances.Player.global_position = $CreditPos.global_position
	pass # Replace with function body.
