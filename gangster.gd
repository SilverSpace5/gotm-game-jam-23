extends Sprite



func _ready():
	$AnimationPlayer.play("idle");
	yield(get_tree().create_timer(5),"timeout");
	$AnimationPlayer.play("finger");
	$AnimationPlayer.play("hehe");
	yield(get_tree().create_timer(10),"timeout");
	$AnimationPlayer.play("idle");
