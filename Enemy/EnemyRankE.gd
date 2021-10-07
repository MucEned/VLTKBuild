extends "res://Enemy/Enemy.gd"

enum DIRECTION {
	LEFT = -1,
	RIGHT = 1,
	STAY = 0,
}

const DustEffect = preload("res://Effect/DustEffect.tscn")

export (DIRECTION) var WALKING_DIRECTION

var state
var last_direction

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var floorLeft = $RayCaster/FloorLeft
onready var floorRight = $RayCaster/FloorRight
onready var wallLeft = $RayCaster/WallLeft
onready var wallRight = $RayCaster/WallRight

func _ready():
	state = WALKING_DIRECTION

# warning-ignore:unused_argument
func _physics_process(delta):
	match state:
		DIRECTION.RIGHT:
			animationPlayer.play("Move")
			motion.x = MAX_SPEED
			if not floorRight.is_colliding() or wallRight.is_colliding():
				state = DIRECTION.LEFT
		DIRECTION.LEFT:
			animationPlayer.play("Move")
			motion.x = -MAX_SPEED
			if not floorLeft.is_colliding() or wallLeft.is_colliding():
				state = DIRECTION.RIGHT
		DIRECTION.STAY:
			animationPlayer.play("Idle")
			motion.x = 0

	var facing = sign(motion.x)
	if facing != 0:
		sprite.scale.x = facing
	motion = move_and_slide(motion)

func _on_Relax_timeout():
	change_state()
	pass # Replace with function body.

func change_state():
	if state != DIRECTION.STAY:
		last_direction = state
		state = DIRECTION.STAY
	else:
		state = last_direction
	pass

func create_dust_effect():
	var dustEffect = DustEffect.instance()
	var dust_position = global_position
	dust_position.x += rand_range(-4, 4)
	dustEffect.global_position = dust_position
	get_tree().current_scene.add_child(dustEffect)
