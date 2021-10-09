extends "res://World/UnlockWeapon.gd"


func _on_BowWeapon_body_entered(body):
	var old_data = Data.load_player_data()
	old_data.weapons[WeaponIndex] = true
	Data.save_player_data(old_data)
	queue_free()
	pass # Replace with function body.
