extends KinematicBody2D

const maxspeed = 20
export(int) var divider = 1

export(int) var speed = 10
export(int) var size = 100
export(int) var sense = 10
export(int) var amplitude = 10

var area2d
var interesting_object = null
var velocity: Vector2
var color: Color

var energy = 10
var time = 0.0
export(OpenSimplexNoise) var perlin_noise

# Called when the node enters the scene tree for the first time.
func _ready():
	area2d = get_node("Area2D")
	area2d.connect("area_entered", self, "return_entered_object")
	area2d.connect("area_exited", self, "return_object_left")

	area2d.scale = Vector2(sense / divider, sense / divider)
	
	self.scale = Vector2(size / divider, size / divider)
	self.color = Color(speed / maxspeed , 1 - speed / maxspeed, 0.0, 1.0)
func _process(delta):
	time += delta * speed * amplitude
	
	if(interesting_object != null):
		move_to_interesting(interesting_object.global_position)
	else:
		update_postion()
	update()
	
func move_to_interesting(position):
	var vector = position - self.global_position
	self.move_and_slide(vector.normalized() * speed)
	
func update_postion():
	#move object randomly based on delta time and speed
	var perlin_value_x =  perlin_noise.get_noise_2d(0.0, time)
	print(perlin_value_x)
	var perlin_value_y =  perlin_noise.get_noise_2d(time, 0.0)
	print(perlin_value_y)
	velocity = Vector2(sign(perlin_value_x) * speed, sign(perlin_value_y) * speed)
	self.move_and_slide(velocity)

	
func _draw():
	var cen = global_position
	var rad = size / divider
	var col = self.color
	draw_circle(cen, rad, col)
	
func return_entered_object(area):
	return area

func return_object_left():
	interesting_object = null
