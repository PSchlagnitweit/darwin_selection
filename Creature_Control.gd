extends KinematicBody2D
class_name Creature_Control

const maxspeed = 20
export(int) var size_adjustment = 1
export(int) var speed_adjustment = 1


export(int) var speed = 10
export(int) var size = 10
export(int) var sense = 10
export(int) var amplitude = 10

var sensefield
var hitfield
var sprite
var relative_speed
var interesting_object = null
var velocity: Vector2
var color: Color

var food_count = 0
var energy = 10
var time = 0.0
export(OpenSimplexNoise) var perlin_noise = OpenSimplexNoise.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	perlin_noise.seed = randi()
	sensefield = get_node("SensingField")
	sensefield.connect("area_entered", self, "return_sensed_object")
	sensefield.connect("area_exited", self, "return_object_left_sense")

	relative_speed = speed_adjustment * speed
	self.scale = Vector2(size / size_adjustment, size / size_adjustment)
	self.color = Color.red
	
	sensefield.scale = Vector2(sense / size_adjustment, sense / size_adjustment) / self.scale
	
	hitfield = get_node("HittingField")
	hitfield.connect("area_entered", self, "return_hit_object")
	hitfield.connect("area_exited", self, "return_object_left_hit")
	hitfield.scale = Vector2(size / size_adjustment, size / size_adjustment) / self.scale * 1.1
	
	sprite = get_node("Circle")
	change_sprite_color()
	
func _process(delta):
	time += delta * amplitude

	if(interesting_object != null):
		move_to_interesting(interesting_object.position)
	else:
		update_position()
	
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

func change_sprite_color():
	sprite.modulate = color
	pass
func return_sensed_object(area):
	return area

func return_object_left_sense(_area):
	interesting_object = null
	
func return_hit_object(area):
	var obj = area.get_parent()
	if(obj == self):
		return
	if obj.is_in_group("Creatures"):
		if obj.size > self.size * 1.2:
			get_eaten(obj)

func return_object_left_hit(_area):
	pass

func get_eaten(collision: Creature_Control):
	collision.food_count += 1
	queue_free()
