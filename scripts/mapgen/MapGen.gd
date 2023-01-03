extends Control

onready var textureRectFinalDisplay:TextureRect = $"TextureRectFinalDisplay"
onready var viewport1:Viewport = $"Viewport1"
onready var viewport2:Viewport = $"Viewport2"

func getTexture() -> Texture:
	return textureRectFinalDisplay.texture

func changeSize(size: Vector2) -> void:
	self.set_size(size)
	self.set_custom_minimum_size(size)
	self.viewport1.set_size(size)
	self.viewport2.set_size(size)
	self.textureRectFinalDisplay.set_size(size)
	
