extends KinematicBody2D

export (float) var speed = 10
var vel = Vector2.ZERO
var idleTarget = position
var move = Vector2.ZERO

func _ready():
	idleTarget = position
	$nav.connect("velocity_computed", self, "move")

func _process(delta):
	var target = idleTarget
	var targetName = "none"
	if get_parent().get_parent().get_parent().arena:
		target = get_parent().get_node("Player").position
		targetName = "player"
	$nav.set_target_location(target)
	if target.distance_to(position) > 25:
		target = $nav.get_next_location()
		vel += position.direction_to(target)*speed
	if (position.direction_to(target)*speed).x > 0:
		$GoblinKing.scale.x = 1
	else:
		$GoblinKing.scale.x = -1
		
	var anim = "Idle"
	if move.length() > speed/10:
		anim = "Run"
	$AnimationPlayer.play(anim)
	vel *= 0.95
	$nav.set_velocity(vel)

func move(velocity: Vector2):
	var lastPos = position
	move_and_slide(velocity)
	move = position-lastPos
