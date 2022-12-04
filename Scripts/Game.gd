extends Node2D

export (int) var maxGoblins = 20
var goblinTimer = 0
var arena = false
var goblins = 0

func _ready():
	$Lights.visible = true
	$Lights.update = true
	$boss_fight_music.playing = false
	$techno_boss_theme.playing = false

func kingGoblinDefeat():
	$boss_fight_music.playing = false
	$techno_boss_theme.playing = true

func _on_Arena_body_entered(body):
	if body.name == "Player":
		arena = true
		body.spawn = body.position
		$nav/YSort/FG.set_cell(-8, -14, 4)
		$nav/YSort/FG.set_cell(-7, -14, 1)
		$nav/YSort/FG.set_cell(-6, -14, 1)
		$nav/YSort/FG.set_cell(-5, -14, 2)
		$boss_fight_music.playing = true


func _on_Area2D_body_entered(body):
	if Input.is_action_pressed("use"):
		print("blah")
