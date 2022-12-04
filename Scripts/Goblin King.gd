extends KinematicBody2D

export (float) var speed = 10
var vel = Vector2.ZERO
var idleTarget = position
var move = Vector2.ZERO
var cooldown = 2
var health = 30
var hit = 0

func _ready():
	idleTarget = position
	$nav.connect("velocity_computed", self, "move")

func _process(delta):
	hit -= delta
	$GoblinKing/Health.value += (100-health/30.0*100.0-$GoblinKing/Health.value)/5
	if health <= 0 and not $CollisionShape2D.disabled:
		$CollisionShape2D.disabled = true
		$Extra.play("Die")
		yield(get_tree().create_timer(0.5), "timeout")
		get_parent().get_parent().get_parent().kingGoblinDefeat()
		queue_free()
	
	var target = idleTarget
	var targetName = "none"
	if get_parent().get_parent().get_parent().arena:
		target = get_parent().get_node("Player").position
		targetName = "player"
	$nav.set_target_location(target)
	if target.distance_to(position) > 50:
		target = $nav.get_next_location()
		vel += position.direction_to(target)*speed
	
	if get_parent().get_parent().get_parent().arena:
		cooldown -= delta
	if cooldown < 0:
		if get_parent().get_node("Player").position.distance_to(position) < 150 and round(rand_range(0, 1)) == 1:
			cooldown = 1
			$AnimationPlayer.play("Attack")
			yield(get_tree().create_timer(0.25), "timeout")
			var proj = load("res://Projectile.tscn").instance()
			proj.texture = load("res://Assets/shockwave.png")
			proj.lifetime = 0.5
			proj.speed = 5
			proj.scale *= 1
			proj.position = position
			proj.name = "shockwave"
			proj.ignore = ["Goblin", "Goblin King"]
			get_parent().add_child(proj)
		elif get_parent().get_parent().get_parent().arena:
			randomize()
			if round(rand_range(0, 3)) == 0:
				cooldown = 3
				$AnimationPlayer.play("Attack3")
				yield(get_tree().create_timer(0.5), "timeout")
				for i in range(3):
					var goblin = load("res://Goblin.tscn").instance()
					goblin.position = Vector2(position.x + rand_range(-100, 100), position.y + rand_range(-100, 100))
					get_parent().add_child(goblin)
			else:
				cooldown = 2
				$AnimationPlayer.play("Attack2")
				$Tween.interpolate_property(self, "position", position, get_parent().get_node("Player").position, 0.9)
				$Tween.start()
				yield(get_tree().create_timer(0.5), "timeout")
				var proj = load("res://Projectile.tscn").instance()
				proj.texture = load("res://Assets/shockwave.png")
				proj.lifetime = 0.5
				proj.speed = 5
				proj.scale *= 1
				proj.position = position
				proj.name = "shockwave"
				proj.ignore = ["Goblin", "Goblin King"]
				get_parent().add_child(proj)
				
	if (position.direction_to(target)*speed).x > 0:
		$GoblinKing.scale.x = 4
		$GoblinKing/Health.rect_scale.x = -0.25
	else:
		$GoblinKing.scale.x = -4
		$GoblinKing/Health.rect_scale.x = 0.25
		
	var anim = "Idle"
	if move.length() > speed/10:
		anim = "Run"
	if not "Attack" in $AnimationPlayer.current_animation:
		$AnimationPlayer.play(anim)
	vel *= 0.95
	$nav.set_velocity(vel)

func move(velocity: Vector2):
	var lastPos = position
	move_and_slide(velocity)
	move = position-lastPos
