extends StaticBody2D

const DeathEffect = preload("res://Effect/DeathEffect.tscn")
const HitEffect = preload("res://Effect/HitEffect.tscn")

var DataCenter = ResourceLoader.SaverAndLoader

export (int) var hard_point = 3
export (int) var COIN = 5

func _ready():
	pass # Replace with function body.

func _on_Area2D_area_entered(sword):
	Utils.instance_scene_on_main(HitEffect, global_position)
	hard_point -= sword.damage
	if hard_point <= 0:
		DataCenter.set_current_coin(DataCenter.get_current_coin() + COIN)
		Utils.instance_scene_on_main(DeathEffect, global_position)
		queue_free()
