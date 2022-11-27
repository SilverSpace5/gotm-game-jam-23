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
		for tilePos in get_parent().get_node("YSort/Objects").get_used_cells_by_id(10):
			var light = load("res://Light.tscn").instance()
			add_child(light)
			light.position = tilePos*64+Vector2(32, 32)
			light.scale = Vector2(8, 8)
