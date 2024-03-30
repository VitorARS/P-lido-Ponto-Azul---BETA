extends StaticBody2D

@onready var texture = $Sprite2D
@onready var blink_texture = $Blink
@export var index: int
@export var has_anim: bool
signal artefact_collected(art_name, id)

signal first_artefact_encountered

func _ready():
	$Plus.visible = false
	texture.texture = load("res://PreHistory/World/Artefacts/" + str(name) + ".png")
	blink_texture.texture = load("res://PreHistory/World/Artefacts/" + str(name) + "Blink.png")
	if has_anim:
		connect("artefact_collected", Callable(Main.user_interface.get_node("KnowledgeTree"), "_on_artefact_collected")) #in a artefact that is already in tree this is connected via tree signals
		$Blink.visible = false
		$Anim.play(name)
		await $Anim.animation_finished
		$Blink.visible = true
		$BlinkAnim.play("Blink")
	else:
		$BlinkAnim.play("Blink")

func _on_detect_zone_body_entered(body):
	if body.name == "Player":
		#and Main.player.able_taking == false: Do not understand the necessity of verifing it
		if !Main.got_first_artefact and !Main.on_tutorial:
			Main.got_first_artefact = true
			connect("first_artefact_encountered", Callable(Main.user_interface.get_node("ExtraTips"), "set_artefact"))
			emit_signal("first_artefact_encountered")
		Main.player.set_taking("TakeDown") #in_collect_area turns to true in this function
		var tween = create_tween()
		tween.tween_property($Plus, "modulate",Color(1,1,1,1), 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		$Plus.visible = true


func _on_detect_zone_body_exited(body):
	if body.name == "Player":
		Main.player.in_collect_area = false
		var tween = create_tween()
		tween.tween_property($Plus, "modulate",Color(0,0,0,0), 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		



func _on_hurtbox_area_entered(area):
	print("emitting")
	Main.player.in_collect_area = false
	Main.emit_signal("xp", 25)
	emit_signal("artefact_collected", name, index)
	queue_free()
