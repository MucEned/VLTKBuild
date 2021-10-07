extends Area2D

export(int) var mass = 0.25
var launched = false
var velocity = Vector2.ZERO

func _process(delta):
	if launched:
		velocity += gravity_vec*gravity*mass
		
		position += velocity*delta
		
		rotation = velocity.angle()

func launch(initial_velocity):
	launched = true
	velocity = initial_velocity
