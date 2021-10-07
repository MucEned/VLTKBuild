extends KinematicBody2D

export (int) var MAX_SPEED = 15
export (int) var COIN = 5
var motion = Vector2.ZERO
var invincible = false

const DeathEffect = preload("res://Effect/DeathEffect.tscn")
const HitEffect = preload("res://Effect/HitEffect.tscn")

onready var blinkAnimatior = $BlinkAnimation
onready var mainCenter = $MainCenter
onready var stats = $EnemyStats

var DataCenter = ResourceLoader.SaverAndLoader

func _ready():
	set_physics_process(false)

func _on_HurtBox_hit(damage):
	if invincible == false:
		Utils.instance_scene_on_main(HitEffect, mainCenter.global_position)
		blinkAnimatior.play("Blink")
		stats.health -= damage
		
func set_invincible(value):
	invincible = value

func _on_EnemyStats_enemy_died():
	Utils.instance_scene_on_main(DeathEffect, global_position)
	DataCenter.set_current_coin(DataCenter.get_current_coin() + COIN)
	call_deferred("queue_free")

func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)
	pass # Replace with function body.

# warning-ignore:unused_argument
func _on_VisibilityNotifier2D_viewport_entered(viewport):
	set_physics_process(true)
	pass # Replace with function body.

