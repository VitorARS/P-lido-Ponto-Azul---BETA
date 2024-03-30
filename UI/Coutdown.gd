extends Control

@onready var years_label = $Years


signal countdown_finished
var holder_timer = 5
var years = 0
var increasing_rate = 333

func _ready():
	if Main.debug_version:
		queue_free()
	else:
		$Timer.start()

func _on_timer_timeout():
	if years <= 9999:
		years += increasing_rate
		years_label.text = "0" + str(years)

	elif years > 9999 and years <= 12000:
		years += increasing_rate
		years_label.text = str(years)
	
	elif years > 12000:
		$Timer.stop()
		years_label.text = str(12000)
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(1,1,1,0), 2)
		await tween.finished
		queue_free()
		emit_signal("countdown_finished")
