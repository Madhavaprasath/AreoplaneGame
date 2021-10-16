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
var pointing_radius=Vector2()
var a =true



onready var player=get_node(Player_path)
func _ready():
	current_state=states.IDLE
	current_animation="Idle"
func _physics_process(delta):
	check_input()
	match_state(delta)
	check_exit_conditions(delta)
	velocity=player.move_and_slide(velocity)

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
			make_circles(delta)


func check_exit_conditions(delta):
	match current_state:
		states.IDLE:
			exit_condition_idle()
		states.MOVE:
			exit_run_condition()
		states.CIRCLE:
			exit_circle_condition()



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
	velocity=Vector2()
	circular_time=0

func exit_condition_idle():
	if direction_vector.x!=0 and direction_vector.y==0 ||direction_vector.x==0 and direction_vector.y!=0:
		current_state=states.MOVE
	elif direction_vector.x!=0 and direction_vector.y!=0:
		pointing_radius=global_position+Vector2(0,350*direction_vector.y)
		current_state=states.CIRCLE

func exit_run_condition():
	if direction_vector.x ==0 && direction_vector.y==0:
		current_state=states.IDLE
	if direction_vector.x!=0 && direction_vector.y!=0:
		current_state=states.CIRCLE

func exit_circle_condition():
	if direction_vector.x==0 || direction_vector.y==0:
		current_state=states.IDLE


func play_move_state(delta):
	velocity=lerp(velocity,direction_vector*speed,0.4)


func make_circles(delta):
	circular_time+=delta*-2.5
	var expected_velocity=Vector2()
	expected_velocity.x=-cos(circular_time)*375*direction_vector.x
	expected_velocity.y=-sin(circular_time)*375*direction_vector.y
	velocity=lerp(velocity,expected_velocity,1-pow(0.00001,delta))
