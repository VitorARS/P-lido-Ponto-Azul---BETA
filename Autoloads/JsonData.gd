extends Node

var item_data:  Dictionary
var fight_dialogue: Dictionary


func _ready():
	item_data = LoadData("res://Data/item_data.json")
 
func LoadData(file_path):
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parse_result = JSON.parse_string(data_file.get_as_text())
		if parse_result is Dictionary:
			return parse_result
		else:
			print("wrong type of file!")
	else:
		print("json file not exists!")
