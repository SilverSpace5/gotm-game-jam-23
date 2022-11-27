extends Node2D
tool

var timer = 0
export (bool) var update = false

func _process(delta):
	if update:
		update = false
		for child in get_children():
			child.queue_free()
		for tilePos in get_parent().get_node("YSort/Objects").get_used_cells_by_id(9):
			var light = load("res://Light.tscn").instance()
			add_child(light)
			light.position = tilePos*64+Vector2(32, 32)
			light.scale = Vector2(8, 8)
			#light.get_node("Light2D").color = Color.orange

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
