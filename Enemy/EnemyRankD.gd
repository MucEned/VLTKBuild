extends "res://Enemy/Enemy.gd"

const Arrow = preload("res://Player/Arrow.tscn")
const JumpEffect = preload("res://Effect/JumpEffect.tscn")

enum DIRECTION {
	LEFT = -1,
	RIGHT = 1,
	STAY = 0,
}

onready var playerCatcher = $Sprite/PlayerCatcher
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var floorLeft = $RayCaster/FloorLeft
onready var floorRight = $RayCaster/FloorRight
onready var wallLeft = $RayCaster/WallLeft
onready var wallRight = $RayCaster/WallRight
onready var attackCooldown = $AttackCooldown
onready var shotPoint = $Sprite/Weapon/Sprite/ShotPoint
onready var leftEyes = $LeftEyes
onready var rightEyes = $RightEyes
onready var turnHelper = $TurnHelper

export (int) var STAND_SHOT_MAX_RANGE = 100
export (DIRECTION) var WALKING_DIRECTION

var state
var last_direction
var can_do_next_attack = false
var turn_again = true

enum{
	IDLE,
	JUMPSHOT,
	STANDSHOT
}

var attack_state = IDLE
var last_pos_y

func _ready():
	last_pos_y = global_position.y
	state = WALKING_DIRECTION
	pass # Replace with function body.

# warning-ignore-all:unused_argument
func _physics_process(delta):
	global_position.y = last_pos_y
	
	if playerCatcher.is_colliding() and attack_state == IDLE and can_do_next_attack == true:
		last_direction = state
		state = DIRECTION.STAY
		if abs(playerCatcher.get_collision_point().x - sprite.global_position.x) > STAND_SHOT_MAX_RANGE:
			animationPlayer.play("Stand")
			attack_state = STANDSHOT
		else:
			animationPlayer.play("Jump")
			attack_state = JUMPSHOT
		can_do_next_attack = false
		attackCooldown.start()

	match state:
		DIRECTION.RIGHT:
			animationPlayer.play("Move")
			motion.x = MAX_SPEED
			if (not floorRight.is_colliding() or wallRight.is_colliding() or leftEyes.is_colliding()) and turn_again == true:
				state = DIRECTION.LEFT
				turn_again = false
				turnHelper.start()
		DIRECTION.LEFT:
			animationPlayer.play("Move")
			motion.x = -MAX_SPEED
			if (not floorLeft.is_colliding() or wallLeft.is_colliding() or rightEyes.is_colliding()) and turn_again == true:
				state = DIRECTION.RIGHT
				turn_again = false
				turnHelper.start()
		DIRECTION.STAY:
			motion.x = 0

	var facing = sign(motion.x)
	if facing != 0:
		sprite.scale.x = facing
	motion = move_and_slide(motion)
	
func back_to_idle_state():
	state = last_direction
	animationPlayer.play("Idle")
	attack_state = IDLE

func _on_AttackCooldown_timeout():
	can_do_next_attack = true
	pass # Replace with function body.
	
func shot_the_arrow(force):
	var arrow = Utils.instance_scene_on_main(Arrow, shotPoint.global_position)
	arrow.linear_velocity = Vector2.RIGHT.rotated(self.rotation) * force
	arrow.linear_velocity.x *= sprite.scale.x
	arrow.rotation = arrow.linear_velocity.angle()

func create_jump_effect():
	Utils.instance_scene_on_main(JumpEffect, global_position)

func _on_TurnHelper_timeout():
	turn_again = true
	pass # Replace with function body.
