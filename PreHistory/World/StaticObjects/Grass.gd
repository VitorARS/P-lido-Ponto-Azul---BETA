extends StaticBody2D

@onready var sprite = $Texture
@onready var chunk = get_parent()

func _on_area_2d_body_entered(body):
	sprite.play("Moving")

func _on_Area2D_body_exited(body):
	var wait_time = randf_range(2, 4.5)
	var tween = create_tween()
	tween.tween_property(sprite, "speed_scale", 0.5, wait_time)
	await get_tree().create_timer(wait_time).timeout
	sprite.stop()
	sprite.speed_scale = 1

func create_grassfx():
	var GrassFx = load("res://PreHistory/World/StaticObjects/GrassFx.tscn")
	var grassFxInstance = GrassFx.instantiate()
	chunk.add_child(grassFxInstance)
	grassFxInstance.global_position = global_position


func _on_hurtbox_area_entered(area):
	create_grassfx()
	queue_free()


