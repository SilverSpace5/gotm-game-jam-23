extends Sprite

var move
var atc = 0
var health = 20
var hit = 0
var vel = Vector2(0, 0)
var smashing = false
var phase = 0

func reset():
	health = 20
	phase = 0
	get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam/AnimationPlayer").play("RESET")
	get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam/AnimationPlayer").play("hehe")
	get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam/Light/LightBeam").monitorable = true
	get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam2").visible = false
	get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam2/AnimationPlayer").play("RESET")
	get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam2/Light/LightBeam").monitorable = false
	get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam3").visible = false
	get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam3/AnimationPlayer").play("RESET")
	get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam3/Light/LightBeam").monitorable = false

func _ready():
	pass

func loop():
	move = round(rand_range(1,2))
	yield(get_tree().create_timer(2),"timeout")
	loop()

func attacks():
	atc = round(rand_range(1,5))
	yield(get_tree().create_timer(3),"timeout")
	attacks()
	
func _physics_process(delta):
	if not get_parent().get_parent().get_parent().boss2:
		return
	hit -= delta
	$Health.value += (100-health/20.0*100.0-$Health.value)/5
	if health <= 0 and not $Hitbox/CollisionShape2D.disabled:
		$Hitbox/CollisionShape2D.disabled = true
		$Extra.play("Die")
		yield(get_tree().create_timer(0.5), "timeout")
		reset()
		get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam/AnimationPlayer").play("RESET")
		get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam").visible = false
		get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam/Light/LightBeam").monitorable = false
		get_parent().get_parent().get_parent().boss2Defeat()
		queue_free()
	
	if health <= 15 and phase == 0:
		phase = 1
		smashing = true
		$AnimationPlayer.play("crush")
		yield(get_tree().create_timer(0.5), "timeout")
		get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam2").visible = true
		get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam2/AnimationPlayer").play("hehe")
		get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam2/Light/LightBeam").monitorable = true
		var proj = load("res://Projectile.tscn").instance()
		proj.texture = load("res://Assets/shockwave.png")
		proj.lifetime = 1
		proj.speed = 7.5
		proj.scale *= 1
		proj.position = position
		proj.name = "shockwave"
		get_parent().add_child(proj)
		yield($AnimationPlayer, "animation_finished")
		smashing = false
	if health <= 10 and phase == 1:
		phase = 2
		smashing = true
		$AnimationPlayer.play("crush")
		yield(get_tree().create_timer(0.5), "timeout")
		get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam3").visible = true
		get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam3/AnimationPlayer").play("hehe")
		get_parent().get_parent().get_parent().get_node("lightBeams/LightBeam3/Light/LightBeam").monitorable = true
		var proj = load("res://Projectile.tscn").instance()
		proj.texture = load("res://Assets/shockwave.png")
		proj.lifetime = 1
		proj.speed = 7.5
		proj.scale *= 1
		proj.position = position
		proj.name = "shockwave"
		get_parent().add_child(proj)
		yield($AnimationPlayer, "animation_finished")
		smashing = false
	
	if not smashing:
		for body in $smash.get_overlapping_bodies():
			if body.name == "Player":
				smashing = true
				$AnimationPlayer.play("crush")
				yield(get_tree().create_timer(0.5), "timeout")
				var proj = load("res://Projectile.tscn").instance()
				proj.texture = load("res://Assets/shockwave.png")
				proj.lifetime = 1
				proj.speed = 7.5
				proj.scale *= 1
				proj.position = position
				proj.name = "shockwave"
				get_parent().add_child(proj)
				yield($AnimationPlayer, "animation_finished")
				smashing = false
		
		if atc < 3:
			$AnimationPlayer.play("idle")
			
		# I disabed the the animations because they are now managed when
		# the light beams spawn
		if atc == 4:
			$AnimationPlayer.play("finger")
			#get_parent().get_parent().get_parent().get_node("AnimationPlayer").play("hehe")
			
		if atc == 5:
			$AnimationPlayer.play("hands")
			#get_parent().get_parent().get_parent().get_node("AnimationPlayer2").play("sidet")
