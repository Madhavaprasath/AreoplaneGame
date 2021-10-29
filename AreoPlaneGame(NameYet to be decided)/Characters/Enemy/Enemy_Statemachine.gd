extends Node2D

export (int) var Speed=400

var velocity=Vector2(20,20)

enum states{
	SHOOT,
	APPROCH,
	MOVE_ARROUND,
	MAKE_CIRCLES,
}
onready var enemy_manager=get_parent().get_parent()
onready var enemy=get_parent()
var circular_time=0
var circle=false
var angular_time=0
func _physics_process(delta):
	
	
	if enemy.global_position.distance_to(get_global_mouse_position()-Vector2(0,200))>50:
		move_towards_target(get_global_mouse_position()-Vector2(0,200))
	else:
		circle=true
	if circle:
		make_circles(delta)
	if angular_time>=23:
		velocity=Vector2()
	velocity=enemy.move_and_slide(velocity)
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
