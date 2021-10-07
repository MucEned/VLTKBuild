extends RigidBody2D

var stop = false

const hitEffect = preload("res://Effect/HitEffect.tscn")
const dustEffect = preload("res://Effect/DeathEffect.tscn")

var flying_long_time = false

var narrow = 0

# warning-ignore-all:unused_argument
func _physics_process(delta):
	if stop == false:
		rotation = linear_velocity.angle()

func _on_Deleted_body_entered(body):
	if stop == false:
		if flying_long_time:
			remove_child($HitBox)
			$LiverTime.start()
		else:
			call_deferred("remove_this_object")
	stop = true

func _on_LiverTime_timeout():
	call_deferred("remove_this_object")

func _on_HurtBox_hit(damage):
	call_deferred("remove_this_object")

func remove_this_object():
	Utils.instance_scene_on_main(hitEffect, self.global_position)
	Utils.instance_scene_on_main(dustEffect, self.global_position)
	queue_free()

func _on_JustSpawn_timeout():
	flying_long_time = true
	pass # Replace with function body.

func narrow_check():
	narrow += 1
	if narrow >= 2:
		call_deferred("remove_this_object")

func _on_NarrowCheckBottom_body_entered(body):
	narrow_check()
	pass # Replace with function body.

func _on_NarrowCheckTop_body_entered(body):
	narrow_check()
	pass # Replace with function body.

func _on_HurtBox_area_entered(area):
	call_deferred("remove_this_object")
	pass # Replace with function body.
