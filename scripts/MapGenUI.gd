extends PanelContainer

onready var sizeXSpinBox = $"VBoxContainer/GridContainer2/SizeXSpinBox"
onready var sizeYSpinBox = $"VBoxContainer/GridContainer2/SizeYSpinBox"
onready var mapGen = $"../../MapGen"
onready var start = $"VBoxContainer/GridContainer/StartButton"
onready var pause = $"VBoxContainer/GridContainer/PauseButton"

var sizeX: float
var sizeY: float
var run: bool = false

func _ready():
	sizeXSpinBox.connect("value_changed", self, "on_size_x_changed")
	sizeYSpinBox.connect("value_changed", self, "on_size_y_changed")
	start.connect("pressed", self, "on_start_pressed")
	pause.connect("pressed", self, "on_pause_pressed")
	
	sizeXSpinBox.set_value(200)
	sizeYSpinBox.set_value(100)
	
func on_size_x_changed(value):	
	self.sizeX = value
	mapGen.changeSize(Vector2(self.sizeX, self.sizeY))

func on_size_y_changed(value):
	self.sizeY = value
	mapGen.changeSize(Vector2(self.sizeX, self.sizeY))

func on_start_pressed():
	self.run = true

func on_pause_pressed():
	self.run = false
