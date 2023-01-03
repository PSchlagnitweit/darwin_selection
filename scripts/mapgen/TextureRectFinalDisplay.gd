extends TextureRect

onready var Sprite1 = $"../Viewport1/Sprite1"

var frameCount = 0
var valid_mouse_pos: bool = true
var mouse_pos: Vector2
var click_threshold: float

signal click_threshold_changed(value)

func _ready():
	
	on_click_threshold_change(5.0)
	
	pass # Replace with function body.

func on_click_threshold_change(value):
	click_threshold = value
	Sprite1.material.set_shader_param("click_threshold", value)
	emit_signal("click_threshold_changed", click_threshold)

func _input(event: InputEvent):
	if not event is InputEventMouse:
		return

	if not Sprite1:
		print("Could not mount Sprite1")
		return

	if event is InputEventMouseButton:
		if event.button_index == 4:
			on_click_threshold_change(max(click_threshold - 1, 1.0))
		elif event.button_index == 5:
			on_click_threshold_change(click_threshold + 1)
			
		if valid_mouse_pos:
			Sprite1.material.set_shader_param("mouse_pressed", event.pressed)
			Sprite1.material.set_shader_param("mouse_button_index", event.button_index)

	if event is InputEventMouseMotion:
		mouse_pos = event.position
		# var ui_rect: Rect2 = UIContainer.get_rect()		
		# valid_mouse_pos  = not ui_rect.has_point(mouse_pos)
		Sprite1.material.set_shader_param("mouse_position", mouse_pos)

func _physics_process(_delta):	
	update()

func _draw():
	if valid_mouse_pos:
		draw_circle(mouse_pos, click_threshold, Color(1.0, 1.0, 1.0, 0.5))
