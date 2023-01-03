extends PanelContainer


onready var mapGen = $"../../MapGen"
onready var startPause: Button = $"VBoxContainer/GridContainer/StartPauseButton"
onready var reset = $"VBoxContainer/GridContainer/ResetButton"
onready var sizeXSpinBox = $"VBoxContainer/GridContainer2/SizeXSpinBox"
onready var sizeYSpinBox = $"VBoxContainer/GridContainer2/SizeYSpinBox"
onready var waterProbSpinBox = $"VBoxContainer/GridContainer3/WaterPropSpinBox"
onready var waterNeighbourThreshold = $"VBoxContainer/GridContainer3/WaterNeighbourThresholdSpinBox"

var sizeX: float
var sizeY: float

var run: bool = false;

func _ready():	
	startPause.connect("pressed", self, "on_start_pause_pressed")
	reset.connect("pressed", self, "on_reset_pressed")

	sizeXSpinBox.connect("value_changed", self, "on_size_x_changed")
	sizeYSpinBox.connect("value_changed", self, "on_size_y_changed")

	waterProbSpinBox.connect("value_changed", self, "on_water_prob_changed")
	waterNeighbourThreshold.connect("value_changed", self, "on_water_neighbour_threshold_changed")
	
	sizeXSpinBox.set_value(200)
	sizeYSpinBox.set_value(100)
	waterProbSpinBox.set_value(1)
	waterNeighbourThreshold.set_value(2)

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

func on_water_prob_changed(value):
	mapGen.changeWaterProb(value/100.0)

func on_water_neighbour_threshold_changed(value):
	mapGen.changeWaterNeighbourThreshold(value)
