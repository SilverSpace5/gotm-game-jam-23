extends CanvasLayer

var mute = false

func _on_Mute_pressed():
	mute = not mute
	if mute:
		$Mute.text = "Unmute"
	else:
		$Mute.text = "Mute"
