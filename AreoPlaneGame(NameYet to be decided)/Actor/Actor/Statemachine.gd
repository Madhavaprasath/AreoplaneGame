extends Node2D


export (Array) var states
var stack=[]
var current_state=null
var previous_state=null

func _ready():
	Set_state("Idle")
	yield(get_tree().create_timer(2),"timeout")
	Set_state("Run")

func _physics_process(delta):
	transition()

func transition():
	current_state=get_current_state()
	if current_state !=null:
		state_behaviour()
		state_exit_condition()

func state_behaviour():
	match current_state:
		"_":
			pass

func state_exit_condition():
	match current_state:
		"_":
			pass


func get_current_state():
	return states[len(states)-1] if len(states)>0 else null

func enter_state(cur):
	stack.push_front(cur)



func Pop_state():
	return  stack.pop_front() if stack!=[] else null


func Set_state(state):
	for i in states:
		if i !=null:
			if i.to_lower()==state.to_lower():
				previous_state=Pop_state()
				print("Previous_state:",previous_state)
				print(state,current_state)
				enter_state(state)
		else:
			printerr("States cant be null")
