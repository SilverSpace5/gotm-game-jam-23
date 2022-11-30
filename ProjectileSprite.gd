extends Sprite
tool
onready var lastTexture = get_parent().texture

func _ready():
	get_parent().get_node("Sprite").texture = get_parent().texture
	lastTexture = get_parent().texture
	if get_parent().texture:
		get_parent().get_node("CollisionShape2D").shape.extents = get_parent().get_node("Sprite").texture.get_size()/2

func _process(delta):
	if get_parent().texture != lastTexture:
		get_parent().get_node("Sprite").texture = get_parent().texture
		lastTexture = get_parent().texture
		if get_parent().texture:
			get_parent().get_node("CollisionShape2D").shape.extents = get_parent().get_node("Sprite").texture.get_size()/2
