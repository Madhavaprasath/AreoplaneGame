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
	ROCKETAIM,
	ROCKETLAUNCH,
	CIRCLE
}

var current_state
var current_animation
var camera
var previous_state
var velocity=Vector2()
var direction_vector=Vector2()
var circular_time=0
var pointing_radius=Vector2()
var can_shoot=true
var state_bef_rocket
var targets=[]
var total_number_targets=2
var Knock_back=Vector2()

onready var player=get_node(Player_path)

func _ready():
	for i in get_tree().get_nodes_in_group("Camera"):
		camera=i
	#player.spwan_missiles()
	current_state=states.IDLE
	current_animation="Idle"

func _physics_process(delta):
	point_at_cursor_and_clamp_player()
	match_state(delta)
	var next_state=check_exit_conditions(delta)
	if next_state!=null:
		previous_state=current_state
		current_state=next_state
	velocity=player.move_and_slide(velocity)
	if !current_state in [states.ROCKETAIM]:
		check_input() 
	if check_right_click():
		
		aiming_rockets(delta)
		current_state=states.ROCKETAIM
	if Input.is_action_just_pressed("Left_Click"):
		var direction=-(player.global_position.direction_to(get_global_mouse_position()))
		knock_back(direction)
func match_state(delta):
	match current_state:
		states.IDLE:
			play_idle_state(delta)
		states.MOVE:
			play_move_state(delta)
		states.SHOOT:
			pass
		states.ROCKETAIM:
			pass
		states.ROCKETLAUNCH:
			if targets!=[]:
				Engine.time_scale=0.5
		states.CIRCLE:
			make_circles(delta)


func check_exit_conditions(delta):
	match current_state:
		states.IDLE:
			return exit_condition_idle()
		states.MOVE:
			return exit_run_condition()
		states.CIRCLE:
			return exit_circle_condition()
		states.ROCKETAIM:
			if Input.is_action_just_released("Right_Click"):
				Engine.time_scale=lerp(Engine.time_scale,1.0,1)
				if targets!=[]:
					state_bef_rocket=previous_state
					return states.ROCKETLAUNCH
				else:
					return previous_state
		states.ROCKETLAUNCH:
			if targets==[]:
				if state_bef_rocket in [states.CIRCLE]:
					return states.CIRCLE
				else:
					return states.IDLE
	return null
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
	player.spwan_missiles()
	Engine.time_scale=1.0

func exit_condition_idle():
	if direction_vector.x!=0 and direction_vector.y==0 ||direction_vector.x==0 and direction_vector.y!=0:
		circular_time=0
		return states.MOVE
	elif direction_vector.x!=0 and direction_vector.y!=0:
		pointing_radius=global_position+Vector2(0,350*direction_vector.y)
		return states.CIRCLE

func exit_run_condition():
	if direction_vector.x ==0 && direction_vector.y==0:
		return states.IDLE
	if direction_vector.x!=0 && direction_vector.y!=0:
		pointing_radius=global_position+Vector2(0,350*direction_vector.y)
		return states.CIRCLE

func exit_circle_condition():
	if direction_vector.x==0 || direction_vector.y==0:
		return states.IDLE


func play_move_state(delta):
	velocity=lerp(velocity,direction_vector*speed,0.4)


func make_circles(delta):
	circular_time+=delta*-(2.5/2)
	var expected_velocity=Vector2()
	expected_velocity.x=cos(circular_time)*height_of_circle*direction_vector.x
	expected_velocity.y=-sin(circular_time)*width_of_circle*direction_vector.y
	velocity=lerp(velocity,expected_velocity,1-pow(0.00001,delta))




func point_at_cursor_and_clamp_player():
	var rot_dir=player.global_position.angle_to_point(get_global_mouse_position())
	var distance=player.global_position.distance_to(get_global_mouse_position())
	if distance>22:
		player.rotation=rot_dir-PI/2
	player.position.x=clamp(player.position.x,16,1024-16)
	player.position.y=clamp(player.position.y,16,600-16)

func _unhandled_input(event):
	if event.is_action_pressed("Left_Click"):
		if can_shoot && ! current_state in [states.ROCKETAIM,states.ROCKETLAUNCH]:
			spwan_bullets()
			camera.start_shake(1,0.02,1)
			player.check_current_shoot_place()
		elif current_state==states.ROCKETAIM:
			if total_number_targets!=0:
				var mouse_position=get_global_mouse_position()
				var space=get_world_2d().direct_space_state
				var collided_object=space.intersect_point(mouse_position,1,[Area2D])
				if collided_object:
					print(collided_object[0]["collider"])
					var enemy_body=collided_object[0]["collider"]
					var target_node=Node2D.new()
					target_node.position=get_global_mouse_position()-enemy_body.global_position
					enemy_body.add_child(target_node)
					targets.append(target_node)
					total_number_targets-=1
				print(targets)
	if event.is_action_released("Right_Click") && current_state in [states.ROCKETAIM]:
		if targets!=[]:
			launch_rockets()
			current_state=states.ROCKETLAUNCH

func launch_rockets():
	var rocket_1_occupied=false
	var rocket_2_occupied=false
	for target in targets:
		var shortest_distance=target.global_position.distance_to(player.Rocket_slot_1.global_position)
		if (target.global_position.distance_to(player.Rocket_slot_2.global_position)<shortest_distance && !rocket_2_occupied)||rocket_1_occupied:
			fire_misssile(player.Rocket_slot_2,target)
			rocket_2_occupied=true
			print(rocket_2_occupied)
		elif rocket_2_occupied||!rocket_1_occupied:
			fire_misssile(player.Rocket_slot_1,target)
			rocket_1_occupied=true
	targets=[]

func fire_misssile(missile_slot,target):
	var rocket=missile_slot.get_children()[0]
	rocket.tracking_target=target
	rocket.position=missile_slot.global_position
	rocket.rotation=player.rotation
	rocket.fired=true
	rocket.set_as_toplevel(true)


func aiming_rockets(delta):
	slow_down_time(delta)


func slow_down_time(delta):
	Engine.time_scale=lerp(Engine.time_scale,0.0,1-pow(0.0001,delta))


func knock_back(direction):
	velocity=lerp(velocity,direction*Vector2(10,10),0.8)
	player.move_and_slide(velocity)

func check_right_click():
	return (Input.is_action_pressed("Right_Click"))

func spwan_bullets():
	Signal.emit_signal("spwan_bullets",player.bullet_scene,player.current_shoot_place.global_position,player.nose_tip.global_position.direction_to(get_global_mouse_position()))

