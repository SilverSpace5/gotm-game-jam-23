extends CanvasLayer

var mute = false
var stats = {"goblinKingCooldown": 3, "goblinKingHealth": 20, "lightBeamSpeed": [0.1, 0.05, 0.13], "boss2Health": 20}
var diff = 0

func _process(delta):
	if mute:
		$Mute.text = "Unmute"
	else:
		$Mute.text = "Mute"

func _on_Mute_pressed():
	mute = not mute
	SaveLoad.saveData("team-sowflux-the-2-goblins.data", {"mute": mute, "diff": diff})
	if mute:
		$Mute.text = "Unmute"
	else:
		$Mute.text = "Mute"
