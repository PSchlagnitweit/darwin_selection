extends Control

onready var textureRectFinalDisplay:TextureRect = $"TextureRectFinalDisplay"

func getTexture() -> Texture:
	return textureRectFinalDisplay.texture
