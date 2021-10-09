extends KinematicBody2D

const DustEffect = preload("res://Effect/DustEffect.tscn")
const JumpEffect = preload("res://Effect/JumpEffect.tscn")
const DoubleJumpEffect = preload("res://Effect/ExtraJumpEffect.tscn")
const WallDustEffect = preload("res://Effect/WallDustEffect.tscn")
const DeathEffect = preload("res://Effect/DeathEffect.tscn")
const Reload = preload("res://World/RestartCount.tscn")

const Sword = preload("res://Player/PlayerSword.tscn")
const Bow = preload("res://Player/Bow.tscn")
const Spear = preload("res://Player/Spear.tscn")
const Knife = preload("res://Player/Bow.tscn")

var PlayerStats = ResourceLoader.PlayerStats
var MainInstances = ResourceLoader.MainInstances
var Ki = ResourceLoader.Ki
var Data = ResourceLoader.SaverAndLoader

export (int) var ACCELERATION = 128 #gia toc
export (int) var MAX_SPEED = 128
export (float) var FRICTION = 0.03
export (int) var GRAVITY = 200
export (int) var JUMP_FORCE = 128
export (int) var MAX_SLOPE_ANGLE = 46
export (int) var DASH_SPEED = 50
export (int) var SLIDE_SPEED = 48
export (int) var MAX_SLIDE_SPEED = 128 
export (int) var E_PER_DJUMP = 3
export (int) var E_PER_DASH = 5
export (int) var FIELD_MIN_POS_X = 768

enum{
	MOVE, 
	WALL_SLIDE
}
enum{
	SWORD = 0, 
	BOW = 1,
	SPEAR = 2,
	KNIFE = 3
}

var state = MOVE
var motion = Vector2.ZERO
var snap_vector = Vector2.ZERO
var just_jumped = false
var invincile = false setget set_invincible
var double_jump = true
var current_weapon = SWORD
var is_on_field = false

onready var sprite = $Sprite
onready var spriteAnimator = $SpriteAnimator
onready var blinkAnimator = $BlinkAnimator
onready var coyoteJumpTimer = $CoyoteTimer
onready var dashCooldown = $DashCooldown
onready var weapon = $Sprite/Weapons
onready var warning = $Warning
onready var warning_animate = $Warning/AnimationPlayer
# warning-ignore:unused_signal
signal hit_door(door)

func set_invincible(value):
	invincile = value

func _ready():
	
	Ki.set_ki(Data.load_player_data().current_max_ki)
	
	PlayerStats.health = 4
	PlayerStats.connect("player_died", self, "_on_player_died")
	MainInstances.Player = self

func _exit_tree():
	MainInstances.Player = null

func _physics_process(delta):
	if position.x >= FIELD_MIN_POS_X:
		is_on_field = true
		
	if Ki.Ki_value == 0:
		warning.visible = true
		warning_animate.play("Animate")
	
	match state:
		MOVE:
			just_jumped = false
			var input_vector = get_input_vector()
			apply_horizontal_force(input_vector,delta)
			apply_friction(input_vector)
			update_snap_vector()
			jump_check()
			apply_gravity(delta)
			update_animations(input_vector)
			move()
			wall_slide_check()
			
		WALL_SLIDE:
			spriteAnimator.play("Slide")
			
			var wall_axis = get_wall_axis()
			if wall_axis != 0:
				sprite.scale.x = wall_axis
				
			wall_slide_jump_check(wall_axis)
			wall_slide_drop(delta)
			move()
			wall_detach(wall_axis, delta)
		
	if Input.is_action_just_pressed("player_sub_attack") and dashCooldown.time_left == 0:
		if not is_on_field:
			extra_dash()
		elif Ki.ki_calculate(E_PER_DASH):
			extra_dash()
		
	if Input.is_action_just_pressed("switch_forward"):
		change_weapon(1)
		
	if Input.is_action_just_pressed("switch_backward"):
		change_weapon(-1)
		
	if Input.is_action_just_pressed("reset_weapon"):
		Data.debug_func()
		
	if Input.is_action_just_pressed("cheat"):
		Data.cheat()

func create_dust_effect():
	var dustEffect = DustEffect.instance()
	var dust_position = global_position
	dust_position.x += rand_range(-4, 4)
	dustEffect.global_position = dust_position
	get_tree().current_scene.add_child(dustEffect)

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	return input_vector
	
func apply_horizontal_force(input_vector,delta_time):
	if input_vector.x != 0:
		motion.x += input_vector.x * ACCELERATION * delta_time
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		
func apply_friction(input_vector):
	if input_vector.x == 0 and is_on_floor():
		motion.x = lerp(motion.x, 0, FRICTION)

func update_snap_vector():
	if is_on_floor():
		snap_vector = Vector2.DOWN * 4

func jump_check():	
	if is_on_floor() or coyoteJumpTimer.time_left > 0:
		if Input.is_action_just_pressed("player_up"):
			jump(JUMP_FORCE)
			just_jumped = true
	else:
		if Input.is_action_just_released("player_up") and motion.y < -JUMP_FORCE/2: #release nut up lam motion y thay thanh 1 luc jumpforce/2
			motion.y = -JUMP_FORCE/2
			
		if Input.is_action_just_pressed("player_up") and double_jump:
			if is_on_field == false:
				jump(JUMP_FORCE * 0.5)
				double_jump = false
			elif Ki.ki_calculate(E_PER_DJUMP):
				jump(JUMP_FORCE * 0.5)
				double_jump = false
			
func jump(force):
	motion.y = -force
	snap_vector = Vector2.ZERO
	Utils.instance_scene_on_main(JumpEffect, global_position)

func apply_gravity(delta_time):
	#if not is_on_floor():
	motion.y += GRAVITY	* delta_time
	motion.y = min(motion.y, JUMP_FORCE)

func update_animations(input_vector):
	var facing = sign(get_local_mouse_position().x)
	if facing != 0:
		sprite.scale.x = facing
	if input_vector.x != 0:
		spriteAnimator.play("Move")
		spriteAnimator.playback_speed = input_vector.x * sprite.scale.x
	else:
		spriteAnimator.play("Idle")
	if not is_on_floor():
		spriteAnimator.play("Jump")

func extra_dash():
	dashCooldown.start()
	var dash_direction
	dash_direction = Vector2.RIGHT.rotated(get_local_mouse_position().angle()) * DASH_SPEED
	motion += dash_direction
	
	#jump effect
	var doubleJumpEffect = DoubleJumpEffect.instance()
	doubleJumpEffect.global_position = global_position
	doubleJumpEffect.rotation = self.get_local_mouse_position().angle()
	get_tree().current_scene.add_child(doubleJumpEffect)

func move():
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	var last_position = position
	motion = move_and_slide_with_snap(motion, snap_vector, Vector2.UP, true, 4, deg2rad(MAX_SLOPE_ANGLE))
	#landing
	if was_in_air and is_on_floor():
		position.x = last_position.x
		Utils.instance_scene_on_main(JumpEffect, global_position)
		double_jump = true
	
	#just left ground
	if was_on_floor and not is_on_floor() and not just_jumped:
		motion.y = 0
		position.y = last_position.y
		coyoteJumpTimer.start()
		
func wall_slide_check():
	if not is_on_floor() and is_on_wall():
		state = WALL_SLIDE
		double_jump = true

func get_wall_axis():
	var is_right_wall = test_move(transform, Vector2.RIGHT)
	var is_left_wall = test_move(transform, Vector2.LEFT)
	
	return int(is_left_wall) - int(is_right_wall)
	
func wall_slide_jump_check(wall_axis):
	if Input.is_action_just_pressed("player_up"):
		motion.x = wall_axis * MAX_SPEED * 0.25
		motion.y = -JUMP_FORCE
		state = MOVE
		var dust_position = global_position + Vector2(wall_axis * 4, -4)
		var dust = Utils.instance_scene_on_main(WallDustEffect, dust_position)
		dust.scale.x = wall_axis
		
func wall_slide_drop(delta_time):
	var max_slide_speed = SLIDE_SPEED
	if Input.is_action_pressed("player_down"):
		max_slide_speed = MAX_SLIDE_SPEED
	motion.y = min(motion.y + GRAVITY * delta_time, max_slide_speed)
	
	
func wall_detach(wall_axis, delta_time):
	if wall_axis == 0 or is_on_floor():
		state = MOVE
	
	if Input.is_action_just_pressed("player_right"):
		motion.x = ACCELERATION * delta_time
		state = MOVE
	if Input.is_action_just_pressed("player_left"):
		motion.x = -ACCELERATION * delta_time
		state = MOVE

func _on_HurtBox_hit(damage):
	if not invincile:
		invincile = true
		blinkAnimator.play("Blink")
		PlayerStats.health -= damage 
	pass # Replace with function body.
	
func _on_player_died():
	Utils.call_deferred("instance_scene_on_main",Reload, global_position)
	Utils.call_deferred("instance_scene_on_main", DeathEffect, global_position)
	queue_free()
	
func change_weapon(to):
	var full_weapon_array = [1, 2, 3]
	var full_object = [Sword, Bow, Spear, Knife]
	var my_weapon = [0]
	var my_data = Data.load_player_data()
	for i in 3:
		if my_data.weapons[i]:
			my_weapon.push_back(full_weapon_array[i])
			
	var next_weapon = my_weapon[(my_weapon.find(current_weapon, 0) + to) % my_weapon.size()]
	var new_weapon = full_object[next_weapon].instance()
	current_weapon = next_weapon
	var last_weapon = weapon.get_child(0)
	weapon.add_child(new_weapon)
	new_weapon.global_position = weapon.global_position
	call_deferred("remove_last_weapon", last_weapon)
	pass

func remove_last_weapon(last_weapon):
	weapon.remove_child(last_weapon)

