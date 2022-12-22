extends PanelContainer

onready var cameraZoomSpinBox = $"VBoxContainer/GridContainer/CameraZoomSpinBox"
onready var camera:Camera2D = $"../../MapViewportContainer/Viewport/Camera2D"
onready var takeMapButton = $"VBoxContainer/TakeMapButton"
onready var mapGen = $"../../MapGenViewportContainer/Viewport/MapGen"
onready var simulation = $"../../MapViewportContainer/Viewport/Simulation"

func _ready():
	cameraZoomSpinBox.connect("value_changed", self, "on_camera_zoom_change")	
	cameraZoomSpinBox.set_value(50)
	
	takeMapButton.connect("pressed", self, "on_take_map_pressed")


func on_camera_zoom_change(value):
	camera.set_zoom(Vector2(value, value))
	
func on_take_map_pressed():
	print("on_take_map_pressed")
	var texture: Texture = mapGen.getTexture()
	simulation.fillFromTexture(texture)
