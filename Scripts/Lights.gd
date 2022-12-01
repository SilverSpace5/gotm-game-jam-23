extends Node2D
tool

var timer = 0
export (bool) var update = false
export (float) var lightRadius = 10
export (float) var lightEnergy = 1
export (Color) var lightColour = Color(1, 1, 1)

func _ready():
	update = true

func _process(delta):
	if update:
		update = false
		for child in get_children():
			child.queue_free()
		for tilePos in get_parent().get_node("nav/YSort/Objects").get_used_cells_by_id(9):
			var light = load("res://Light.tscn").instance()
			add_child(light)
			light.position = tilePos*64+Vector2(32, 32)
			light.scale = Vector2(lightRadius, lightRadius)
			light.energy = lightEnergy
			light.colour = lightColour
		for tilePos in get_parent().get_node("nav/YSort/Objects").get_used_cells_by_id(10):
			var light = load("res://Light.tscn").instance()
			add_child(light)
			light.position = tilePos*64+Vector2(32, 32)
			light.scale = Vector2(lightRadius, lightRadius)
			light.energy = lightEnergy
			light.colour = lightColour
		for tilePos in get_parent().get_node("nav/YSort/Objects").get_used_cells_by_id(23):
			var light = load("res://Light.tscn").instance()
			add_child(light)
			light.position = tilePos*64+Vector2(32, 32)
			light.scale = Vector2(lightRadius, lightRadius)
			light.energy = lightEnergy
			light.colour = lightColour
		for tilePos in get_parent().get_node("nav/YSort/Objects").get_used_cells_by_id(25):
			var light = load("res://Light.tscn").instance()
			add_child(light)
			light.position = tilePos*64+Vector2(32, 32)
			light.scale = Vector2(lightRadius, lightRadius)
			light.energy = lightEnergy
			light.colour = lightColour