extends PanelContainer

onready var cameraZoomSpinBox = $"VBoxContainer/GridContainer/CameraZoomSpinBox"
onready var camera:Camera2D = $"../../MapViewportContainer/Viewport/Camera2D"
onready var takeMapButton = $"VBoxContainer/TakeMapButton"
onready var mapGen = $"../../MapGen"
onready var simulation = $"../../MapViewportContainer/Viewport/Simulation"
onready var populateMapButton = $"VBoxContainer/GridContainer2/PopulateButton"
onready var clearMapButton = $"VBoxContainer/GridContainer2/ClearButton"
onready var startSimulationButton = $"VBoxContainer/GridContainer3/StartButton"
onready var pauseSimulationButton = $"VBoxContainer/GridContainer3/PauseButton"
onready var gameSpeedSpinBox = $"VBoxContainer/GridContainer5/GameSpeed"

func _ready():
	cameraZoomSpinBox.connect("value_changed", self, "on_camera_zoom_change")	
	cameraZoomSpinBox.set_value(15)
	
	takeMapButton.connect("pressed", self, "on_take_map_pressed")
	
	populateMapButton.connect("pressed", self, "on_populate_map_pressed")
	clearMapButton.connect("pressed", self, "on_clear_map_pressed")
	
	startSimulationButton.connect("pressed", self, "on_start_simulation_pressed")
	pauseSimulationButton.connect("pressed", self, "on_pause_simulation_pressed")
	
	gameSpeedSpinBox.connect("value_changed", self, "on_game_speed_change")	
	gameSpeedSpinBox.set_value(1)


func on_camera_zoom_change(value):
	camera.set_zoom(Vector2(value, value))
	
func on_take_map_pressed():
	var texture: Texture = mapGen.getTexture()
	simulation.fillFromTexture(texture)
	
	
func on_populate_map_pressed():
	simulation.populate()


func on_clear_map_pressed():
	#simulation.newGeneration()
	simulation.clear_population()


func on_start_simulation_pressed():
	simulation.pause(false)


func on_pause_simulation_pressed():
	simulation.pause(true)

func on_game_speed_change(value):
	Engine.time_scale = value
