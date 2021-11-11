extends Node

var rockets=[]

var common_target
func _ready():
	Signal.connect("Object_Destroyed",self,"Check_common_target")

func _on_Statemachine_rocket_fired(rocket, target):
	rockets.append([rocket,target.get_parent()])
	if len(rockets)>1:
		print(len(rockets))
		print(rockets)
		check_rockets()


func check_rockets():
	if rockets[0][1]==rockets[1][1]:
		common_target=rockets[0][1]

func Check_common_target(body,rocket):
	if common_target:
		if rockets[0][0] ==rocket:
			rockets[1][0].queue_free()
		elif rockets[1][0] ==rocket:
			rockets[0][0].queue_free()
	rockets=[]
	common_target=null
