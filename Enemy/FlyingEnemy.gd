extends "res://Enemy/Enemy.gd"

export (int) var ACCELERATION = 100

var MainInstances = ResourceLoader.MainInstances

onready var sprite = $Sprite

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	var player = MainInstances.Player
	if player != null:
		chase_player(delta, player)
		
func chase_player(delta, player):
	var direction = (player.global_position - global_position).normalized()
	motion += direction * ACCELERATION * delta
	motion = motion.clamped(MAX_SPEED)
	sprite.flip_h = global_position.x < player.global_position.x
	motion = move_and_slide(motion)
