extends Control

signal stop_soundtrack
signal return_soundtrack

var default_text = "               Porém, durante essa jornada, Seigan "
var death_causes= ["Crab", "Starvation", "Bee"]
var death_texts = [ "foi mordido por um carangueijo e morreu.", "não conseguiu encontrar comida e morreu.", "tentou roubar o doce mel das abelhas e acabou recebendo o amargo sabor dos ferrões."]

func _ready():
	visible = true
	$Anim.play("Die")
#	emit_signal("stop_soundtrack")
	await $Anim.animation_finished
	var text_index = death_causes.find(Main.death_cause)#
	if text_index == -1:
		print("error: cause of death not found...")
	else:
		$EndLabel.set_text(default_text + death_texts[text_index])
		$EndLabel.visible_ratio = 0
		var tween = create_tween()
		tween.tween_property($EndLabel, "visible_ratio", 1 , len(default_text + death_texts[text_index]) * 0.025)
		await tween.finished
		tween.stop()
		$Decision.visible = true
		$Decision.modulate = Color(1,1,1,0)
		var tween2 = create_tween()
		tween2.tween_property($Decision, "modulate", Color(1,1,1,1), 1.5)

func _on_no_pressed():
	Main.player.global_position = Main.spawn_position
	$Anim.play("Returning")
	Main.player.reset_after_dying()
	emit_signal("return_soundtrack")
	await $Anim.animation_finished
	if Main.mission_step == 2:
		Main.anaje.emit_signal("emit_warning", 1)
	queue_free()

func _on_yes_pressed():
	get_tree().quit()

