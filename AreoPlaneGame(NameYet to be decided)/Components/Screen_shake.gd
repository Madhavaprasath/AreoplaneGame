extends Camera2D

onready var wait_timer=get_node("Wait_timer")
onready var shake_timer=get_node("Shake_timer")
onready var tween=get_node("Tween")

export var reset_speed=0
export var strength=0
var doing_shake=false

func _on_Wait_timer_timeout():
	if doing_shake:
		tween.interpolate_property(self,"offset",offset,Vector2(rand_range(-strength,strength),rand_range(-strength,strength)),reset_speed,Tween.TRANS_SINE,Tween.EASE_OUT)
		tween.start()

func start_shake(time,speed,st):
	print("shaking")
	doing_shake=true
	strength=st
	reset_speed=speed
	shake_timer.start(time)
	wait_timer.start(speed)


func _on_Shake_timer_timeout():
	doing_shake=false
	tween.interpolate_property(self,"offset",offset,Vector2(0,0),reset_speed,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween.start()
