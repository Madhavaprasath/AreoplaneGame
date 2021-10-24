extends Area2D
var speed=500
var velocity=Vector2()

onready var rocket_trail=$Rocket_trail




var target_position
var fired=false




func _physics_process(delta):
	if fired:
		move(delta)
		rocket_trail.add_point(global_position)


func move(delta):
	var direction=(target_position-position).normalized()
	var rotate_amount=direction.cross(transform.y)
	rotate(rotate_amount*2.0*delta)
	global_translate(-transform.y*speed*delta)


func _on_Timer_timeout():
	rocket_trail.stop()
