extends Area2D

var player = null 
var limit_position = 10000




func _on_body_entered(body):
	if body.name == "Player":
		var crab = get_parent()
		crab.find_closest_den()
		player = body


	
func can_see_player():
	return player != null


func _on_body_exited(body):
	player = null

