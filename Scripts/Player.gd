extends KinematicBody2D

export (float) var speed = 500
export (bool) var minecart = false
export (float) var maxHealth = 3
var vel = Vector2.ZERO
var lastDir = "+x"
var slotVel = 0
var item = 0
var health:float = 1
var hit = 0
onready var spawn = position

func _ready():
	health = maxHealth

func _process(delta):
	hit -= delta
	if hit < -3:
		health += 0.01
		health = clamp(health, 0, maxHealth)
	if health <= 0:
		position = spawn
		health = maxHealth
	$Health.value += (100-health/maxHealth*100.0-$Health.value)/5
	var bpo = get_parent().get_parent().get_parent().get_node("BPO")
	var currentBPO = bpo.get_cellv(bpo.world_to_map((position-Vector2(0, 32))/4))
	minecart = currentBPO != -1
	var oldRot = $Slots.rotation
	
	if Input.is_action_just_pressed("attack") and not $Moves.is_playing():
		if item == 1:
			$Moves.play("Sword")
			var proj = load("res://Projectile.tscn").instance()
			proj.texture = load("res://Assets/slash.png")
			proj.lifetime = 0.1
			proj.speed = 10
			proj.scale *= 6
			proj.dir = $Slots.rotation_degrees
			proj.position = $Slots/Sword.global_position
			proj.name = "slash"
			proj.ignore = ["Player"]
			get_parent().add_child(proj)
		if item == 2:
			$Moves.play("Bow")
			yield(get_tree().create_timer(0.3), "timeout")
			var proj = load("res://Projectile.tscn").instance()
			proj.texture = load("res://Assets/arrow.png")
			proj.lifetime = 1
			proj.speed = 25
			proj.scale *= 4
			proj.dir = $Slots.rotation_degrees+180
			proj.position = $Slots/Bow.global_position
			proj.name = "arrow"
			proj.ignore = ["Player"]
			get_parent().add_child(proj)
	
	if Input.is_action_just_pressed("sword"):
		if item == 1:
			item = 0
		else:
			item = 1

	if Input.is_action_just_pressed("bow"):
		if item == 2:
			item = 0
		else:
			item = 2

	if item == 0:
		slotVel += vel.length()/2000+0.01
		slotVel *= 0.99/(delta+1)
		$Slots.rotation_degrees += slotVel
		$Slots/Slot1.colour = Color.white
		$Slots/Slot2.colour = Color.white
#		$Slots/Slot1.modulate = Color(0.294, 0.294, 0.294, 1)
#		$Slots/Slot2.modulate = Color(0.294, 0.294, 0.294, 1)
		$Slots/Bow.modulate.a = (1)
		$Slots/Sword.modulate.a = (1)

	if item == 1:
		$Slots.look_at(get_global_mouse_position())
		$Slots.rotation = lerp_angle(oldRot, $Slots.rotation, 0.5)
		$Slots/Slot1.colour = Color.green
		$Slots/Slot2.colour = Color.red
#		$Slots/Slot1.modulate = Color(0.188, 0.294, 0.164, 1)
#		$Slots/Slot2.modulate = Color(0.294, 0.121, 0.121, 1)
		$Slots/Sword.modulate.a = (1)
		$Slots/Bow.modulate.a = (0.350)

	if item == 2:
		$Slots.look_at(get_global_mouse_position())
		$Slots.rotation = lerp_angle(oldRot, $Slots.rotation + 1.35 + 360, 0.5)
		$Slots/Slot1.colour = Color.red
		$Slots/Slot2.colour = Color.green
#		$Slots/Slot2.modulate = Color(0.188, 0.294, 0.164, 1)
#		$Slots/Slot1.modulate = Color(0.294, 0.121, 0.121, 1)
		$Slots/Bow.modulate.a = (1)
		$Slots/Sword.modulate.a = (0.350)

	if minecart:
		speed *= 1.25
	if item == 0:
		speed *= 1.25
	if Input.is_action_pressed("left"):
		vel.x -= speed
		lastDir = "-x"
		$Player.scale.x = -4
	if Input.is_action_pressed("right"):
		vel.x += speed
		lastDir = "+x"
		$Player.scale.x = 4
	if Input.is_action_pressed("up"):
		vel.y -= speed
		lastDir = "+y"
		$Player.scale.x = 4
	if Input.is_action_pressed("down"):
		vel.y += speed
		lastDir = "-y"
		$Player.scale.x = 4
	if item == 0:
		speed /= 1.25
	if minecart:
		speed /= 1.25
	vel *= 0.5/(delta+1)
	
	var anim = "Idle"
	if lastDir == "+y":
		anim = "IdleBack"
	elif lastDir == "-y":
		anim = "IdleFront"
	
	if abs(vel.x) > speed/5:
		if vel.x > 0:
			$Player.scale.x = 4
		else:
			$Player.scale.x = -4
		anim = "Run"
		$Cart.frame = 0
	if vel.y > speed/5:
		anim = "RunFront"
		$Cart.frame = 1
	if vel.y < -speed/5:
		anim = "RunBack"
		$Cart.frame = 1
		
	if item != 0:
		if get_global_mouse_position().x > position.x:
			$Player.scale.x = 4
		else:
			$Player.scale.x = -4
		
		var disX = abs(get_global_mouse_position().x-position.x)
		var disY = abs(get_global_mouse_position().y-position.y)
		
		if disX > disY:
			if "Run" in anim:
				anim = "Run"
			else:
				anim = "Idle"
		if disY > disX:
			$Player.scale.x = 4
			if get_global_mouse_position().y > position.y:
				if "Run" in anim:
					anim = "RunFront"
				else:
					anim = "IdleFront"
			else:
				if "Run" in anim:
					anim = "RunBack"
				else:
					anim = "IdleBack"
		
	
	$Cart.visible = minecart
	if minecart:
		$Player.scale.x = 4
		$AnimationPlayer.stop()
		$Player.frame = 15
	else:
		$AnimationPlayer.play(anim)
	move_and_slide(vel)

#	for child in get_parent().get_parent().get_node("Lights").get_children():
#		child.visible = false
#	for i in range(360/3):
#		$lightDetect.rotation_degrees = i*3
#		$lightDetect.force_raycast_update()
#		var body = $lightDetect.get_collider()
#		if body:
#			if body.get_parent().get_parent().name == "Lights":
#				body.get_parent().visible = true
	
	$Slots.rotation_degrees = float(int($Slots.rotation_degrees*1000) % 360000) / 1000
	var rot = abs($Slots.rotation_degrees)
	$Slots/Sword.scale.y = 1
	if rot > 90 and rot < 270:
		$Slots/Sword.scale.y = -1
	$Slots/Bow.scale.y = $Slots/Sword.scale.y
	
#	get_node("Slots/Sword").global_rotation = 0
#	get_node("Slots/Bow").global_rotation = 0
