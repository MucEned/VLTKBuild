extends "res://Enemy/Enemy.gd"

enum DIRECTION {
	LEFT = -1,
	RIGHT = 1,
	STAY = 0,
}

enum{
	IDLE, 
	SPIN,
	STEP,
	TOP
}

export (DIRECTION) var WALKING_DIRECTION

var state
var attack_state
var last_direction
var can_do_next_attack = false

const SpinEffect = preload("res://Effect/SpinEffect.tscn")
const VerticleSpinEffect = preload("res://Effect/VerticleSpinEffect.tscn")
const DustEffect = preload("res://Effect/DustEffect.tscn")
const JumpEffect = preload("res://Effect/JumpEffect.tscn")
const Trophy = preload("res://World/SpearWeapon.tscn")

onready var playerCatcher = $Sprite/PlayerCatcher
onready var playerJumpCatcher = $Sprite/PlayerJumpCatcher
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var floorLeft = $RayCaster/FloorLeft
onready var floorRight = $RayCaster/FloorRight
onready var wallLeft = $RayCaster/WallLeft
onready var wallRight = $RayCaster/WallRight
onready var leftEyes = $LeftEye
onready var rightEyes = $RightEye
onready var attackCooldown = $AttackCooldown
onready var turnHelper = $TurnHelper

var turn_again = true
var position_helper

# Called when the node enters the scene tree for the first time.
func _ready():
	position_helper = self.global_position.y
	state = WALKING_DIRECTION
	attack_state = IDLE

# warning-ignore:unused_argument
func _physics_process(delta):
	global_position.y = position_helper
	match attack_state:
		IDLE:
			if playerCatcher.is_colliding() and can_do_next_attack == true:
				attack_state = STEP
			if playerJumpCatcher.is_colliding() and can_do_next_attack == true:
				attack_state = TOP
			match state:
				DIRECTION.RIGHT:
					animationPlayer.play("Move")
					motion.x = MAX_SPEED
					if (not floorRight.is_colliding() or wallRight.is_colliding() or leftEyes.is_colliding()) and turn_again == true:
						turn_again = false
						turnHelper.start()
						state = DIRECTION.LEFT
				DIRECTION.LEFT:
					animationPlayer.play("Move")
					motion.x = -MAX_SPEED
					if (not floorLeft.is_colliding() or wallLeft.is_colliding() or rightEyes.is_colliding()) and turn_again == true:
						turn_again = false
						turnHelper.start()
						state = DIRECTION.RIGHT
				DIRECTION.STAY:
					animationPlayer.play("Idle")
					motion.x = 0
		SPIN:
			animationPlayer.play("Spin")
			motion.x = 0
		STEP:
			animationPlayer.play("Step")
			attackCooldown.start()
			can_do_next_attack = false
			match state:
				DIRECTION.RIGHT:
					motion.x = MAX_SPEED
					if not floorRight.is_colliding() or wallRight.is_colliding() or leftEyes.is_colliding() and turn_again == true:
						turn_again = false
						turnHelper.start()
						state = DIRECTION.LEFT
				DIRECTION.LEFT:
					motion.x = -MAX_SPEED
					if not floorLeft.is_colliding() or wallLeft.is_colliding() or rightEyes.is_colliding() and turn_again == true:
						turn_again = false
						turnHelper.start()
						state = DIRECTION.RIGHT
		TOP:
			attackCooldown.start()
			can_do_next_attack = false
			animationPlayer.play("Top")
			motion.x = 0

	var facing = sign(motion.x)
	if facing != 0:
		sprite.scale.x = facing
	motion = move_and_slide(motion)

func return_to_idle_attack_state():
	attack_state = IDLE

func spin():
	var spinEffect = Utils.instance_scene_on_main(SpinEffect,sprite.global_position)
	spinEffect.scale.x = sprite.scale.x
func verticle_spin():
	var spinEffect = Utils.instance_scene_on_main(VerticleSpinEffect,sprite.global_position)
	spinEffect.scale.x = sprite.scale.x
	
# warning-ignore:unused_argument
func _on_NegaArrowEye_body_entered(body):
	if can_do_next_attack == true:
		attack_state = SPIN
	pass # Replace with function body.

func _on_AttackCooldown_timeout():
	can_do_next_attack = true
	pass # Replace with function body.

func _on_TurnHelper_timeout():
	turn_again = true
	pass # Replace with function body.
	
func create_dust_effect():
	Utils.instance_scene_on_main(DustEffect, global_position)
	pass
	
func create_jump_effect():
	Utils.instance_scene_on_main(JumpEffect, global_position)
	pass

func _on_EnemyStats_enemy_drop():
	Utils.instance_scene_on_main(Trophy, global_position)
	pass # Replace with function body.
