extends Control

var able_skip = true

func _ready():
	$Anim.play("Begin")
	if Main.debug_version == false:
		$Soundtrack.play()

func _input(event):
	if Input.is_action_just_pressed("move_forward") and able_skip:
		$Anim.play("Skip")
		able_skip = false

func admit_skip(): #called at beggining of "Skip" anim and end of "Begin"
	able_skip = false
	$Main/Buttons/HBox/Play.grab_focus()

func _on_play_mouse_entered():
	$SoundFx.pitch_scale = 0.9
	$SoundFx.stream = load("res://SoundFx/ButtonMenuHover.wav")
	$SoundFx.play()
	$Main/Buttons/HBox/Play.grab_focus()


func _on_play_focus_entered():
	$SoundFx.pitch_scale = 0.9
	$SoundFx.stream = load("res://SoundFx/ButtonMenuHover.wav")
	$SoundFx.play()
	$Main/Buttons/HBox/Play.grab_focus()

func _on_options_mouse_entered():
	$SoundFx.pitch_scale = 0.9
	$SoundFx.stream = load("res://SoundFx/ButtonMenuHover.wav")
	$SoundFx.play()
	$Main/Buttons/HBox/Options.grab_focus()

func _on_options_focus_entered():
	$SoundFx.pitch_scale = 0.9
	$SoundFx.stream = load("res://SoundFx/ButtonMenuHover.wav")
	$SoundFx.play()
	$Main/Buttons/HBox/Options.grab_focus()


func _on_know_more_mouse_entered():
	$SoundFx.pitch_scale = 0.9
	$SoundFx.stream = load("res://SoundFx/ButtonMenuHover.wav")
	$SoundFx.play()
	$Main/Buttons/HBox/KnowMore.grab_focus()

func _on_know_more_focus_entered():
	$SoundFx.pitch_scale = 0.9
	$SoundFx.stream = load("res://SoundFx/ButtonMenuHover.wav")
	$SoundFx.play()
	$Main/Buttons/HBox/KnowMore.grab_focus()


func _on_know_more_return_mouse_entered():
	$SoundFx.pitch_scale = 1.2
	$SoundFx.stream = load("res://SoundFx/ButtonMenuHover.wav")
	$SoundFx.play()

func _on_options_return_mouse_entered():
	$SoundFx.pitch_scale = 1.2
	$SoundFx.stream = load("res://SoundFx/ButtonMenuHover.wav")
	$SoundFx.play()
	
#------------Main Menu-----------#
func _on_play_pressed():
	$Anim.play("Play")
	$Play/LevelButtons/PreHistory.grab_focus()
	$SoundFx.pitch_scale = 1
	$SoundFx.stream = load("res://SoundFx/ButtonMenuPressed.wav")
	$SoundFx.play()

func _on_play_return_pressed():
	$Anim.play_backwards("Play")
	$Main/Buttons/HBox/Play.grab_focus()

func _on_know_more_pressed():
	$Anim.play("KnowMore")
	$KnowMore/Info/Return.grab_focus()
	$SoundFx.pitch_scale = 1
	$SoundFx.stream = load("res://SoundFx/ButtonMenuPressed.wav")
	$SoundFx.play()
	
func _on_know_more_return_pressed():
	$Anim.play_backwards("KnowMore")
	$Main/Buttons/HBox/Play.grab_focus()

func _on_options_pressed():
	$Anim.play("Options")
	$Options/Return.grab_focus()
	$SoundFx.pitch_scale = 1
	$SoundFx.stream = load("res://SoundFx/ButtonMenuPressed.wav")
	$SoundFx.play()

func _on_options_return_pressed():
	$Anim.play_backwards("Options")
	$Main/Buttons/HBox/Play.grab_focus()


func _on_pre_history_pressed():
	$Play/LevelButtons/PreHistory.disabled = true #avoid two clicks
	$SoundFx.pitch_scale = 0.8
	#$SoundFx.stream = load("res://SoundFx/ButtonMenuPressed.wav")
	$SoundFx.play()
	#TODO: block the button(s) to input
	Loader.allowed_to_load = true
	Loader.load_scene_without_screen(self, "cutscene")
	#$OverallButtons/Buttons/Hbox/Jogar.grab_focus()






