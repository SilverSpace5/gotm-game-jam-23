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
	if "shockwave" in name:
		speed *= 0.8
		scale += Vector2(speed, speed)
		modulate.a -= delta
	else:
		position += Vector2(1, 0).rotated(deg2rad(dir))*speed

func _on_Projectile_body_entered(body):
	for name2 in ignore:
		if body.name in name2:
			return
	if not "slash-goblin" in name and not "shockwave" in name:
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
				body.hit = 0.5
				body.vel = Vector2(1, 0).rotated(deg2rad(dir))*speed*100
				body.get_node("Extra").play("Hit")
	if not "shockwave" in name:
		queue_free()

func remove():
	queue_free()
