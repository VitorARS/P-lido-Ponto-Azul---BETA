extends Control

var title = ["Tem alguém aí?", "O Guardião da Tribo", "O Doce Néctar", "Fim da versão BETA"]
var body = ["O pouco que Seigan lembra das aulas é que havia uma espécie no planeta terra que se destacava das outras, talvez eles possam nos ensinar algo...", 
"Alguém certamente esteve por aqui algumas horas atrás. E esqueceram essa escultura de madeira. Talvez ainda seja possível devolve-la  a seus donos...",
"É hora de mostrar a seus novos amigos de suas capacidades, enfrentado um enxame de abelhas e extraindo um pouco de mel dessa colméia.", 
"O jogo atualmente foi desenvolvido até essa parte. Mas fique ligado, futuramente pretendo finalizar o projeto. Obrigado por ficar até aqui! S2"]
var objective = ["Encontre sinais de vida inteligente", "Devolva o amuleto ao seu dono", "colete mel na colméia", "Fique à vontade para explorar o mapa."]

signal first_open()
var had_not_open = true
var just_completed_mission = false

func _ready():
	$Info.visible = false
	$Control.visible = false
	change_page()
func _on_texture_button_pressed():
	if had_not_open and Main.tutorial_step == 5:
		had_not_open = false
		emit_signal("first_open")
	$Info.visible = false
	$Control.visible = !$Control.visible
	if $Control.visible:
		$Sound.pitch_scale = 1.2
		$Sound.stream = load("res://SoundFx/Mission.wav")
		$Sound.play()
		if just_completed_mission:
			just_completed_mission = false
			$Control/CheckBox.play("Completed")
			await $Control/CheckBox.animation_finished
			change_mission()
			$Anim.play("Default")
	else:
		$Sound.pitch_scale = 1
		$Sound.stream = load("res://SoundFx/Mission.wav")
		$Sound.play()


func _on_texture_button_mouse_entered():
	$Info.visible = true
	if just_completed_mission:
		$Anim.play("Default")

func _on_texture_button_mouse_exited():
	$Info.visible = false
	if just_completed_mission:
		$Anim.play("Completed")

func change_mission():
	$Control/Body.modulate = Color(0,0,0,0)
	var tween = create_tween()
	tween.tween_property($Control/Body, "modulate", Color(1,1,1,1), 1)
#	update_mission = false

func change_page():
	$Control/Title.text = title[Main.mission_step]
	$Control/Body.text = body[Main.mission_step]
	$Control/Objective.text = objective[Main.mission_step]

func mission_completed():
	$Anim.play("Completed")
	Main.mission_step += 1
	change_page()
	just_completed_mission = true

func _on_amulet_area_entered(area):
	mission_completed()
