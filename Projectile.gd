extends Area2D

export (Texture) var texture
export (float) var speed = 200
export (float) var dir = 0
export (float) var lifetime = 1

var ignore = []
var timer = 0

func _process(delta):
	timer += delta
	if timer > lifetime:
		queue_free()
		return
	rotation_degrees = dir
	position += Vector2(1, 0).rotated(deg2rad(dir))*speed

func _on_Projectile_body_entered(body):
	for name2 in ignore:
		if body.name in name2:
			return
	if name != "slash-goblin":
		if "Goblin" in body.name:
			if body.hit < 0:
				body.health -= 1
				body.vel = Vector2(1, 0).rotated(deg2rad(dir))*speed*10
				body.hit = 0.25
				body.get_node("Extra").play("Hit")
	else:
		if "Player" in body.name:
			if body.hit < 0:
				body.health -= 1
				body.hit = 0.25
				body.get_node("Extra").play("Hit")
	queue_free()
