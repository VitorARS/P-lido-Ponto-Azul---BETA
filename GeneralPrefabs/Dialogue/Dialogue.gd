extends CanvasLayer

@onready var dialogue_box = $Control/DialogueBox
@onready var label = $Control/DialogueBox/BodyText
@export var interaction: Array[String]
var CHAR_READ_RATE = 0.025
var display_text:String
var msgs = []
var characters = []
var moods = []
var indexes = []
var acts = []
var current_index

var finished = false
signal fire_minigame
signal queue_self
signal set_blur(value)

func _ready():
	set_process_input(false)
	if Main.debug_version == false:
		CHAR_READ_RATE = 0.025 
	else:
		CHAR_READ_RATE = 0.01
	$ColorRect.visible = false
	label.text = " "
	label.visible_ratio = 0
#	dialogue_box.visible = false
	dialogue_box.modulate = Color(0,0,0,0)

func _input(event):
	if Input.is_action_pressed("move_forward"):
		if finished:
			finished = false
			if msgs.size() > 0: #WRITESTUFF
	#			if label.visible_ratio < 1 and label.visible_ratio > 0: #theres already text and u want to jump
	#				print("SKKIIPP")
				add_message(msgs.pop_front(), indexes.pop_front(), characters.pop_front(), moods.pop_front())
				
			else:
				set_visibility(false)
				
			if  acts.pop_front() == true:
				match Main.player.acts:
					1:
						Main.player.act1()
					2:
						$Anim.play("TransitionIN")
						await $Anim.animation_finished
						Main.player.position = Vector2(665, -480)
						Main.spawn_position = Vector2(665, -480)
						Main.player.hurtbox.set_collision_mask_value(8, false) #avoid bees
						Main.anaje.position = Vector2(640, -450)
						Main.anakin.position = Vector2(630, -420)
						Main.calian.position = Vector2(600, -430)
						$Anim.play("TransitionOUT")
						set_visibility(true)
						add_dialogue(Main.anaje.interaction, 5, "Anajé", "Happy",true, false)
						add_dialogue(Main.anakin .interaction, 0, "Anakin", "",false, false)#HAppy
						add_dialogue(Main.calian.interaction, 0, "Calian", "",false, false) 
						add_dialogue(Main.anaje.interaction, 6 , "Anajé", "",false, true)
					3:
						Loader.allowed_to_load = true
						Loader.instance_scene_above(Main.user_interface, "fire_minigame") # icon instanciated in dialogue autoload
					4:
						set_visibility(true)
						emit_signal("set_blur", false)
						add_dialogue(Main.anakin.interaction, 1, "Anakin", "",true, false)
						add_dialogue(Main.anaje.interaction, 8, "Anajé", "",false, true)

					5:
						Main.anakin.stop_wander = false
						Main.anakin.target_position = Vector2(496, -64)
						Main.anakin.set_state(3)
						set_visibility(true)
						add_dialogue(Main.anaje.interaction, 9, "Anajé", "",true, false)
						add_dialogue(Main.anaje.interaction, 10, "Anajé", "",false, false)
						add_dialogue(Main.anaje.interaction, 11, "Anajé", "",false, true)
					6:
						PlayerInventory.add_item("Tocha", 1)
						Main.user_interface.mission.mission_completed()
						Main.player.set_able_to_input(true)
						Main.player.set_physics_process(true)
						Main.player.set_state(0)
						Main.player.hurtbox.set_collision_mask_value(8, true)
						Main.anaje.mission_collision.disabled = false
						Main.anaje.connect("bee_mission",Callable(Main.anaje.get_parent().soundtrack, "on_bee_mission"))
						Main.anaje.emit_signal("bee_mission")



func add_dialogue(msg, index, character, mood, allowed:bool, act:bool): #Allowed is the first message
	if act == true:
		Main.player.acts += 1
		print("one more act")

	msgs.push_back(msg)
	indexes.push_back(index)
	characters.push_back(character)
	moods.push_back(mood)
	acts.push_back(act)
	if allowed:
		add_message(msgs.pop_front(), indexes.pop_front(), characters.pop_front(), moods.pop_front())
	
func add_message(_msg: Array,index, character, mood):
	if not dialogue_box.visible:
		set_visibility(true)
	$Control/DialogueBox/Character.text = character
	$Control/DialogueBox/Portrait.texture = load("res://GeneralPrefabs/Dialogue//Portraits/"+ String(character)+ String(mood) + ".png")
	Main.player.current_dialogue += 1
	display_text = _msg[index]
	show_message()

func show_message():
	label.visible_ratio = 0
	label.text = "[p][/p] [center]" + display_text + "[/center]"
	write_text()

func write_text():
	var tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1 , len(label.text) * CHAR_READ_RATE)
	await tween.finished
	finished = true
	
	
#	if tween.is_running():
#		return true
#	else:
#		return false

func set_visibility(showing: bool):
	var visibility
	if !showing:
		visibility = Color(0,0,0,0)
		set_process_input(false)
	else:
		visibility = Color(1,1,1,1)
		set_process_input(true)
	var tween = create_tween()
	tween.tween_property(dialogue_box, "modulate", visibility , 1)
