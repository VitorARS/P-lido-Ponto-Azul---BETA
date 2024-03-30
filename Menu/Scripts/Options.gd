extends Control

@onready var sound_fx = get_parent().get_parent().get_node("SoundFx")
var new_timer := Timer.new()

func _ready():
	sound_fx.volume_db = -80
	$AudioSliders/Master.value = Main.master_value
	$AudioSliders/Music.value = Main.music_value
	$AudioSliders/Ambient.value = Main.ambience_value
	$Checkboxes/Fullscreen.button_pressed = Main.fullscreen
	$Checkboxes/Vsync.button_pressed =  Main.vsync
	$Checkboxes/FullscreenChecked.visible = Main.fullscreen
	$Checkboxes/VsyncChecked.visible =  Main.vsync
	add_child(new_timer)
	new_timer.wait_time = 1
	new_timer.one_shot = true
	new_timer.start()
	new_timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_timer_timeout() -> void:
	sound_fx.volume_db = 0
	new_timer.queue_free()


func _on_master_drag_started():
	sound_fx.pitch_scale = 1.1
	sound_fx.stream = load("res://SoundFx/OptionsCheckBoxes.wav")
	sound_fx.play()

func _on_master_value_changed(value):
	set_volume(0, value)

func _on_master_drag_ended(_value_changed): #i used this signal to update the value just as you release it
	Main.master_value = $AudioSliders/Master.value

func _on_music_drag_started():
	sound_fx.pitch_scale = 1.1
	sound_fx.stream = load("res://SoundFx/OptionsCheckBoxes.wav")
	sound_fx.play()

func _on_music_value_changed(value):
	set_volume(1, value)

func _on_music_drag_ended(value_changed):
	Main.music_value = $AudioSliders/Music.value

func _on_ambient_drag_started():
	sound_fx.pitch_scale = 1.1
	sound_fx.stream = load("res://SoundFx/OptionsCheckBoxes.wav")
	sound_fx.play()

func _on_ambient_value_changed(value):
	set_volume(2, value)

func set_volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, value)

func _on_ambient_drag_ended(value_changed):
	Main.ambience_value = $AudioSliders/Ambient.value
	
func _on_fullscreen_toggled(button_pressed):
	$Checkboxes/FullscreenChecked.visible = button_pressed
	Main.fullscreen = button_pressed
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	sound_fx.pitch_scale = 1
	sound_fx.stream = load("res://SoundFx/OptionsCheckBoxes.wav")
	sound_fx.play()

func _on_vsync_toggled(button_pressed):
	$Checkboxes/VsyncChecked.visible = button_pressed
	Main.vsync = button_pressed
	if button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	sound_fx.pitch_scale = 1
	sound_fx.stream = load("res://SoundFx/OptionsCheckBoxes.wav")
	sound_fx.play()











