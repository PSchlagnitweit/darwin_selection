extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# first delete all old Spheres
	var creatures = []
	for i in range(10):
		var creature = Creature.new()
		creature.speed = randf() * 2
		creature.size = randf() * 2
		creature.sense = randf() * 2
		creatures.append(creature)
	
	for creature in creatures:
		var ball = CSGSphere.new()
		ball.set_radius(0.1)
		ball.translate(Vector3(creature.speed, creature.size, creature.sense))
		var material = SpatialMaterial.new()
		material.albedo_color = Color(1, 0, 0)
		ball.set_material(material)
		self.add_child(ball)
		#draw_circle(creatures.speed, creatures.size, creatures.sense)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
