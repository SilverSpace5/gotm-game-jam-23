extends KinematicBody2D

export (float) var speed = 500
var vel = Vector2.ZERO
var lastDir = "+x"

func _process(delta):
	if Input.is_action_pressed("left"):
		vel.x -= speed
	if Input.is_action_pressed("right"):
		vel.x += speed
	vel.x *= 0.5/(delta+1)
	
	var anim = "Idle"
	if lastDir == "+y":
		anim = "IdleFront"
	elif lastDir == "-y":
		anim = "IdleBack"
	
	move_and_slide(vel)
