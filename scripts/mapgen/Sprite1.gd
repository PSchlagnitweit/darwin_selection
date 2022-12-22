extends Sprite

func _ready():
	self.texture = $"../../Viewport2".get_texture()	
	self.texture.set_flags(self.texture.flags | Texture.FLAG_REPEAT)
