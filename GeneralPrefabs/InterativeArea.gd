
class_name interactable extends Area2D

signal set_interaction(int_text)# connect via tree
signal toggle_visibility(boolean)# connect via tree
@export var interaction_type: String
@export var interaction_text: String
@export var lupa_pos: Vector2
@export var xp_value: int

signal on_first_enter
var first_collected = true
signal on_first_collected
var has_entered = false
var box_visible = false
var area_names= []
func _ready():
	$LupaSign.modulate = Color(0,0,0,0)
	area_names.push_front(name)


func _on_area_entered(area):
	if first_collected and Main.on_tutorial == false:
		first_collected = false
		connect("on_first_collected", Callable(Main.user_interface.get_node("ExtraTips"), "on_interactables_completed" ))
		emit_signal("on_first_collected")
	if area.name == "InteractionArea": #in player
		if !has_entered:
			emit_signal("set_interaction", interaction_text) 
			has_entered = true
			box_visible = true
			if area_names.has(name): #check if its first time
				Main.emit_signal("xp", xp_value)
				area_names.erase(name)

		elif has_entered:
			emit_signal("toggle_visibility", !box_visible)
			box_visible = !box_visible
	

func _on_body_entered(body):
	if body.name == "Player":
		if !Main.got_first_interaction and !Main.on_tutorial:
			connect("on_first_enter", Callable(Main.user_interface.get_node("ExtraTips"), "set_interactables" ))
			Main.got_first_interaction = true
			emit_signal("on_first_enter")
		Main.player.able_to_interact = true
		$LupaSign.position = lupa_pos
		var tween = create_tween()
		tween.tween_property($LupaSign, "modulate", Color(1,1,1,1), 0.35)

func _on_body_exited(body):
	if body.name == "Player":
		Main.player.able_to_interact = false
		var tween = create_tween()
		tween.tween_property($LupaSign, "modulate", Color(0,0,0,0), 0.35)
		emit_signal("toggle_visibility", false)
		box_visible = false
