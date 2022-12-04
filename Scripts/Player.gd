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
var cooldown = 0
var targetPos = position
var targetZoom = Vector2(1, 1)
var inCutscene = false
var cancel = false
var boss2 = false
var readyMessage = true
var readyBoss = true
var dashing = 0
var dashCooldown = 0
onready var spawn = position

func cutscene():
	setMessage("Use Space/X/X on Controller to Dash", 4)
	inCutscene = true
	boss2 = true
	health = maxHealth
	targetPos = Vector2(175, -1600)
	yield(get_tree().create_timer(3.5), "timeout")
	inCutscene = false

func setMessage(message, showTime):
	while not readyMessage:
		yield(get_tree().create_timer(0), "timeout")
	readyMessage = false
	while $Camera2D/Message.modulate.a > 0:
		$Camera2D/Message.modulate.a -= 0.05
		yield(get_tree().create_timer(0.025), "timeout")
	$Camera2D/Message.visible = false
	$Camera2D/Message.text = message
	$Camera2D/Message.modulate.a = 0
	$Camera2D/Message.visible = true
	while $Camera2D/Message.modulate.a < 1:
		$Camera2D/Message.modulate.a += 0.05
		yield(get_tree().create_timer(0.025), "timeout")
	yield(get_tree().create_timer(showTime), "timeout")
	$Camera2D/Message.modulate.a = 1
	while $Camera2D/Message.modulate.a > 0:
		$Camera2D/Message.modulate.a -= 0.05
		yield(get_tree().create_timer(0.025), "timeout")
	$Camera2D/Message.visible = false
	readyMessage = true

func setBoss(message, showTime):
	while not readyBoss:
		yield(get_tree().create_timer(0), "timeout")
	readyBoss = false
	while $Camera2D/Boss.modulate.a > 0:
		$Camera2D/Boss.modulate.a -= 0.05
		yield(get_tree().create_timer(0.025), "timeout")
	$Camera2D/Boss.visible = false
	$Camera2D/Boss.text = message
	$Camera2D/Boss.modulate.a = 0
	$Camera2D/Boss.visible = true
	while $Camera2D/Boss.modulate.a < 1:
		$Camera2D/Boss.modulate.a += 0.05
		yield(get_tree().create_timer(0.025), "timeout")
	yield(get_tree().create_timer(showTime), "timeout")
	$Camera2D/Boss.modulate.a = 1
	while $Camera2D/Boss.modulate.a > 0:
		$Camera2D/Boss.modulate.a -= 0.05
		yield(get_tree().create_timer(0.025), "timeout")
	$Camera2D/Boss.visible = false
	readyBoss = true

func _ready():
	health = maxHealth
	setMessage("Use WASD/Arrow Keys/Left Joystick to move", 4)

func _process(delta):
	if inCutscene:
		$Camera2D.global_position += (targetPos-$Camera2D.global_position)/10
		$Camera2D.zoom += (targetZoom-$Camera2D.zoom)/10
	else:
		$Camera2D.position += (Vector2(0, 0)-$Camera2D.position)/10
		$Camera2D.zoom += (Vector2(1, 1)-$Camera2D.zoom)/10
	dashing -= delta
	cooldown -= delta
	dashCooldown -= delta
	hit -= delta
	$dash.visible = dashing > 0
	if hit < -3:
		health += 0.01
		health = clamp(health, 0, maxHealth)
	if health <= 0:
		position = spawn
		health = maxHealth
		if get_parent().get_parent().get_parent().arena:
			if boss2:
				get_parent().get_node("Gangster").reset()
			else:
				get_parent().get_node("Goblin King").health = 30
				get_parent().get_node("Goblin King").position = Vector2(87, -1361)
	$Health.value += (100-health/maxHealth*100.0-$Health.value)/5
	var bpo = get_parent().get_parent().get_parent().get_node("BPO")
	var currentBPO = bpo.get_cellv(bpo.world_to_map((position-Vector2(0, 32))/4))
	minecart = currentBPO != -1
	minecart = false
	var oldRot = $Slots.rotation
	
	if Input.is_action_just_pressed("attack") and cooldown < 0 and not inCutscene:
		if item == 1:
			cooldown = 0.25
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
			cooldown = 0.5
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
	
	if Input.is_action_just_pressed("sword") and not inCutscene:
		if item == 1:
			item = 0
		else:
			item = 1

	if Input.is_action_just_pressed("bow") and not inCutscene:
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
	if Input.is_action_just_pressed("dash") and not inCutscene and dashCooldown < 0:
		speed *= 15
	var moved = false
	if Input.is_action_pressed("left") and not inCutscene:
		moved = true
		vel.x -= speed
		lastDir = "-x"
		$Player.scale.x = -4
	if Input.is_action_pressed("right") and not inCutscene:
		moved = true
		vel.x += speed
		lastDir = "+x"
		$Player.scale.x = 4
	if Input.is_action_pressed("up") and not inCutscene:
		moved = true
		vel.y -= speed
		lastDir = "+y"
		$Player.scale.x = 4
	if Input.is_action_pressed("down") and not inCutscene:
		moved = true
		vel.y += speed
		lastDir = "-y"
		$Player.scale.x = 4
	if Input.is_action_just_pressed("dash") and dashCooldown < 0 and not inCutscene:
		speed /= 15
		if moved:
			Sounds.playSound("res://Assets/Sounds/Dash/cloth" + str(round(rand_range(2, 4))) + ".ogg")
			hit = 0.25
			dashCooldown = 0.35
			dashing = 0.1
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
		
	if item != 0 and not inCutscene:
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
		
	
#	$Cart.visible = minecart
#	if minecart:
#		$Player.scale.x = 4
#		$AnimationPlayer.stop()
#		$Player.frame = 15
#	else:
	$AnimationPlayer.play(anim)
	var lastPos = position
	move_and_slide(vel)
	$dash.look_at(global_position+(position-lastPos)*100)
	$Camera2D.position -= position-lastPos

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

func _on_LaserHitbox_area_entered(area):
	if not boss2:
		return
	if area.name == "LightBeam" and hit < 0:
		health -= 1
		hit = 0.5
		get_node("Extra").play("Hit")
		Sounds.playSound("res://Assets/Sounds/Hit/Hit " + str(round(rand_range(1, 4))) + ".wav")
