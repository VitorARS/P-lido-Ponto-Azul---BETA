extends StaticBody2D

@onready var ysort = get_parent()
@export var empty_path: String
@export var default_path: String
@export var item: String

signal first_take

func _ready():
	$Plus.visible = false

func _on_detection_zone_body_entered(body):
	if body.name == "Player":
		body.set_taking("Collect")
		var tween = create_tween()
		$Plus.visible = true
		tween.tween_property($Plus, "modulate", Color(1,1,1,1), 0.35)

func _on_detection_zone_body_exited(body):
	if body.name == "Player":
		body.in_collect_area = false
		body.take_type  = null
		var tween = create_tween()
		tween.tween_property($Plus, "modulate", Color(0,0,0,0), 0.35)
		await tween.finished
		$Plus.visible = false

func _on_collect_hurtbox_area_entered(area):
	$CollectHurtbox/CollisionShape2D.set_deferred("disabled", true)
	$DetectionZone/CollisionShape2D.set_deferred("disabled", true)
	$Texture.texture = load(empty_path)
	$Plus.visible = false
	PlayerInventory.add_item(item, 1)
	$Reset.start()

func _on_reset_timeout():
	$CollectHurtbox/CollisionShape2D.set_deferred("disabled", false)
	$DetectionZone/CollisionShape2D.set_deferred("disabled", false)
	$Texture.texture = load(default_path)



