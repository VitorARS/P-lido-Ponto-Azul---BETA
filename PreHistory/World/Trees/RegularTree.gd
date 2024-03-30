extends StaticBody2D

#@onready var ysort = get_parent()

func _on_area_2d_body_entered(body):
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0.5), 0.35)


func _on_area_2d_body_exited(body):
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,1), 0.35)
