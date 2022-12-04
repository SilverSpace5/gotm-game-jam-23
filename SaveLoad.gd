extends Node

func saveData(path, data):
#	if OS.is_debug_build():
#		return
	var dir = Directory.new()
	if !dir.dir_exists(path):
		dir.make_dir_recursive(path)
	
	var file = File.new()
	var error = file.open_encrypted_with_pass("user://" + path, File.WRITE, "lolidk")
	if error == OK:
		file.store_var(data)
		file.close()

func loadData(path) -> Dictionary:
	var file = File.new()
	if file.file_exists("user://" + path):
		var error = file.open_encrypted_with_pass("user://" + path, File.READ, "lolidk")
		if error == OK:
			var player_data = file.get_var()
			file.close()
			return player_data
	return {}

func deleteData(path):
	var file = File.new()
	if file.file_exists(path):
		var dir = Directory.new()
		dir.remove(path)
