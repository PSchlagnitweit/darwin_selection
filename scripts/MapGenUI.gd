extends PanelContainer


onready var mapGen = $"../../MapGen"
onready var startPause: Button = $"VBoxContainer/GridContainer/StartPauseButton"
onready var reset = $"VBoxContainer/GridContainer/ResetButton"
onready var sizeXSpinBox = $"VBoxContainer/GridContainer2/SizeXSpinBox"
onready var sizeYSpinBox = $"VBoxContainer/GridContainer2/SizeYSpinBox"
onready var brushSizeSpinBox = $"VBoxContainer/GridContainer2/BrushSizeSpinBox"

onready var waterProbSpinBox = $"VBoxContainer/GridContainer3/WaterPropSpinBox"
onready var waterNeighbourThreshold = $"VBoxContainer/GridContainer3/WaterNeighbourThresholdSpinBox"

onready var landProbSpinBox = $"VBoxContainer/GridContainer4/LandProbSpinBox"
onready var landNeighbourThreshold = $"VBoxContainer/GridContainer4/LandNeighbourThresholdSpinBox"

onready var foodProbSpinBox = $"VBoxContainer/GridContainer5/FoodProbSpinBox"
onready var foodNeighbourThreshold = $VBoxContainer/GridContainer5/FoodNeighbourThresholdSpinBox2

var sizeX: float
var sizeY: float

var run: bool = false;

func _ready():	
	startPause.connect("pressed", self, "on_start_pause_pressed")
	reset.connect("pressed", self, "on_reset_pressed")

	sizeXSpinBox.connect("value_changed", self, "on_size_x_changed")
	sizeYSpinBox.connect("value_changed", self, "on_size_y_changed")
	brushSizeSpinBox.connect("value_changed", self, "on_brush_size_changed");

	waterProbSpinBox.connect("value_changed", self, "on_water_prob_changed")
	waterNeighbourThreshold.connect("value_changed", self, "on_water_neighbour_threshold_changed")

	landProbSpinBox.connect("value_changed", self, "on_land_prob_changed")
	landNeighbourThreshold.connect("value_changed", self, "on_land_neighbour_threshold_changed")

	foodProbSpinBox.connect("value_changed", self, "on_food_prob_changed")
	foodNeighbourThreshold.connect("value_changed", self, "on_food_neighbour_threshold_changed")

	mapGen.connect("brushSizeChanged", self, "on_burshSizedChanged")
	
	sizeXSpinBox.set_value(100)
	sizeYSpinBox.set_value(100)
	brushSizeSpinBox.set_value(2.0)

	waterProbSpinBox.set_value(2)
	waterNeighbourThreshold.set_value(2)
	landProbSpinBox.set_value(1)
	landNeighbourThreshold.set_value(1)
	foodProbSpinBox.set_value(1)
	foodNeighbourThreshold.set_value(1)

func on_burshSizedChanged(value):
	brushSizeSpinBox.set_value(value)

func on_start_pause_pressed():
	self.run = !self.run
	if self.run:
		startPause.set_text("Pause")
		mapGen.start()
	else:
		startPause.set_text("Start")
		mapGen.pause()

func on_reset_pressed():
	mapGen.reset()
	self.run = false
	startPause.set_text("Start")

func on_size_x_changed(value):	
	self.sizeX = value
	mapGen.changeSize(Vector2(self.sizeX, self.sizeY))

func on_size_y_changed(value):
	self.sizeY = value
	mapGen.changeSize(Vector2(self.sizeX, self.sizeY))

func on_brush_size_changed(value):	
	mapGen.changeBrushSize(value)

func on_water_prob_changed(value):
	mapGen.changeShaderParam("waterProbability", value/100.0)

func on_water_neighbour_threshold_changed(value):
	mapGen.changeShaderParam("waterNeighbourThreshold", value)

func on_land_prob_changed(value):	
	mapGen.changeShaderParam("landProbability", value/100.0)

func on_land_neighbour_threshold_changed(value):
	mapGen.changeShaderParam("landNeighbourThreshold", value)

func on_food_prob_changed(value):	
	mapGen.changeShaderParam("foodProbability", value/100.0)

func on_food_neighbour_threshold_changed(value):
	mapGen.changeShaderParam("foodNeighbourThreshold", value)
