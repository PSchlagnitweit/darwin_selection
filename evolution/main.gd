extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# create creatures
	for i in range(20):
		add_child(Creature.new())
	
"""
	for i in range(5):
		print("Iteration " + str(i))
		var reproduce_creatures = []
		# get all creatures
		print("Total creatures: " + str(get_child_count()-1))
		for child in get_children():
			if child is Creature:
				print("\t" + str(child.speed) + " , " + str(child.size) + " , " + str(child.sense))
				child.food = randi()%2 # give it a random number of food
				print(child.food)
				if child.food < 1: # remove if it has not found any food
					print("remove")
					child.queue_free()
				else:
					reproduce_creatures.append(child)
					
		get_node("EA").evolution(reproduce_creatures)
"""

	
	
	#for child in get_children():
	#	if child is Creature:
	#		print(str(child.speed) + " , " + str(child.size) + " , " + str(child.sense))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(1):
		print("\nIteration " + str(i))
		var reproduce_creatures = []
		# get all creatures
		print("Total creatures: " + str(get_child_count()-1))
		for child in get_children():
			if child is Creature:
				child.food = randi()%3 # give it a random number of food 0-2
				print("\t" + str(child.speed) + " , " + str(child.size) + " , " + str(child.sense) + " , food: " +str(child.food))
				if child.food < 1: # remove if it has not found any food
					child.queue_free()
				elif child.food > 1:
					reproduce_creatures.append(child)
					
		get_node("EA").evolution(reproduce_creatures)
