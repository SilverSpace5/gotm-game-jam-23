extends Control
 
func _on_Play_pressed():
	get_tree().change_scene("res://Game.tscn")

func _on_Credits_pressed():
	$UI/Menu.visible = false
	$UI/Credits.visible = true

func _on_Back_pressed():
	$UI/Menu.visible = true
	$UI/Credits.visible = false
	
func _process(delta):
	if Music.diff == 0:
		$UI/Menu/Difficulty.text = "Difficulty - Easy"
		Music.stats = {"goblinKingCooldown": 3, "goblinKingHealth": 20.0, "lightBeamSpeed": [0.1, 0.05, 0.13], "boss2Health": 20.0}
	if Music.diff == 1:
		$UI/Menu/Difficulty.text = "Difficulty - Medium"
		Music.stats = {"goblinKingCooldown": 2, "goblinKingHealth": 30.0, "lightBeamSpeed": [0.2, 0.1, 0.25], "boss2Health": 30.0}
	if Music.diff == 2:
		$UI/Menu/Difficulty.text = "Difficulty - Hard"
		Music.stats = {"goblinKingCooldown": 1, "goblinKingHealth": 40.0, "lightBeamSpeed": [0.3, 0.15, 0.25+0.13], "boss2Health": 40.0}
	if Music.diff == 3:
		$UI/Menu/Difficulty.text = "Difficulty - Extreme"
		Music.stats = {"goblinKingCooldown": 0.5, "goblinKingHealth": 50.0, "lightBeamSpeed": [0.4, 0.2, 0.5], "boss2Health": 50.0}

func _ready():
	var data = SaveLoad.loadData("team-sowflux-the-2-goblins.data")
	if data.has("mute"):
		Music.mute = data["mute"]
	if data.has("diff"):
		Music.diff = data["diff"]
		if Music.diff == 0:
			Music.stats = {"goblinKingCooldown": 3, "goblinKingHealth": 20.0, "lightBeamSpeed": [0.1, 0.05, 0.13], "boss2Health": 20.0}
		if Music.diff == 1:
			Music.stats = {"goblinKingCooldown": 2, "goblinKingHealth": 30.0, "lightBeamSpeed": [0.2, 0.1, 0.25], "boss2Health": 30.0}
		if Music.diff == 2:
			Music.stats = {"goblinKingCooldown": 1, "goblinKingHealth": 40.0, "lightBeamSpeed": [0.3, 0.15, 0.25+0.13], "boss2Health": 40.0}
		if Music.diff == 3:
			Music.stats = {"goblinKingCooldown": 0.5, "goblinKingHealth": 50.0, "lightBeamSpeed": [0.4, 0.2, 0.5], "boss2Health": 50.0}

func _on_Difficulty_pressed():
	Music.diff += 1
	if Music.diff >= 4:
		Music.diff = 0
	SaveLoad.saveData("team-sowflux-the-2-goblins.data", {"mute": Music.mute, "diff": Music.diff})
