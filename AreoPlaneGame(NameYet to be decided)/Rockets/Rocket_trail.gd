extends Line2D

export var min_spwan_distance=5.0
export var limited_lifetime=false
export var gradient_color:Gradient=Gradient.new()

var gravity=Vector2.UP
var lifetime=[5.0,6.0]
var tickspeed=0.05
var tick =0.0
var point_age=[0.0]
var wild_speed=0.1

var wildness=3.0

func _ready():
	gradient=gradient_color
	set_as_toplevel(true)
	clear_points()
	if limited_lifetime:
		stop()

func stop():
	$Tween.interpolate_property(self,"modulate:a",1.0,0.0,10.0,Tween.TRANS_CIRC,Tween.EASE_OUT)
	$Tween.start()

func _process(delta):
	if tick>tickspeed:
		tick=0
		for p in range(get_point_count()):
			point_age[p]+=5.0*delta
			
			var rand_vector=Vector2(rand_range(-wild_speed,wild_speed),rand_range(-wild_speed,wild_speed))
			points[p]+=gravity+(rand_vector*wildness*point_age[p])
			
	else:
		tick+=delta

func add_point(point_pos,at_pos=-1):
	if get_point_count()>0 and point_pos.distance_to(points[get_point_count()-1])<min_spwan_distance:
		return
	
	point_age.append(0.0)
	.add_point(point_pos,at_pos)

func _on_Tween_tween_all_completed():
	pass # Replace with function body.
