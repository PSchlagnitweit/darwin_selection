extends KinematicBody2D
class_name Creature_Control

const maxspeed = 20
export(int) var size_adjustment = 1
export(int) var speed_adjustment = 1
export(int) var sense_adjustment_flat = 10
export(int) var sense_adjustment_multi = 1.5


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
var energy_loss = 1
var time = 0.0
var rng = RandomNumberGenerator.new()
onready var perlin_noise = OpenSimplexNoise.new()

signal die
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	perlin_noise.seed = rng.randi()
	sensefield = get_node("SensingField")
	sensefield.connect("area_entered", self, "return_sensed_object")
	sensefield.connect("area_exited", self, "return_object_left_sense")

	relative_speed = speed_adjustment * speed
	self.scale = Vector2(size / size_adjustment, size / size_adjustment)
	self.color = Color.black
	
	sensefield.scale = Vector2(sense_adjustment_multi * sense + sense_adjustment_flat/ size_adjustment, sense_adjustment_multi * sense + sense_adjustment_flat/ size_adjustment) / self.scale
	
	hitfield = get_node("HittingField")
	hitfield.connect("area_entered", self, "return_hit_object")
	hitfield.connect("area_exited", self, "return_object_left_hit")
	hitfield.scale = Vector2(size / size_adjustment, size / size_adjustment) / self.scale * 1.1
	
	sprite = get_node("Circle")
	change_sprite_color()
	
	
func _process(delta):
	lose_energy(delta)
	time += delta * amplitude
	if(!is_instance_valid(interesting_object)):
		interesting_object = null
	
	
	if(interesting_object != null):
		if(interesting_object.is_in_group("Creatures") and interesting_object.size > self.size *1.2):
			run_the_fuck_away(interesting_object.position)
		elif(interesting_object.is_in_group("Food") or interesting_object.is_in_group("Creatures") and interesting_object.size * 1.2< self.size): 
			move_to_interesting(interesting_object.position)
	else:
		update_position()
	
	update()

func move_to_interesting(position):
	var vector = position - self.position
	self.move_and_slide(vector.normalized() * relative_speed)
	
func run_the_fuck_away(position):
	var vector = position - self.position
	self.move_and_slide(-vector.normalized() * relative_speed)
	
func update_position():
	#move object randomly based on delta time and speed
	var perlin_value_x =  perlin_noise.get_noise_2d(0.0, time / 10)
	var perlin_value_y =  perlin_noise.get_noise_2d(time / 10, 0.0)
	velocity = Vector2(sign(perlin_value_x) * relative_speed, sign(perlin_value_y) * relative_speed)
	self.move_and_slide(velocity)

func change_sprite_color():
	sprite.modulate = color
	pass
func return_sensed_object(area):
	if(area == self):
		return
	for child in get_children():
		if(area == child):
			return
	
	var temp_interesting = null
	if(area.is_in_group("HittingField")):
		temp_interesting = area.get_parent()
	elif(area.is_in_group("Food")):
		temp_interesting = area
	else:
		return
			
	if(interesting_object == null):
		interesting_object = temp_interesting
	elif(temp_interesting.is_in_group("Creatures") and temp_interesting.size > self.size *1.2):
		interesting_object = temp_interesting
		
func return_object_left_sense(_area):
	interesting_object = null
	
	if(sensefield.get_overlapping_areas().empty()):
		return
	var array = sensefield.get_overlapping_areas()
	return_sensed_object(array[0])
	
func return_hit_object(area):
	var obj = area
	if(obj == self):
		return
	for child in get_children():
		if(obj == child):
			return
	if obj.is_in_group("HittingField"):
		if obj.get_parent().size > self.size * 1.2:
			get_eaten(obj.get_parent())

func return_object_left_hit(_area):
	pass

func get_eaten(collision: Creature_Control):
	collision.food_count += 1
	queue_free()

func lose_energy(delta):
	var adjusted_size = size / 10
	var adjusted_speed = speed / 10
	var adjusted_sense = sense / 10
	
	energy -= delta * energy_loss * (pow(adjusted_size, 3) * pow(adjusted_speed, 2) + adjusted_sense)
	
