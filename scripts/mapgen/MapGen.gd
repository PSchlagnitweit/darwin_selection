extends Control

onready var textureRectFinalDisplay:TextureRect = $"TextureRectFinalDisplay"
onready var viewport1:Viewport = $"Viewport1"
onready var viewport2:Viewport = $"Viewport2"
onready var sprite1: Sprite = $"Viewport1/Sprite1"
onready var sprite2: Sprite = $"Viewport2/Sprite2"

var mapGenShader = preload("res://material/MapGen.shader")
var resetShader = preload("res://material/MapGenReset.shader")

func getTexture() -> Texture:
	return textureRectFinalDisplay.texture

func changeSize(size: Vector2) -> void:
	self.set_size(size)
	self.set_custom_minimum_size(size)
	self.viewport1.set_size(size)
	self.viewport2.set_size(size)
	self.textureRectFinalDisplay.set_size(size)
	
func start() -> void:
	sprite1.material.set_shader(mapGenShader)	
	sprite2.material.set_shader(mapGenShader)	
	sprite1.material.set_shader_param("run", true)


func pause() -> void:
	sprite1.material.set_shader_param("run", false)	

func reset() -> void:
	sprite1.material.set_shader(resetShader)
	sprite2.material.set_shader(resetShader)

func changeWaterProb(value) -> void:
	sprite1.material.set_shader_param("waterProbability", value)	

func changeWaterNeighbourThreshold(value) -> void:
	sprite1.material.set_shader_param("waterNeighbourThreshold", value)	
