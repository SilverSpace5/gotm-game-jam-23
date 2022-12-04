extends Sprite

var move
var atc = 0


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
	
	if atc < 3:
		$AnimationPlayer.play("idle")
		
	if atc == 4:
		$AnimationPlayer.play("finger")
		
	if atc == 5:
		$AnimationPlayer.play("hands")
