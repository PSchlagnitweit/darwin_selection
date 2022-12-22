extends TileMap

# Tile Indexes:
# 	0 Food
# 	1 Land
# 	2 Water
# 	3 Eaten Food

var food_scene = preload("res://scenes/Food.tscn")

func fillFromTexture(texture: Texture):
	print("fillFromTexture")
	var image: Image = texture.get_data()
	self.clear()
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
				add_child(food)
			elif col.g > 0:
				tile = 1
			elif col.b > 0:
				tile = 2				
			self.set_cell(x, y, tile)
	image.unlock()
