extends KinematicBody2D

export (float) var speed = 500
export (bool) var minecart = false
var vel = Vector2.ZERO
var lastDir = "+x"
var slotVel = 0
var item = 0

func _process(delta):
	
	var bpo = get_parent().get_parent().get_node("BPO")
	var currentBPO = bpo.get_cellv(bpo.world_to_map((position-Vector2(0, 32))/4))
	minecart = currentBPO != -1
	var oldRot = $Slots.rotation
	
	if Input.is_action_pressed("sword"):
		item = 1
#add toggles to both
	if Input.is_action_pressed("shield"):
		item = 2

	if item == 0:
		slotVel += vel.length()/2000+0.01
		slotVel *= 0.99/(delta+1)
		$Slots.rotation_degrees += slotVel

	if item == 1:
		$Slots.look_at(get_global_mouse_position())
		$Slots.rotation = lerp_angle(oldRot, $Slots.rotation, 0.5)

	if item == 2:
		$Slots.look_at(get_global_mouse_position())
		$Slots.rotation = lerp_angle(oldRot, $Slots.rotation + 1.35 + 360, 0.5)

	if minecart:
		speed *= 1.25
	if Input.is_action_pressed("left"):
		vel.x -= speed
		lastDir = "-x"
		$Player.scale.x = -1
	if Input.is_action_pressed("right"):
		vel.x += speed
		lastDir = "+x"
		$Player.scale.x = 1
	if Input.is_action_pressed("up"):
		vel.y -= speed
		lastDir = "+y"
		$Player.scale.x = 1
	if Input.is_action_pressed("down"):
		vel.y += speed
		lastDir = "-y"
		$Player.scale.x = 1
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
			$Player.scale.x = 1
		else:
			$Player.scale.x = -1
		anim = "Run"
		$Cart.frame = 0
	if vel.y > speed/5:
		anim = "RunFront"
		$Cart.frame = 1
	if vel.y < -speed/5:
		anim = "RunBack"
		$Cart.frame = 1
	
	$Cart.visible = minecart
	if minecart:
		$AnimationPlayer.stop()
		$Player.frame = 15
	else:
		$AnimationPlayer.play(anim)
	move_and_slide(vel)

	
	for child in get_parent().get_parent().get_node("Lights").get_children():
		child.visible = false
	for i in range(360/3):
		$lightDetect.rotation_degrees = i*3
		$lightDetect.force_raycast_update()
		var body = $lightDetect.get_collider()
		if body:
			if body.get_parent().get_parent().name == "Lights":
				body.get_parent().visible = true
				
	get_node("Slots/Sword").global_rotation = 0
	get_node("Slots/Shield").global_rotation = 0
