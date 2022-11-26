extends KinematicBody2D

export (float) var speed = 500
var vel = Vector2.ZERO
var lastDir = "+x"

func _process(delta):
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
	vel *= 0.5/(delta+1)
	
	var anim = "Idle"
	if lastDir == "+y":
		anim = "IdleBack"
	elif lastDir == "-y":
		anim = "IdleFront"
	
	if abs(vel.x) > speed/5:
		anim = "Run"
	if vel.y > speed/5:
		anim = "RunFront"
	if vel.y < -speed/5:
		anim = "RunBack"
	
	$AnimationPlayer.play(anim)
	move_and_slide(vel)
