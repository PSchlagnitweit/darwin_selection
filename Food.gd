extends Area2D
class_name Food


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_entered", self, "get_eaten")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	var rad = 10
	draw_circle(Vector2(0, 0), rad, Color.red)

func get_eaten(area):
	var parent: Creature_Control = area.get_parent()

	parent.food_count += 1
	queue_free()
