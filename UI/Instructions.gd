extends Control

@onready var ui_anim = get_node("UIAnim")
@onready var years_label = $Countdown/Years
@onready var tutorial_progress = $NinePatchRect/TextureProgressBar

signal countdown_finished
var holder_timer = 5
var years = 0
var increasing_rate = 333


func _ready(): 
	visible = true
	$Control/SkipAnim.play("Default")
	tutorial_progress.value = 0
	$NinePatchRect.modulate = Color(0,0,0,0)
	$NinePatchRect/BoxElements/Keys/Tecla1/Label.text = "W"
	$NinePatchRect/BoxElements/Keys/Tecla2/Label.text = "S"
	$NinePatchRect/BoxElements/Keys/Tecla3/Label.text = "A"
	$NinePatchRect/BoxElements/Keys/Tecla4/Label.text = "D"
	if Main.debug_version:
		$Countdown.visible = false
		emit_signal("countdown_finished")
		_on_yes_pressed()
		Main.player.set_physics_process(true)
	else:
		$Countdown.visible = true
		$Timer.start()
		Main.player.global_position = Main.spawn_position



func _on_timer_timeout():
	if years <= 9999:
		years += increasing_rate
		years_label.text = "0" + str(years)

	elif years > 9999 and years <= 12000:
		years += increasing_rate
		years_label.text = str(years)
	
	elif years > 12000:
		$Timer.stop()
		years_label.text = str(12000)
#		ui_anim.play("fade_countdown")
#		print("over12000")
		var tween = create_tween()
		tween.tween_property($Countdown, "modulate", Color(1,1,1,0), 2)
		await tween.finished
		set_move()
		emit_signal("countdown_finished")


func set_move(): #called by animation player
	ui_anim.play("Move")
	var tween = create_tween()
	tween.tween_property($NinePatchRect, "modulate", Color(1,1,1,1), 0.5)
	$NinePatchRect/BoxElements/Title.text = "Primeiros Passos:"
	$NinePatchRect/BoxElements/Body.text = "Use W,A,S e D ou as teclas direcionais para se mover"
	Main.player.set_physics_process(true)

func _on_player_first_move():
	update_text(0)


func update_text(bar_value):
	Main.lesson_index += 1
	var tween = create_tween()
	tween.tween_property(tutorial_progress, "value", bar_value, 0.5)
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_property($NinePatchRect/BoxElements, "modulate", Color(0,0,0,0), 0.5)
	await tween2.finished
	match Main.lesson_index:
		1:
			roll()
		2:
			take()
		3:
			eat()
		4:
			ui()
		5:
			hotbar()
		6:
			mission()
		7:
			pause()

func roll():
	ui_anim.play("Roll")
	$NinePatchRect/BoxElements/Title.text = "por que não?"
	$NinePatchRect/BoxElements/Body.text = "Você também pode pressionar <R> para dar uma cambalhota."
	$NinePatchRect/BoxElements/Keys/Tecla1/Label.text = "R"
	$NinePatchRect/AnimatedSprite2D.play("default")
	var tween = create_tween()
	tween.tween_property($NinePatchRect/BoxElements, "modulate", Color(1,1,1,1), 1)


func _on_player_first_roll():
	update_text(20)


func take():
	ui_anim.play("Take")
	$NinePatchRect/BoxElements/Title.text = "Olá Mundo!"
	$NinePatchRect/BoxElements/Body.text = "Muito bem! Agora vá até um arbusto, pressione <E> para coletar suas frutas"
	$NinePatchRect/BoxElements/Keys/Tecla1/Label.text = "E"
	$NinePatchRect/AnimatedSprite2D.play("default")
	var tween = create_tween()
	tween.tween_property($NinePatchRect/BoxElements, "modulate", Color(1,1,1,1), 1)

func _on_player_first_take():
	update_text(40)

func eat():
	ui_anim.play("Eat")
	$NinePatchRect/BoxElements/Title.text = "Recarregando as energias"
	$NinePatchRect/BoxElements/Body.text = "Ótimo! para continuar, pressione <F> para come-las."
	$NinePatchRect/BoxElements/Keys/Tecla1/Label.text = "F"
	var tween = create_tween()
	tween.tween_property($NinePatchRect/BoxElements, "modulate", Color(1,1,1,1), 1)


func _on_player_first_eat():
	update_text(60)
	
func ui():
	ui_anim.play("UI")
	$NinePatchRect/BoxElements/Entendi/Label.text = "Entendi"
	$NinePatchRect/BoxElements/Body.text = "Isso aí! se alimentando você aumenta sua barra de energia e recupera sua saúde "
	var tween = create_tween()
	tween.tween_property($NinePatchRect/BoxElements, "modulate", Color(1,1,1,1), 1)


func hotbar():
	ui_anim.play("Hotbar")
	$NinePatchRect/BoxElements/Keys/Tecla1/Label.text = "1"
	$NinePatchRect/BoxElements/Keys/Tecla2/Label.text = "2"
	$NinePatchRect/BoxElements/Keys/Tecla3/Label.text = "8"
	$NinePatchRect/BoxElements/Title.text = "Guia do Mochileiro"
	$NinePatchRect/BoxElements/Body.text = "Quase lá! Experimente navegar pelo inventário com as teclas 1 a 8 ou com o scroll do mouse."
	var tween = create_tween()
	tween.tween_property($NinePatchRect/BoxElements, "modulate", Color(1,1,1,1), 1)

func mission():
	ui_anim.play("Mission")
	$NinePatchRect/BoxElements/Entendi/Label.text = "Certo!"
	$NinePatchRect/BoxElements/Body.text = "Quando você precisar de direção clique no ícone <missões>. E não se esqueça de conferiar a aba dos artefatos."
	var tween = create_tween()
	tween.tween_property($NinePatchRect/BoxElements, "modulate", Color(1,1,1,1), 1)
	$NinePatchRect/BoxElements/Keys/Tecla1/Label.text = "G"
	$NinePatchRect/BoxElements/Keys/Tecla2/Label.text = "T"
func pause():
	ui_anim.play("Pause")
	$NinePatchRect/BoxElements/Entendi/Label.text = "Pode deixar!"
	$NinePatchRect/BoxElements/Title.text = "Agora é com você"
	$NinePatchRect/BoxElements/Body.text = "Sempre que precisar relembrar algum comando, pressione <esc> e clique em <Controles>."
	var tween = create_tween()
	tween.tween_property($NinePatchRect/BoxElements, "modulate", Color(1,1,1,1), 1)
	
func _on_pular_pressed():
	$Control/SkipAnim.play("Show")
	$Control/PopUp/Yes.disabled = false
	$Control/PopUp/No.disabled = false
	$Control/Pular.visible = false
	$Control/Pular.disabled = true

func _on_no_pressed():
	$Control/PopUp/No.disabled = true
	$Control/PopUp/Yes.disabled = true
	$Control/SkipAnim.play_backwards("Show")
	await $Control/SkipAnim.animation_finished
	$Control/Pular.visible = true
	$Control/Pular.disabled = false


func _on_yes_pressed():
	Main.lesson_index = 8
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property($NinePatchRect, "modulate", Color(0,0,0,0), 1)
	tween2.tween_property($Control, "modulate", Color(0,0,0,0), 1)
	$Control/SkipAnim.play("Hide")
	$NinePatchRect/BoxElements/Entendi.disabled = true
	$Control/PopUp/Yes.disabled = true
	$Control/PopUp/No.disabled = true
	$Control/Pular.disabled = true
func _on_entendi_pressed():
	if Main.lesson_index == 4:
		update_text(60)
	elif Main.lesson_index == 6:
		update_text(80)
	elif Main.lesson_index == 7: #end of tutorial
		update_text(100)
		var tween = create_tween()
		var tween2 = create_tween()
		tween.tween_property($NinePatchRect, "modulate", Color(0,0,0,0), 1)
		tween2.tween_property($Control, "modulate", Color(0,0,0,0), 1)
		$Control/SkipAnim.play("Hide")
		$NinePatchRect/BoxElements/Entendi.disabled = true
		$Control/PopUp/Yes.disabled = true
		$Control/PopUp/No.disabled = true
		$Control/Pular.disabled = true

func _on_hotbar_first_navigate():
	update_text(80)


