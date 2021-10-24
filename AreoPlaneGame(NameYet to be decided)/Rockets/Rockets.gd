extends Area2D
var speed=500
var velocity=Vector2()

onready var rocket_trail=$Rocket_trail




var target_position
var fired=false
var tracking_target



func _physics_process(delta):
	if fired:
		move(delta)
		rocket_trail.add_point(global_position)


func move(delta):
	track(tracking_target)
	var direction=(target_position-global_position).normalized()
	var rotate_amount=direction.cross(transform.y)
	rotate(rotate_amount*15.0*delta)
	global_translate(-transform.y*speed*delta)

func track(target):
	if target!=null:
		target_position=target.global_position


func _on_Timer_timeout():
	rocket_trail.stop()


func _on_Rocket_body_entered(body):
	if body.is_in_group("Targets"):
		queue_free()
		body.queue_free()
