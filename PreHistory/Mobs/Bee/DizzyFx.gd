extends AnimatedSprite2D


func _ready():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 8)
	var num_nodes = get_parent().get_child_count()
	await tween.finished
	if num_nodes < get_parent().get_child_count(): #this logic here verifies if another dizzy fx was added to the bee
		return
	else:
		get_parent().set_physics_process(true)
		get_parent().hitbox.set_deferred("disabled", false)
	call_deferred("free")
