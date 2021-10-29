extends Node2D

var enemies=[]


func _ready():
	pass

func spwan_enemies():
	enemies.append(1)


func choose_circling_enemy():
	pass


func remove_enemy_after_dead(ene):
	var selected_obj=enemies.find(ene)
	enemies.remove(selected_obj)
