extends Node2D

const player_size=1

const height_of_circle=375/2
const width_of_circle=375/2

export (int) var speed=200
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

var shoot_place=


onready var player=get_node(Player_path)
func _ready():
	current_state=states.IDLE
	current_animation="Idle"
func _physics_process(delta):
	point_at_cursor_and_clamp_player()
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
		pointing_radius=global_position+Vector2(0,350*direction_vector.y)
		current_state=states.CIRCLE

func exit_circle_condition():
	if direction_vector.x==0 || direction_vector.y==0:
		current_state=states.IDLE


func play_move_state(delta):
	velocity=lerp(velocity,direction_vector*speed,0.4)


func make_circles(delta):
	circular_time+=delta*-(2.5/2)
	var expected_velocity=Vector2()
	expected_velocity.x=-cos(circular_time)*height_of_circle*direction_vector.x
	expected_velocity.y=-sin(circular_time)*width_of_circle*direction_vector.y
	velocity=lerp(velocity,expected_velocity,1-pow(0.00001,delta))




func point_at_cursor_and_clamp_player():
	var rot_dir=player.global_position.angle_to_point(get_global_mouse_position())
	var distance=player.global_position.distance_to(get_global_mouse_position())
	if distance>22:
		player.rotation=rot_dir-PI/2
	player.position.x=clamp(player.position.x,16,1024-16)
	player.position.y=clamp(player.position.y,16,600-16)
