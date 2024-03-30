extends StaticBody2D

@onready var ysort = get_parent()
signal honey_collected
var bee_number = 0
var max_bees = 6
var indexes = ["1","2","3","4","5","6"]
var player
var allowed_to_return = true # allow bees to return to hive, will be false if hive is under attack

func _ready():
	instance_bee(4)

func instance_bee(repeat_num):
	for i in range(repeat_num):
		if max_bees >= bee_number + 1: 
			var New_bee = load("res://PreHistory/Mobs/Bee/Bee.tscn")
			var new_beeInstance = New_bee.instantiate()
			$Bees.call_deferred("add_child", new_beeInstance)
			new_beeInstance.position = Vector2(30, -60)
			new_beeInstance.name = "Bee" + indexes.pop_front()
			bee_number += 1
			
		else:
			return




func _on_Area2D_body_entered(body):
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0.5), 0.35)


func _on_Area2D_body_exited(body):
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,1), 0.35)

func _on_timer_timeout():
	$Timer.start(5 * bee_number)
	if bee_number <= max_bees:
		instance_bee(1)

func on_bee_entered(bee_name):
	bee_number -= 1
	var bee_index = bee_name.erase(0, 3) #takes of "bee" from the name
	indexes.push_back(bee_index)


func _on_player_detection_swarm_body_entered(body):
	if body.name == "Player":
		instance_bee( max_bees - bee_number)
		var New_beehive = load("res://PreHistory/World/Mission/Beehive.tscn")
		var new_beehiveInstance = New_beehive.instantiate()
		call_deferred("add_child", new_beehiveInstance)
		new_beehiveInstance.position = Vector2(0,0)


func _on_overall_player_detection_body_entered(body):
	if body.name == "Player": 
		allowed_to_return = false #now bees cannot return to beehive, theyare in alert

func _on_overall_player_detection_body_exited(body):
	if body.name == "Player":
		allowed_to_return = true


func _on_player_detection_swarm_body_exited(body):
		if get_node("Beehive") != null: #just to check
			get_node("Beehive").queue_free()
