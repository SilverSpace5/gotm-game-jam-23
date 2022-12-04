extends CanvasLayer

var mute = false

func _process(delta):
	if mute:
		$Mute.text = "Unmute"
	else:
		$Mute.text = "Mute"

func _on_Mute_pressed():
	mute = not mute
	SaveLoad.saveData("team-sowflux-the-2-goblins.data", {"mute": mute})
	if mute:
		$Mute.text = "Unmute"
	else:
		$Mute.text = "Mute"
