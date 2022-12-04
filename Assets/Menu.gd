extends Control
 
func _on_Play_pressed():
	get_tree().change_scene("res://Game.tscn")

func _on_Credits_pressed():
	$UI/Menu.visible = false
	$UI/Credits.visible = true

func _on_Back_pressed():
	$UI/Menu.visible = true
	$UI/Credits.visible = false

func _ready():
	var data = SaveLoad.loadData("team-sowflux-the-2-goblins.data")
	if data.has("mute"):
		Music.mute = data["mute"]
