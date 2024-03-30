extends Control


signal first_pause
var not_paused = true
var is_paused = false: set = set_is_paused


signal paused(show)
func _ready():
	visible = false
#	AudioServer.set_bus_volume_db(0, -80)
	$Screens.visible = false
	$Screens/Controls.visible = false
	$Screens/Options.visible = false
	$CenterContainer.visible = true
	
#	$PressedScreens/Options/AudioOptions.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
#	$PressedScreens/Options/VideoOptions.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause"):
		self.is_paused = !is_paused
		emit_signal("paused", is_paused)


func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
#	get_parent().get_node("Blur").visible = value
	visible = is_paused 
	if is_paused:
		$CenterContainer/VBoxContainer/Resume.grab_focus()
		$Screens.visible = false #this part is here to make sure wheneaver the game is paused it returns to the main screen
		$Screens/Controls.visible = false
		$Screens/Options.visible = false
		$CenterContainer.visible = true
		if not_paused and Main.tutorial_step == 6:
			not_paused = false
			emit_signal("first_pause")

func _on_resume_pressed():
	self.is_paused = false
	emit_signal("paused", is_paused)


func _on_controls_pressed():
	$CenterContainer.visible = false
	$Screens.visible = true
	$Screens/Controls.visible = true

func _on_options_pressed():
	$CenterContainer.visible = false
	$Screens.visible = true
	$Screens/Options.visible = true
	$Screens/Options/AudioSliders.set_mouse_filter(Control.MOUSE_FILTER_PASS)
	$Screens/Options/Checkboxes.set_mouse_filter(Control.MOUSE_FILTER_PASS)
	$Screens/Options/Reset.grab_focus()

func _on_menu_pressed():
	get_tree().quit()

#func _on_done_pressed():
#	$CenterContainer.visible = true
#	$PressedScreens/ColorRect.visible = false
#	$PressedScreens/Options.visible = false
#	$PressedScreens/Options/AudioOptions.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
#	$PressedScreens/Options/VideoOptions.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
#
#
func _on_resume_mouse_entered():
	$CenterContainer/VBoxContainer/Resume.grab_focus()
	$SoundFx.pitch_scale = 0.9
	$SoundFx.stream = load("res://SoundFx/ButtonMenuHover.wav")
	$SoundFx.play()
#
func _on_controls_mouse_entered():
	$CenterContainer/VBoxContainer/Controls.grab_focus()
	$SoundFx.pitch_scale = 0.9
	$SoundFx.stream = load("res://SoundFx/ButtonMenuHover.wav")
	$SoundFx.play()

func _on_options_mouse_entered():
	$CenterContainer/VBoxContainer/Options.grab_focus()
	$SoundFx.pitch_scale = 0.9
	$SoundFx.stream = load("res://SoundFx/ButtonMenuHover.wav")
	$SoundFx.play()

func _on_menu_mouse_entered():
	$CenterContainer/VBoxContainer/Menu.grab_focus()
	$SoundFx.pitch_scale = 0.9
	$SoundFx.stream = load("res://SoundFx/ButtonMenuHover.wav")
	$SoundFx.play()
#	$Screens/Controls/DoneControls.grab_focus()


func _on_done_controls_pressed():
	$Screens.visible = false
	$Screens/Controls.visible = false
	$CenterContainer.visible = true


func _on_done_options_pressed():
	$Screens.visible = false
	$Screens/Options.visible = false
	$CenterContainer.visible = true

func _on_reset_pressed():
	Main.master_value = 0
	Main.music_value = -12
	Main.ambience_value = 0
	Main.fullscreen = true
	Main.vsync = true
	$Screens/Options/AudioSliders/Master.value = 0
	$Screens/Options/AudioSliders/Music.value = -12
	$Screens/Options/AudioSliders/Ambient.value = 0
	$Screens/Options/Checkboxes/Fullscreen.button_pressed = true
	$Screens/Options/Checkboxes/Vsync.button_pressed = true

