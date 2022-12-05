extends Node2D

export (int) var maxGoblins = 20
var goblinTimer = 0
var arena = false
var goblins = 0
var boss2 = false

func _process(delta):
	if Music.mute:
		$normal.volume_db = -100
		$boss_fight_music.volume_db = -100
		$techno_boss_theme.volume_db = -100
	else:
		$normal.volume_db = 0
		$boss_fight_music.volume_db = 0
		$techno_boss_theme.volume_db = 0

func _ready():
	$Lights.visible = true
	$Lights.update = true
	$boss_fight_music.playing = false
	$techno_boss_theme.playing = false

func boss2Defeat():
	$nav/YSort/Player.setMessage("You Finished!", 2)
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://Assets/Menu.tscn")

func kingGoblinDefeat():
	for child in $nav/YSort.get_children():
		if "Goblin" in child.name:
			child.queue_free()
	yield(get_tree().create_timer(2), "timeout")
	$nav/YSort/Player.cutscene()
	$techno_boss_theme.playing = true
	yield(get_tree().create_timer(0.5), "timeout")
	$boss_fight_music.playing = false
	$nav/YSort/Gangster.visible = true
	for i in range(100):
		$nav/YSort/Gangster.position.y += 2.5
		yield(get_tree().create_timer(0.016), "timeout")
	$nav/YSort/Player.setBoss("The Second Brother", 2)
	yield(get_tree().create_timer(2), "timeout")
	$lightBeams.visible = true
	boss2 = true
	$lightBeams/LightBeam/AnimationPlayer.play("hehe")
	$lightBeams/LightBeam/Light/LightBeam.monitorable = true
	$nav/YSort/Gangster.loop()
	$nav/YSort/Gangster.attacks()

func _on_Arena_body_entered(body):
	if body.name == "Player":
		arena = true
		body.spawn = body.position
		body.setBoss("The First Brother", 2)
		$nav/YSort/FG.set_cell(-8, -14, 4)
		$nav/YSort/FG.set_cell(-7, -14, 1)
		$nav/YSort/FG.set_cell(-6, -14, 1)
		$nav/YSort/FG.set_cell(-5, -14, 2)
		$boss_fight_music.playing = true
		yield(get_tree().create_timer(0.5), "timeout")
		$normal.playing = false

func _on_Area2D_body_entered(body):
	if Input.is_action_pressed("use"):
		print("blah")

func _on_Goblin_Fight_body_entered(body):
	if body.name == "Player":
		body.setMessage("Use 1 and 2 to switch weapons\nUse Left Click/C/Button A on Controller to Attack\n1 - Sword, 2 - Bow", 8)
