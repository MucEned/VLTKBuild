extends Area2D

onready var animator = $AnimationPlayer
onready var center = $Position2D

const DeathEffect = preload("res://Effect/DeathEffect.tscn")

func _ready():
	pass # Replace with function body.

# warning-ignore:unused_argument
func _on_Grass_body_entered(body):
	animator.play("Animate")
	pass # Replace with function body.

# warning-ignore:unused_argument
func _on_Grass_area_entered(area):
	animator.play("Animate")
	pass # Replace with function body.


# warning-ignore:unused_argument
func _on_HitArea_area_entered(area):
	Utils.instance_scene_on_main(DeathEffect, center.global_position)
	call_deferred("queue_free")
