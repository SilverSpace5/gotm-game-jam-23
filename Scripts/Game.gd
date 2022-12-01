extends Node2D

var goblinTimer = 0

func _ready():
	$Lights.visible = true
	$Lights.update = true

func _process(delta):
	goblinTimer += delta
	if goblinTimer > 3:
		goblinTimer = 0
		var goblin = load("res://Goblin.tscn").instance()
		goblin.position = Vector2(1150, -1275)
		$nav/YSort.add_child(goblin)
		yield(get_tree().create_timer(0.1), "timeout")
		goblin.idleTarget = Vector2(rand_range(-300, 700), rand_range(-1600, -1000))
