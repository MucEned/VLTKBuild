extends Node2D

const DustEffect = preload("res://Effect/DustEffect.tscn")

onready var spriteAnimator = $AnimationPlayer
onready var tipPosition = $Tip
onready var holdSword = $Timer
onready var changeState = $ChangeState

onready var player_node = get_parent().get_parent().get_parent()
var is_slashing = false

var Ki = ResourceLoader.Ki

# warning-ignore:unused_argument
func _process(delta):
	var player = get_parent()
	rotation = player.get_local_mouse_position().angle()
	
	if Input.is_action_pressed("player_attack") and is_slashing == false:
		if Ki.ki_check(1):
			if holdSword.is_stopped():
				holdSword.start()
				holdSword.one_shot = false
			spriteAnimator.play("Slash")
			changeState.start()
			
	if Input.is_action_just_released("player_attack"):
		holdSword.one_shot = true
		changeState.stop()
		is_slashing = false
		spriteAnimator.play("Idle")
		
	if not Ki.ki_check(1):
		holdSword.one_shot = true
		is_slashing = false
		spriteAnimator.play("Idle")
		
func sword_particle_spawn():
	var dustEffect = DustEffect.instance()
	var dust_position = tipPosition.global_position
	dust_position.x += rand_range(-4, 4)
	dustEffect.global_position = dust_position
	get_tree().current_scene.add_child(dustEffect)
		
func sword_slashing():
	is_slashing = true
	spriteAnimator.play("Slashing")

func _on_Timer_timeout():
	if player_node.is_on_field:
		Ki.ki_calculate(1)
	pass # Replace with function body.

func _on_ChangeState_timeout():
	sword_slashing()
	pass # Replace with function body.
