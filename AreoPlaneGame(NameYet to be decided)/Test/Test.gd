extends Node2D

func _ready():
	Signal.connect("spwan_bullets",self,"on_shooting")
	Signal.connect("screen_shake",self,"on_screen_shake")

func on_shooting(bullet,pos,direction):
	var child_bull=bullet.instance()
	child_bull.position=pos
	child_bull.start(direction)
	add_child(child_bull)

func on_screen_shake(time,speed,st):
	$Screen_shake.start_shake(time,speed,st)
