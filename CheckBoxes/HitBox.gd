extends Area2D

export (int) var damage = 1

func _on_HitBox_area_entered(hurtbox):
	if hurtbox.collision_mask == 4 or hurtbox.collision_mask == 8:
		hurtbox.emit_signal("hit", damage)
