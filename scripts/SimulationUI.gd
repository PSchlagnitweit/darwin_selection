extends PanelContainer

onready var cameraZoomSpinBox = $"VBoxContainer/GridContainer/CameraZoomSpinBox"
onready var camera:Camera2D = $"../../MapViewportContainer/Viewport/Camera2D"

func _ready():
	cameraZoomSpinBox.connect("value_changed", self, "on_camera_zoom_change")	
	cameraZoomSpinBox.set_value(10)
	pass


func on_camera_zoom_change(value):
	camera.set_zoom(Vector2(value, value))
	pass
