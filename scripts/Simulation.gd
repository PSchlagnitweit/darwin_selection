extends TileMap

# Tile Indexes:
# 	0 Food
# 	1 Land
# 	2 Water
# 	3 Eaten Food


var food_scene = preload("res://scenes/Food.tscn")
var generation = 0
onready var generationCount = $"../../../UI/SimulationUI/VBoxContainer/GridContainer4/Label2"
onready var creatureCount = $"../../../UI/SimulationUI/VBoxContainer/GridContainer6/Label2"
onready var plotter = $"../../../../Plotter2D"


func fillFromTexture(texture: Texture):	
	var image: Image = texture.get_data()
	self.clear()
	self.clear_population()
	self.clear_food()
	image.lock()
	for x in image.get_width():
		for y in image.get_height():			
			var col: Color = image.get_pixel(x, y)
			var tile: int = -1
			if col.r > 0:
				tile = 0
				var food: Node2D = food_scene.instance()
				
				var pos: Vector2 = self.map_to_world(Vector2(x, y))
				pos = pos + self.get_cell_size() / 2.0
				
				food.set_position(pos)
				self.add_child(food)
			elif col.g > 0:
				tile = 1
			elif col.b > 0:
				tile = 2				
			self.set_cell(x, y, tile)
	image.unlock()
	
func pause(pause):
	for child in self.get_children():
		if child is Creature_Control:
			child.set_process(!pause)

func populate():
	var new_creatures = get_node("EA").populate(10)
	for new_creature in new_creatures:
		spawn_creatures(new_creature)
		self.add_child(new_creature)
		#new_creature.set_process(false)
		
	
func clear_population():
	for child in self.get_children():
		if child is Creature_Control:
			child.queue_free()

func clear_food():
	for child in self.get_children():
		if child is Food:
			child.queue_free()
			
func newGeneration():
	generation += 1
	generationCount.text = str(generation)
	var creature_vectors = []
	var reproduce_creatures = []
	for child in get_children():
		if child is Creature_Control:
			if child.food_count < 1: # remove if it has not found any food
				child.queue_free()
			elif child.food_count == 1:
				creature_vectors.append(Vector3(child.speed, child.size, child.sense))
			elif child.food_count > 1:
				reproduce_creatures.append(child)
				creature_vectors.append(Vector3(child.speed, child.size, child.sense))
				
					
	var new_creatures = get_node("EA").evolution(reproduce_creatures,false) # true = clone, false = procriate
	for new_creature in new_creatures:
		spawn_creatures(new_creature)
		new_creature.energy = 0 
		self.add_child(new_creature)
		new_creature.set_process(true)
		creature_vectors.append(Vector3(new_creature.speed, new_creature.size, new_creature.sense))
	
	plotter.plot(creature_vectors)
	
	for child in get_children():
		if child is Creature_Control:
			child.food_count = 0
			child.energy = 10
	
	self.clear_food()
	var food_tiles = get_used_cells_by_id(0)
	
	
	for food_tile in food_tiles:
		var food: Node2D = food_scene.instance()
		var pos: Vector2 = self.map_to_world(food_tile)
		pos = pos + self.get_cell_size() / 2.0
		food.set_position(pos)
		self.add_child(food)

func spawn_creatures(new_creature):
	new_creature.position = Vector2((randi()%5000)+400, (randi()%5000)+400)
	var tile_map = world_to_map(new_creature.position)
	var tile_id = get_cellv(tile_map)
	if(tile_id == 2):
		spawn_creatures(new_creature)
	
	
# main loop	
func _process(delta):
	var creature_count = 0
	var finished_creatures = 0
	for child in get_children():
		if child is Creature_Control:
			creature_count += 1
			if child.energy < 0.1:
				finished_creatures += 1
	creatureCount.text = str(creature_count)			
	if creature_count == 0:
		return
	
	if finished_creatures == creature_count:
		newGeneration()
				




