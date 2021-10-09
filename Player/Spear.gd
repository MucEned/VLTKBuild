extends Node2D

const DustEffect = preload("res://Effect/DustEffect.tscn")

onready var animator = $AnimationPlayer
onready var changeState = $ChangeState
onready var hold = $Hold
onready var tip = $Sprite/Tip
onready var player_node = get_parent().get_parent().get_parent()

var Ki = ResourceLoader.Ki

# warning-ignore-all:unused_argument
func _process(delta):
	var player = get_parent()
	rotation = player.get_local_mouse_position().angle()
	
	if Input.is_action_just_pressed("player_attack"):
		if Ki.ki_check(1):
			if hold.is_stopped():
				hold.start()
				hold.one_shot = false
			animator.play("Spin")
			changeState.start()
	
	if Input.is_action_just_released("player_attack"):
		hold.one_shot = true
		changeState.stop()
		animator.play("Idle")
	
	if not Ki.ki_check(1):
		hold.one_shot = true
		animator.play("Idle")
	
func change_to_auto_state():
	animator.play("Auto")

func _on_ChangeState_timeout():
	change_to_auto_state()

func _on_Hold_timeout():
	if player_node.is_on_field:
		Ki.ki_calculate(1)
		
func particle_spawn():
	var dustEffect = DustEffect.instance()
	var dust_position = tip.global_position
	dust_position.x += rand_range(-4, 4)
	dustEffect.global_position = dust_position
	get_tree().current_scene.add_child(dustEffect)
