extends Node2D

export (int) var speed=400
export (int) var circling_speed=100
export (NodePath) var Player_path
enum states{
	IDLE,
	MOVE,
	SHOOT,
	ROCKETLAUNCH,
	CIRCLE
}

var current_state
var current_animation

var velocity=Vector2()
var direction_vector=Vector2()
var circular_time=0

onready var player=get_node(Player_path)
func _ready():
	current_state=states.IDLE
	current_animation="Idle"

func _physics_process(delta):
	print(velocity)
	check_input()
	#match_state(delta)
	check_exit_conditions(delta)
	velocity=player.move_and_slide(velocity)
	make_circles(delta)


func match_state(delta):
	match current_state:
		states.IDLE:
			play_idle_state(delta)
		states.MOVE:
			play_move_state(delta)
		states.SHOOT:
			pass
		states.ROCKETLAUNCH:
			pass
		states.CIRCLE:
			pass


func check_exit_conditions(delta):
	match current_state:
		states.IDLE:
			exit_condition_idle()
		states.MOVE:
			pass



func check_input():
	var directions ={
		"Left":Input.is_action_pressed("ui_left"),
		"Right":Input.is_action_pressed("ui_right"),
		"Up":Input.is_action_pressed("ui_up"),
		"Down":Input.is_action_pressed("ui_down")
	}
	direction_vector.x=int(directions["Right"])-int(directions["Left"])
	direction_vector.y=int(directions["Down"])-int(directions["Up"])

func play_idle_state(delta):
	velocity=lerp(velocity,Vector2(0,0),1-pow(1,delta))

func exit_condition_idle():
	if direction_vector.x!=0 and direction_vector.y==0 ||direction_vector.x==0 and direction_vector.y!=0:
		current_state=states.MOVE
	elif direction_vector.x!=0 and direction_vector.y!=0:
		current_state=states.CIRCLE


func play_move_state(delta):
	velocity=lerp(velocity,direction_vector*speed,1-pow(0.00001,delta))


func make_circles(delta):
	circular_time+=delta*-5
	velocity.x=sin(circular_time)*400
	velocity.y=cos(circular_time)*400
