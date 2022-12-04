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

func collide(body):
	for name2 in ignore:
		if body.name in name2:
			return
	var hitEntity = false
	if not "slash-goblin" in name and not "shockwave" in name:
		if "Goblin" in body.name:
			hitEntity = true
			if body.hit < 0:
				body.health -= 1
				body.vel = Vector2(1, 0).rotated(deg2rad(dir))*speed*10
				body.hit = 0.25
				body.get_node("Extra").play("Hit")
	else:
		if "Player" in body.name:
			hitEntity = true
			if body.hit < 0:
				body.health -= 1
				body.hit = 0.5
				body.vel = Vector2(1, 0).rotated(deg2rad(dir))*speed*100
				body.get_node("Extra").play("Hit")
	if hitEntity:
		Sounds.playSound("res://Assets/Sounds/Hit/impactMining_00" + str(round(rand_range(1, 4))) + ".ogg")
	elif not "shockwave" in name:
		Sounds.playSound("res://Assets/Sounds/HitWall/impactPlank_medium_00" + str(round(rand_range(1, 4))) + ".ogg")
	if not "shockwave" in name:
		queue_free()

func _on_Projectile_body_entered(body):
	if not "Goblin King" in body.name:
		collide(body)

func remove():
	queue_free()

func _on_Projectile_area_entered(area):
	if "Goblin King" in area.get_parent().name:
		collide(area.get_parent())
