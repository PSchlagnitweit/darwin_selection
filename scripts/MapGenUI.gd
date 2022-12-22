extends PanelContainer

onready var sizeXSpinBox = $"VBoxContainer/GridContainer2/SizeXSpinBox"
onready var sizeYSpinBox = $"VBoxContainer/GridContainer2/SizeYSpinBox"
onready var mapGen = $"../../MapGenViewportContainer/Viewport/MapGen"

var sizeX: float
var sizeY: float

func _ready():
	sizeXSpinBox.connect("value_changed", self, "on_size_x_changed")
	sizeYSpinBox.connect("value_changed", self, "on_size_y_changed")
	
	sizeXSpinBox.set_value(100)
	sizeYSpinBox.set_value(200)
	
func on_size_x_changed(value):	
	self.sizeX = value
	mapGen.changeSize(Vector2(self.sizeX, self.sizeY))

func on_size_y_changed(value):
	self.sizeY = value
	mapGen.changeSize(Vector2(self.sizeX, self.sizeY))
