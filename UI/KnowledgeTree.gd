extends Control

signal first_artefact
signal knowledge_tree_completed
var tree_slots
var slots
var locked_slot = load("res://UI/Sprites/KnowledgeTree/ArtefactsSlotLocked.png")
var obtained_texture = load("res://UI/Sprites/Artefacts/ObtainedSlot.png")
var first_enter = true
var got_first_artefact = false 
var got_first_artefact_tip = false #create another to avoid confusion, this is for extra tips
var had_explanation = false #wheater he has seen the $firstartefactprompt or not
var first_slot_index

func _ready():
	$Control.visible = false
	$Blur.visible = false
	$Welcome.visible = false
	$Control/InformativeMaterial.visible = false
	$FirstArtefact.visible = false
	$Info.visible = false
#	$Slots/ParchmentsIcon.visible = false
	tree_slots = $Control/Slots
	slots = $Control/Slots.get_children()
#	$Introduction/ClickIcon.stop()
#	$Introduction/IntroIcon.stop()
#	$Introduction.visible = false
	for i in range(slots.size()):
		if slots[i].locked:
			slots[i].item_texture.set_texture(locked_slot)
			slots[i].item_texture.modulate = Color(1,1,1,1)
#			slots[i].remove_theme_stylebox_override("panel")
			slots[i].label.set_text("")

func _on_artefact_collected(art_name, id): #Called from artefac
	if !got_first_artefact and !had_explanation:
		first_slot_index = id
		got_first_artefact = true
	if !got_first_artefact_tip and !Main.on_tutorial:
		got_first_artefact_tip = true
		emit_signal("first_artefact")
		
	$ArtefactAlert.show_alert(art_name)
	slots[id].item_texture.modulate = Color(1,1,1)
	slots[id].texture_normal = obtained_texture
	slots[id].disabled = false
	$Sound.stream = load("res://SoundFx/NewArtefact.wav")
	$Sound.pitch_scale = 1
	$Sound.play()

func on_connect_slot(slot_index, slot_name):
	if got_first_artefact and had_explanation:
		$FirstArtefact.visible = false
		slots[first_slot_index].z_index = 1
	slot_index -= 1 #because for arrays it stats at 0
	$Control/Quit.visible = false
	$Control/InformativeMaterial.set_info_material(slot_index,slot_name )
	$Control/InformativeMaterial.visible = true
	

func _on_button_icon_pressed():
	$Sound.stream = load("res://SoundFx/QuitButton.wav")
	$Sound.pitch_scale = 1.2
	$Sound.play()
	$Control.visible = !$Control.visible
	$Blur.visible = !$Blur.visible
	$ButtonIcon.disabled = true
	$Info.visible = false
	if got_first_artefact and !had_explanation:
		$FirstArtefact/Arrow.position = slots[first_slot_index].position + Vector2(-16, 16)
		$FirstArtefact/Arrow.play("default")
		$FirstArtefact.visible = true
		$Control/Quit.visible = false
		had_explanation = true
		first_enter = false #just to avoid getting info two times
		slots[first_slot_index].z_index = 3
		emit_signal("knowledge_tree_completed")
	else:
		if first_enter:
			first_enter = false
			$Welcome.visible = true
			$Control/Quit.visible = false
			emit_signal("knowledge_tree_completed")#ExtraTips
		else:
			$Welcome.visible = false
			$Control/Quit.visible = true

func _on_confirm_button_pressed():
	$Welcome.visible = false
	$Control/Quit.visible = true

func _on_return_pressed():
	$Control/InformativeMaterial.visible = false
	$Control/Quit.visible = true

func _on_quit_pressed():
	$Control.visible = false
	$Blur.visible = false
	$ButtonIcon.disabled = false
	$Sound.stream = load("res://SoundFx/QuitButton.wav")
	$Sound.pitch_scale = 1
	$Sound.play()

func exit():
	$Sound.stream = load("res://SoundFx/QuitButton.wav")
	$Sound.pitch_scale = 1
	$Sound.play()
	$Control.visible = false
	$Blur.visible = false
	$Welcome.visible = false
	$Control/InformativeMaterial.visible = false
	$FirstArtefact.visible = false
	$Info.visible = false
	$ButtonIcon.disabled = false


func _on_button_icon_mouse_entered():
	$Info.visible = true

func _on_button_icon_mouse_exited():
	$Info.visible = false
