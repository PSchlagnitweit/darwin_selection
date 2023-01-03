extends Node2D
class_name plot2D

export(String) var xaxis
export(String) var yaxis

var plot_point = preload("res://plot/point2D.tscn")
var origin = Vector2(14, 318)

# Called when the node enters the scene tree for the first time.
func _ready():
	$XLabel.text = xaxis
	$YLabel.text = yaxis
	

	
	for child in get_children():
		if child is point2D:
			if child != $Background:
				pass
	pass # Replace with function body.

func plot(points):
	for child in get_children():
		if child is point2D:
			child.queue_free()
	for point in points:
		var x = 0
		var y = 0
		match xaxis:
			"speed": x = point.x
			"size": x = point.y
			"sense": x = point.z
		match yaxis:
			"speed": y = point.x
			"size": y = point.y
			"sense": y = point.z
		var new_point = plot_point.instance()
		new_point.position = 10 * Vector2(x, -y) + origin
		var colorx = clamp(point.x / 20, 0 , 1)
		var colory = clamp(point.y / 20, 0 , 1)
		var colorz = clamp(point.z / 20, 0 , 1)
		
		new_point.modulate = Color(colorx,colory,colorz)
		add_child(new_point)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
