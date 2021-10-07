extends "res://Enemy/Enemy.gd"

const Knife = preload("res://Enemy/Knife.tscn")
const KnifeSpin = preload("res://Enemy/KnifeSpin.tscn")
const DashEffect = preload("res://Effect/DashEffect.tscn")
const DustEffect = preload("res://Effect/DustEffect.tscn")
const JumpEffect = preload("res://Effect/JumpEffect.tscn")
const KnifeClone = preload("res://Enemy/KnifeClone.tscn")

enum DIRECTION {
	LEFT = -1,
	RIGHT = 1,
	STAY = 0,
}

enum{
	IDLE, 
	AIR,
	STEP,
	DASH_AND_THROW,
	JUMP
}

export (DIRECTION) var WALKING_DIRECTION

var state
var attack_state
var last_direction
var can_do_next_attack = false

onready var playerCatcher = $Sprite/PlayerCatcher
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var floorLeft = $RayCaster/FloorLeft
onready var floorRight = $RayCaster/FloorRight
onready var wallLeft = $RayCaster/WallLeft
onready var wallRight = $RayCaster/WallRight
onready var leftEyes = $LeftEye
onready var rightEyes = $RightEye
onready var attackCooldown = $AttackCooldown
onready var blink = $Blink
onready var turnHelper = $TurnHelper
onready var throwPoint = $ThrowPoint
onready var leftKnifeEye = $KnifeCatcher/BottomLeft
onready var rightKnifeEye = $KnifeCatcher/BottomRight
onready var playerJumpCatcher = $Sprite/PlayerJumpCatcher
onready var backCooldown = $BackCooldown

var turn_again = true
var position_helper
var target_pos
var was_throw = false
var last_position
var back = false
var last_move_is_jump = false

func _ready():
	position_helper = self.global_position.y
	state = WALKING_DIRECTION
	attack_state = IDLE
	
	target_pos = global_position.x

func _physics_process(delta):
	global_position.y = position_helper
	
	if leftKnifeEye.is_colliding():
		target_pos = leftKnifeEye.get_collision_point().x
		if can_do_next_attack:
			last_position = global_position.x
			attackCooldown.start()
			can_do_next_attack = false
			attack_state = DASH_AND_THROW
		
	if rightKnifeEye.is_colliding():
		target_pos = rightKnifeEye.get_collision_point().x
		if can_do_next_attack:
			last_position = global_position.x
			attackCooldown.start()
			can_do_next_attack = false
			attack_state = DASH_AND_THROW
		
	if not floorRight.is_colliding() and not floorLeft.is_colliding():
		attack_state = AIR
		
	if playerCatcher.is_colliding() and can_do_next_attack:
		can_do_next_attack = false
		attackCooldown.start()
		attack_state = STEP
		
	if playerJumpCatcher.is_colliding() and can_do_next_attack:
		if last_move_is_jump == false:
			can_do_next_attack = false
			attackCooldown.start()
			attack_state = JUMP
		else:
			for i in 3:
				throw_up_clone(rand_range(30,90))
			can_do_next_attack = false
			attackCooldown.start()
			attack_state = STEP
	
	match attack_state:		
		IDLE:
#
#			if abs(playerCatcher.get_collision_point().x - global_position.x) < 20 and back:
#				to_players_back()
			
			if rightEyes.is_colliding():
				last_position = global_position.x
				target_pos = rightEyes.get_collision_point().x
				
			if	leftEyes.is_colliding():
				last_position = global_position.x
				target_pos = leftEyes.get_collision_point().x
				
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
		DASH_AND_THROW:
			last_move_is_jump = false
			if was_throw == false:
				was_throw = true
				throw_up(rand_range(50, 75))
				create_dash_effect()
			animationPlayer.play("Dash")
			tele(target_pos)
			motion.x = 0
		AIR:
			animationPlayer.play("OnAir")
			motion.x = 0
		STEP:
			last_move_is_jump = false
			if was_throw == false:
				was_throw = true
				throw_forward()
			match state:
				DIRECTION.RIGHT:
					animationPlayer.play("Step")
					motion.x = MAX_SPEED
					if (not floorRight.is_colliding() or wallRight.is_colliding() or leftEyes.is_colliding()) and turn_again == true:
						turn_again = false
						turnHelper.start()
						state = DIRECTION.LEFT
				DIRECTION.LEFT:
					animationPlayer.play("Step")
					motion.x = -MAX_SPEED
					if (not floorLeft.is_colliding() or wallLeft.is_colliding() or rightEyes.is_colliding()) and turn_again == true:
						turn_again = false
						turnHelper.start()
						state = DIRECTION.RIGHT
		JUMP:
			last_move_is_jump = true
			match state:
				DIRECTION.RIGHT:
					animationPlayer.play("Jump")
					motion.x = MAX_SPEED
					if (not floorRight.is_colliding() or wallRight.is_colliding() or leftEyes.is_colliding()) and turn_again == true:
						turn_again = false
						turnHelper.start()
						state = DIRECTION.LEFT
				DIRECTION.LEFT:
					animationPlayer.play("Jump")
					motion.x = -MAX_SPEED
					if (not floorLeft.is_colliding() or wallLeft.is_colliding() or rightEyes.is_colliding()) and turn_again == true:
						turn_again = false
						turnHelper.start()
						state = DIRECTION.RIGHT

	var facing = sign(motion.x)
	if facing != 0:
		sprite.scale.x = facing
	motion = move_and_slide(motion)


func _on_TurnHelper_timeout():
#	attackCooldown.start()
	turn_again = true
	pass # Replace with function body.

func return_to_idle():
	attackCooldown.start()
	was_throw = false
	attack_state = IDLE

func _on_ArrowCatcher_body_entered(body):
	if can_do_next_attack:
		throw_forward()
		last_position = global_position.x
		attackCooldown.start()
		can_do_next_attack = false
		attack_state = DASH_AND_THROW
	pass # Replace with function body.

func throw_up(force):
	var knife = Utils.instance_scene_on_main(Knife, throwPoint.global_position)
	knife.linear_velocity = Vector2(1 * rand_range(0.3, 0.7), -1) * force
	knife.linear_velocity.x *= sprite.scale.x
	knife.rotation = knife.linear_velocity.angle()
	
func throw_up_clone(force):
	var knife = Utils.instance_scene_on_main(KnifeClone, throwPoint.global_position)
	knife.linear_velocity = Vector2(1 * rand_range(0.5, 1), -0.5) * force
	knife.linear_velocity.x *= sprite.scale.x
	knife.rotation = knife.linear_velocity.angle()

func throw_forward():
	var knife = Utils.instance_scene_on_main(Knife, throwPoint.global_position)
	knife.linear_velocity = Vector2(1, -0.3) * 100
	knife.linear_velocity.x *= sprite.scale.x
	knife.rotation = knife.linear_velocity.angle()

func tele(posx):
	position.x = posx

func spin():
	Utils.instance_scene_on_main(KnifeSpin, global_position)

func _on_AttackCooldown_timeout():
	can_do_next_attack = true
	pass # Replace with function body.

func back_to_last_pos():
	position.x = position.x - sprite.scale.x * 8
	attack_state = IDLE

func create_dash_effect():
	var effect = Utils.instance_scene_on_main(DashEffect, global_position)
	effect.scale.x = sprite.scale.x

func throw_down():
	var vectorArray = [
		{
			"x": 1,
			"y": 1
		},
		{
			"x": -1,
			"y": 1
		},
		{
			"x": 0,
			"y": 1
		},
	]
	Utils.instance_scene_on_main(KnifeSpin, global_position)
	for i in 3:
		var knife = Utils.instance_scene_on_main(Knife, throwPoint.global_position)
		knife.linear_velocity = Vector2(vectorArray[i].x, vectorArray[i].y) * 200
		knife.linear_velocity.x *= sprite.scale.x
		knife.rotation = knife.linear_velocity.angle()
		
func create_dust_effect():
	Utils.instance_scene_on_main(DustEffect, global_position)
	pass
	
func create_jump_effect():
	Utils.instance_scene_on_main(JumpEffect, global_position)
	pass

func _on_BackCooldown_timeout():
	back = true;
	pass # Replace with function body.

func to_players_back():
	backCooldown.start()
	create_dash_effect()
	print("back")
	back = false
	position.x -= sprite.scale.x * 32
	pass
#func _physics_process(delta):
#	if playerCatcher.is_colliding():
#		if blink.is_stopped():
#			blink.start()
#			last_player_pos_x = playerCatcher.get_collision_point().x
#
#func _on_Blink_timeout():
#	if playerCatcher.is_colliding():
#		print("Player to me: " + str(playerCatcher.get_collision_point().x - global_position.x))
#		print("Player velocity: " + str(last_player_pos_x - playerCatcher.get_collision_point().x) + " per 0.1s")
#	else:
#		print("I cant see player")
#	pass # Replace with function body.






