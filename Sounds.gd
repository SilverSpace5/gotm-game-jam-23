extends Node

func playSound(path, volume=0) -> AudioStreamPlayer:
	if Music.mute:
		return null
	var sound = AudioStreamPlayer.new()
	sound.set_script(load("res://sound.gd"))
	sound.stream = load(path)
	sound.volume_db = volume
	sound.start()
	add_child(sound)
	return sound
