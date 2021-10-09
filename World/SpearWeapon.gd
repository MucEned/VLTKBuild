extends "res://World/UnlockWeapon.gd"

# warning-ignore:unused_argument
func _on_SpearWeapon_body_entered(body):
	var old_data = Data.load_player_data()
	old_data.weapons[WeaponIndex] = true
	Data.save_player_data(old_data)
	queue_free()
	pass # Replace with function body.
