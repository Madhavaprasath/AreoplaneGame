extends KinematicBody2D


signal spwan_bullet(bullet,pos,direction)


export (PackedScene) var bullet_scene
export (int) var movement_speed=200
export (int) var damage=20
export (int)  var health=100


onready var body = get_node("Body")
onready var fsm = get_node("Statemachine")

func _ready():
	pass



