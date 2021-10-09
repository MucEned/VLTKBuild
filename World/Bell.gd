extends RigidBody2D

var Data = ResourceLoader.SaverAndLoader

const RingEffect = preload("res://Effect/Ring.tscn")

onready var Par = $Particles2D

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Data.load_player_data().bell == true:
		Par.visible = true
	else:
		Par.visible = false
	pass

func _on_HurtBox_hit(damage):
	Utils.instance_scene_on_main(RingEffect, global_position)
	var old_data = Data.load_player_data()
	old_data.bell = true
	Data.save_player_data(old_data)
	pass # Replace with function body.
