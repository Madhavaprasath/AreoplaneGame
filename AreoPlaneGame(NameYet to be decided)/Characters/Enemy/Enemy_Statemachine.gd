extends Node2D

export (int) var Speed=300

var velocity=Vector2(20,20)

enum states{
	SHOOT,
	APPROCH,
	MOVE_ARROUND,
	MAKE_CIRCLES,
}
onready var enemy_manager=get_parent().get_parent()
onready var enemy=get_parent()
onready var raycast_parent = get_parent().get_node("Raycast")
var circular_time=0
var circle=false
var angular_time=0
var a=true
func _physics_process(delta):
	rotate_raycast()
	var offset
	if a:
		offset=Vector2(0,200) 
	else:
		offset=Vector2()
	if enemy.global_position.distance_to(get_global_mouse_position()-offset)>50:
		move_towards_target(get_global_mouse_position()-offset)
	else:
		if a==true:
			circle=true
			a=false
	if circle:
		make_circles(delta)
	if angular_time>=23:
		angular_time=0
		velocity=Vector2(1,1)
		circle=false
	velocity=enemy.move_and_slide(velocity)

func match_current_state(delta):
	pass

func exit_current_state(delta):
	pass

func move_towards_target(target_position):
	var desired_velocity=(target_position-enemy.global_position).normalized()*Speed
	var steering =desired_velocity-velocity
	
	steering=turncate(steering,Speed)
	steering/=5.0
	if velocity!=Vector2():
		velocity=turncate(velocity+steering,Speed)
	print(velocity)

func turncate(vector,force):
	var i
	if vector!=Vector2():
		i =force/vector.length()
		i=min(i,1.0)
		return vector*i
	return Vector2()
	
func make_circles(delta):

	angular_time+=delta*1.25
	var expected_velocity=Vector2()
	expected_velocity.x=cos(angular_time)*187.5
	expected_velocity.y=sin(angular_time)*187.5
	velocity=expected_velocity


func rotate_raycast():
	raycast_parent.rotation_degrees+=10
