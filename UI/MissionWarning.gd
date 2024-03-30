extends Control

var warnings = ["Ei garoto, não perca o foco da missão!", "Vamos lá! Nem pense em desistir!", "Muito bem! este é o fim da versão BETA :)"]
var new_timer:= Timer.new()

func set_text(text_index):
	$DialogueBox/Label.set_text(warnings[text_index])
	if text_index == 2 or text_index == 1:
		add_child(new_timer)
		new_timer.wait_time = 1
		new_timer.autostart = true
		new_timer.one_shot = true
		new_timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(0,0,0,0), 3.5)
	await tween.finished
	queue_free()



