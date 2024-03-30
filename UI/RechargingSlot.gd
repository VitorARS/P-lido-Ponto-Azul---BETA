extends AnimatedSprite2D


func _ready():
	frame = 0
	
func _on_animation_finished():
	Main.allowed_to_attack = true
	queue_free()
