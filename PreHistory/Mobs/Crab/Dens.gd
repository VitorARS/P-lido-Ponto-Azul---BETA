extends Node2D


var positions: Array
func _ready():
	for den in get_children():
		positions.push_back(den.position)



