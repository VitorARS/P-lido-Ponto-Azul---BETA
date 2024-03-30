extends Area2D

var bee
var bees = {}

func _on_area_entered(area):
	if area.name == "Hurtbox":
		var bee_index = (area.get_parent().name)
		bees[bee_index] = area.get_parent()
		bees[bee_index].set_physics_process(false)
		bees[bee_index].hitbox.set_deferred("disabled", true)
		var new_dizzy_fx = load("res://PreHistory/Mobs/Bee/DizzyFx.tscn")
		var dizzy_fx_instance = new_dizzy_fx.instantiate()
		bees[bee_index].call_deferred("add_child", dizzy_fx_instance) 
#		dizzy_fx_instance.global_position = global_position


func _on_animation_player_animation_finished(anim_name):
#	if bees.size() > 0:
#		for key in bees: #for  i in range(1, (bees.size()+1)):
#			if !bees[key].dizzy:
#				bees[key].set_physics_process(true)
#				bees[key].hitbox.set_deferred("disabled", false)
	queue_free()
