extends Node2D

func _ready():
	Signal.connect("spwan_bullets",self,"on_shooting")


func on_shooting(bullet,pos,direction):
	var child_bull=bullet.instance()
	child_bull.position=pos
	child_bull.start(direction)
	add_child(child_bull)

