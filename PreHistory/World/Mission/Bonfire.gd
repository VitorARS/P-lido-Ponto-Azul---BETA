extends Node2D

signal bonfire_entered

func _on_bonfire_body_entered(body):
	if body.name == "Player": 
		Main.player.current_state = 0
		Main.player.set_able_to_input(false)
		Dialogue.set_visibility(true)
		$Bonfire/CollisionShape2D.set_deferred("disabled", true)
		Dialogue.add_dialogue(Main.player.interaction, 0, "Seigan", "",true, false)
		Dialogue.add_dialogue(Main.player.interaction, 1, "Seigan", "", false, true)
		emit_signal("bonfire_entered")

