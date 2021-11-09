extends "res://Characters/Actor/Actor.gd"

onready var rot_tween=get_node("Rotate_tween")

onready var place_1=get_node("Positions/Shoot1")
onready var place_2=get_node("Positions/Shoot2")
onready var nose_tip=get_node("Positions/Nose_tip")
onready var current_shoot_place=place_1
onready var Rocket_slot_1=get_node("Positions/Rocket_launch1")
onready var Rocket_slot_2=get_node("Positions/Rocket_launch2")

func _process(delta):
	if $RayCast2D.is_colliding():
		print("Hello")


func check_current_shoot_place():
	if current_shoot_place==place_1:
		current_shoot_place=place_2
	elif current_shoot_place==place_2:
		current_shoot_place=place_1


func spwan_missiles():
	spwan_missile(Rocket_slot_1)
	spwan_missile(Rocket_slot_2)

func spwan_missile(Roc):
	if Roc.get_child_count()==0:
		var rocket=Rocket.instance()
		Roc.add_child(rocket)
