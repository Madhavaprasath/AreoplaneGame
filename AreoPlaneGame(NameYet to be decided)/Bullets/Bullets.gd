extends Area2D

export (int) var  speed=400
var shot = false
var velocity=Vector2()
func _physics_process(delta):
	if shot:
		position+=velocity*delta



func start(pos,direction):
	velocity=direction*speed
	
	rotation=direction.angle()
