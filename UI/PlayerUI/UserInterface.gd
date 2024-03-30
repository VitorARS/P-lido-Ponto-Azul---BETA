extends CanvasLayer
#User Interface !Theres more to it!
@onready var mission = $Mission

func _ready():
	Main.set("user_interface", self)
	visible = true


func _unhandled_input(event):
	if Input.is_action_just_pressed("t"): # and countdown_finished == true
		if $KnowledgeTree/Control.visible:
			$KnowledgeTree.exit()
		else:
			$KnowledgeTree._on_button_icon_pressed()
			
	elif Input.is_action_just_pressed("g"): # and countdown_finished == true
		$Mission._on_texture_button_pressed()
	elif Input.is_action_pressed("ui_text_scroll_up"):
		PlayerInventory.active_item_scroll_up()
	elif Input.is_action_pressed("ui_text_scroll_down"):
		PlayerInventory.active_item_scroll_down ()

	elif Input.is_action_pressed("1"):
		PlayerInventory.active_item_slot = 0
		PlayerInventory.emit_signal("active_item_updated")
	elif Input.is_action_pressed("2"):
		PlayerInventory.active_item_slot = 1
		PlayerInventory.emit_signal("active_item_updated")
	elif Input.is_action_pressed("3"):
		PlayerInventory.active_item_slot = 2
		PlayerInventory.emit_signal("active_item_updated")
	elif Input.is_action_pressed("4"):
		PlayerInventory.active_item_slot = 3
		PlayerInventory.emit_signal("active_item_updated")
	elif Input.is_action_pressed("5"):
		PlayerInventory.active_item_slot = 4
		PlayerInventory.emit_signal("active_item_updated")
	elif Input.is_action_pressed("6"):
		PlayerInventory.active_item_slot = 5
		PlayerInventory.emit_signal("active_item_updated")
	elif Input.is_action_pressed("7"):
		PlayerInventory.active_item_slot = 6
		PlayerInventory.emit_signal("active_item_updated")
	elif Input.is_action_pressed("8"):
		PlayerInventory.active_item_slot = 7
		PlayerInventory.emit_signal("active_item_updated")


func _on_pause_menu_paused(show):
	$Blur.visible = show


func _on_amulet_area_entered(area):
	var portrait_scene = load("res://UI/Portrait.tscn") #add future feature in which you can set the texture
	var portrait_instance = portrait_scene.instantiate()
	call_deferred("add_child", portrait_instance)
	

func on_player_death():
	var gameover_scene = load("res://UI/GameOver.tscn")
	var new_gameover_instance = gameover_scene.instantiate()
	call_deferred("add_child", new_gameover_instance)

func on_emit_warning(text_index):
	var warning_scene = load("res://UI/MissionWarning.tscn")
	var new_warning_instance = warning_scene.instantiate()
	call_deferred("add_child", new_warning_instance)
	new_warning_instance.set_text(text_index)

func on_free_warning():
	get_node("MissionWarning").queue_free()
