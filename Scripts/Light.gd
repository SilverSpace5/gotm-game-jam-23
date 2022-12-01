extends Sprite
tool

export (float) var energy = 1
export (Color) var colour = Color(1, 1, 1)
var lastEnergy = 1
var lastColour = Color(1, 1, 1)

func _process(delta):
	if energy != lastEnergy:
		lastEnergy = energy
		material.set_shader_param("energy", energy)
	if colour != lastColour:
		lastColour = colour
		#modulate = colour
		material.set_shader_param("colour", colour)
