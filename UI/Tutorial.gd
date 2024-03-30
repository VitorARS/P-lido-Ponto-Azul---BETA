extends Control



func _ready():
	set_move()
	$TextureProgressBar.value = 0
func set_move(): 
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,1), 0.5)
	$TextBoxContent/Keys/Key1/Label.text = "A"
	$TextBoxContent/Keys/Key2/Label.text = "D"
	$TextBoxContent/Keys/Key3/Label.text = "S"
	$TextBoxContent/Keys/Key4/Label.text = "W"
	$TextBoxContent/Title.text = "Primeiros Passos:"
	$TextBoxContent/Body.text = "Use W,A,S e D ou as teclas direcionais para se mover"
#	Main.player.set_physics_process(true)

func _on_player_first_move():
	update_text(20)

func _on_player_first_roll():
	update_text(40)

func _on_player_first_take():
	update_text(60)

func _on_player_first_eat():
	update_text(80)
	
func _on_hotbar_first_navigate():
	update_text(100)

func _on_mission_first_open():
		update_text(120)

func _on_pause_first_open():
		update_text(140)

func update_text(bar_value):
	Main.tutorial_step += 1
	$Sound.stream = load("res://SoundFx/TutorialBar.wav")
	$Sound.play()
	var tween = create_tween()
	tween.tween_property($TextureProgressBar, "value", bar_value, 0.5)
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_property($TextBoxContent, "modulate", Color(0,0,0,0), 0.5)
	await tween2.finished
	match Main.tutorial_step:
		1:
			set_roll()
		2:
			set_take()
		3:
			set_eat()
		4:
			set_hotbar()
		5:
			set_mission()
		6:
			set_pause()
		7:
			close()

func set_roll():
	$AnimationPlayer.play("Roll")
	$TextBoxContent/Title.text = "Movimentos Ágeis"
	$TextBoxContent/Body.text = "Você também pode pressionar <R> para dar uma cambalhota."
	$TextBoxContent/Keys/Key1/Label.text = "R"
	$TextBoxContent/Arrow.play("default")
	var tween = create_tween()
	tween.tween_property($TextBoxContent, "modulate", Color(1,1,1,1), 1)

func set_take():
	$AnimationPlayer.play("Take")
	$TextBoxContent/Title.text = "Olá Mundo!"
	$TextBoxContent/Body.text = "Muito bem! Agora vá até um arbusto, e pressione <E> para coletar suas frutas."
	$TextBoxContent/Keys/Key1/Label.text = "E"
	$TextBoxContent/Arrow.play("default")
	var tween = create_tween()
	tween.tween_property($TextBoxContent, "modulate", Color(1,1,1,1), 1)

func set_eat():
	$AnimationPlayer.play("Eat")
	$TextBoxContent/Title.text = "Repondo as energias"
	$TextBoxContent/Body.text = "Ótimo! para continuar, pressione <F> para come-las."
	$TextBoxContent/Keys/Key1/Label.text = "F"
	var tween = create_tween()
	tween.tween_property($TextBoxContent, "modulate", Color(1,1,1,1), 1)

func set_hotbar():
	$AnimationPlayer.play("Hotbar")
	$TextBoxContent/Keys/Key1/Label.text = "1"
	$TextBoxContent/Keys/Key2/Label.text = "2"
	$TextBoxContent/Keys/Key3/Label.text = "8"
	$TextBoxContent/Dots.text = "..."
	$TextBoxContent/Title.text = "Guia do Mochileiro"
	$TextBoxContent/Body.text = "Quase lá! Experimente navegar pelo inventário com as teclas 1 a 8 ou com o scroll do mouse."
	var tween = create_tween()
	tween.tween_property($TextBoxContent, "modulate", Color(1,1,1,1), 1)

func set_mission():
	$AnimationPlayer.play("Mission")
	$TextBoxContent/Title.text = "O seu guia"
	$TextBoxContent/Body.text = "Se você alguma vez se sentir perdido, clique no ícone amarelo (ou pressione G) para abrir aba de missões e ver seu objetivo atual. "
	$TextBoxContent/Dots.text = "ou"
	$TextBoxContent/Keys/Key1/Label.text = "G"
	var tween = create_tween()
	tween.tween_property($TextBoxContent, "modulate", Color(1,1,1,1), 1)

func close():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(0,0,0,0), 1)
	await tween.finished
	Main.on_tutorial = false
	queue_free()

func set_pause():
	$AnimationPlayer.play("Pause")
	$TextBoxContent/ButtonLabel.text = "Pode deixar!"
	$TextBoxContent/Title.text = "Agora é com você"
	$TextBoxContent/Body.text = "Sempre que precisar relembrar algum comando, pressione <esc> e clique em <Controles>."
	var tween = create_tween()
	tween.tween_property($TextBoxContent, "modulate", Color(1,1,1,1), 1)


func _on_quit_pressed():
	Main.on_tutorial = false
	queue_free()



func _on_confirm_pressed():
	if Main.tutorial_step == 6:
		_on_pause_first_open()


func _on_pause_menu_first_pause():
	_on_pause_first_open()
