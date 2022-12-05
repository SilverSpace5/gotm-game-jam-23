extends AudioStreamPlayer

var timer = 0

func start():
	playing = true
	yield(self, "finished")
	queue_free()

func _process(delta):
	timer += delta
	if timer > 0.5 or Music.mute:
		queue_free()
