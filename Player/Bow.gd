extends Node2D

const Arrow = preload("res://Player/Arrow.tscn")

onready var shotPoint = $ShotPoint
onready var hold = $Hold
onready var holdBow = $KiCal

export (int) var SHOT_FORCE = 200

var Ki = ResourceLoader.Ki
onready var player_node = get_parent().get_parent().get_parent()
# warning-ignore-all:unused_argument
func _process(delta):
	var player = get_parent().get_parent()
	rotation = player.get_local_mouse_position().angle()
	
	if Input.is_action_just_pressed("player_attack"):
		if Ki.ki_check(1):
			hold.start()
			
	if Input.is_action_pressed("player_attack"):
		if Ki.ki_check(1):
			if holdBow.is_stopped():
				holdBow.start()
				holdBow.one_shot = false
			
	if Input.is_action_just_released("player_attack"):
			holdBow.one_shot = true
			var arrow = Utils.instance_scene_on_main(Arrow, shotPoint.global_position)
			arrow.linear_velocity = Vector2.RIGHT.rotated(self.rotation) * (SHOT_FORCE - hold.time_left * SHOT_FORCE/hold.wait_time)
			arrow.linear_velocity.x *= player.scale.x
			arrow.rotation = arrow.linear_velocity.angle()
		
	if not Ki.ki_check(1):
		holdBow.one_shot = true

func shot():
	pass

func _on_KiCal_timeout():
	if player_node.is_on_field:
		Ki.ki_calculate(1)
	pass # Replace with function body.
