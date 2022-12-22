extends KinematicBody2D
class_name Creature_Control

const maxspeed = 20
export(int) var size_adjustment = 1
export(int) var speed_adjustment = 1


export(int) var speed = 10
export(int) var size = 10
export(int) var sense = 10
export(int) var amplitude = 10

var area2d
var relative_speed
var interesting_object = null
var velocity: Vector2
var color: Color

var food_count = 0
var energy = 10
var time = 0.0
export(OpenSimplexNoise) var perlin_noise

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	perlin_noise.seed = randi()
	area2d = get_node("SensingField")
	area2d.connect("area_entered", self, "return_entered_object")
	area2d.connect("area_exited", self, "return_object_left")

	relative_speed = speed_adjustment * speed
	self.scale = Vector2(size / size_adjustment, size / size_adjustment)
	self.color = Color.red
	area2d.scale = Vector2(sense / size_adjustment, sense / size_adjustment) / self.scale
	
func _process(delta):
	time += delta * amplitude

	if(interesting_object != null):
		move_to_interesting(interesting_object.position)
	else:
		update_position()
		
	if get_slide_count() > 0:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.is_class(self.get_class):
				if collision.size > self.size * 1.2:
					self.get_eaten(collision)
	update()

func move_to_interesting(position):
	var vector = position - self.position
	self.move_and_slide(vector.normalized() * speed)
	
func update_position():
	#move object randomly based on delta time and speed
	var perlin_value_x =  perlin_noise.get_noise_2d(0.0, time)
	var perlin_value_y =  perlin_noise.get_noise_2d(time, 0.0)
	velocity = Vector2(sign(perlin_value_x) * relative_speed, sign(perlin_value_y) * relative_speed)
	self.move_and_slide(velocity)

	
func _draw():
	var rad = self.scale.x * size_adjustment
	draw_circle(Vector2(0, 0), rad, color)
	
func return_entered_object(area):
	return area

func return_object_left():
	interesting_object = null

func get_eaten(collision: Creature_Control):
	collision.food_count += 1
	queue_free()
