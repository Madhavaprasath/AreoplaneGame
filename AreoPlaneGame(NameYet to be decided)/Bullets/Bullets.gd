extends Area2D

export (int) var  speed=600
var shot = false
var velocity=Vector2()

func _physics_process(delta):
	if shot:
		position+=velocity*delta



func start(direction):
	velocity=direction*speed
	rotation=direction.angle()+PI/2
	shot=true


func _on_Bullets_body_entered(body):
	queue_free()

