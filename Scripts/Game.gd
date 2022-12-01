extends Node2D

var goblinTimer = 0
var arena = false

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

func _on_Arena_body_entered(body):
	if body.name == "Player":
		arena = true
		$nav/YSort/FG.set_cell(-8, -14, 4)
		$nav/YSort/FG.set_cell(-7, -14, 1)
		$nav/YSort/FG.set_cell(-6, -14, 1)
		$nav/YSort/FG.set_cell(-5, -14, 2)


func _on_Area2D_body_entered(body):
	if Input.is_action_pressed("use"):
		print("blah")
