extends Node
class_name EvolutionaryAlgorithm

# Declare member variables here. Examples:
var creature_template = preload("res://Creature_Base.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func mutate(creature):
	# determine which gene mutates
	var gene = randi()%3
	# randomly pick up or down mutation
	var roll = (randf() > 0.5)
	# define mutation amount
	var mutation = 1.0
	# gene rolled speed
	if gene == 0:
		if creature.speed < (mutation + 0.05):
			creature.speed += mutation
		else:
			if roll:
				creature.speed += mutation
			else:
				creature.speed -= mutation
				
	# gene rolled size
	elif gene == 1:
		if creature.size < (mutation + 0.05):
			creature.size += mutation
		else:
			if roll:
				creature.size += mutation
			else:
				creature.size -= mutation
				
	# gene rolled sense
	else:
		if creature.sense < (mutation + 0.05):
			creature.sense += mutation
		else:
			if roll:
				creature.sense += mutation
			else:
				creature.sense -= mutation
	

func evolution(creatures, clone):
	var new_creatures = []
	if clone:
		new_creatures = clone(creatures)
	else:
		new_creatures = procriate(creatures)
	# mutate all new creatures
	for new_creature in new_creatures:
		mutate(new_creature)
	# hand new creatures to main
	#for new_creature in new_creatures:
	#	get_parent().add_child(new_creature)
	#for creature in creatures:
	#	mutate(creature)
	return new_creatures
	
	
func clone(creatures):
	var new_creatures = []
	for creature in creatures:
		# clone for each food above 1
		for i in range(creature.food_count - 1):
			# create a clone of old creature
			var new_creature = creature_template.instance()
			new_creature.speed = creature.speed
			new_creature.size = creature.size
			new_creature.sense = creature.sense
			# TODO: set positions to same as creature
			new_creatures.append(new_creature)
	return new_creatures
	
	
func procriate(creatures):
	var new_creatures = []
	for creature in creatures:
		# procriate for each food above 1
		for i in range(creature.food_count - 1):
			# draw random partner from list, potentially itself
			var draw_partner = randi()%(creatures.size())
			var partner = creatures[draw_partner]
			# create a child of old creature
			var new_creature = creature_template.instance()
			new_creature.speed = creature.speed
			new_creature.size = partner.size
			new_creature.sense = creature.sense
			# TODO: set positions whereever
			new_creatures.append(new_creature)
	return new_creatures
	
func populate(n):
	var new_creatures = []
	for i in range(n):
		var new_creature = creature_template.instance()
		new_creatures.append(new_creature)
	return new_creatures

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
