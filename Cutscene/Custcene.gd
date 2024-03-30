extends Control

@onready var anim = $Anim
@onready var label = $Label
#@onready var voltar = $CanvasLayer/Control/Return


const CHAR_READ_RATE = 0.035

var start_pos
var page = 0
var last_scene = false
var mouseIsOverButton = false
var opening = true
var able_to_input = false

var dialogue = ["", "Orbitando Saturno a uma distância de 1,2 milhão de quilômetros do planeta terra...",
"Encontra-se um satélite natural. Que é chamado por seus habitantes de Caladan...", "Que é o lar do protagonista dessa jornada, um jovem e simples rapaz que se chama Seigan...",
"Certo dia, Seigan estava descansando em seu sofá, quando, de repente, lembrou-se de algo...",
"Ele tem uma prova de história no dia seguinte, cujo assunto é: A História da Humanidade...",
"Mas ele tem um plano: usar uma velha máquina do tempo que estava acumulando poeira na estante... ","E acompanhar com os próprios olhos as eras que compõem a história da Humanidade."]

func _ready():
	print(dialogue.size())
	if !Main.debug_version:
		AutoloadSounds.stream = load("res://Soundtrack/ATravessia.ogg")
		AutoloadSounds.play()
		
	label.position = Vector2(520, 40)
	label.visible_ratio = 0
	label.set_text(dialogue[page])
	label.set_visible_characters(0)
	set_process_input(true)

func _input(_event): #Tem algum aqui as vezes o input não é dectado fica na abertura permanentemente Obs: talvez eu tenho resolvido mudando a posição do mouse na anim
	if able_to_input:
		if Input.is_action_pressed("move_forward") and mouseIsOverButton == false:
			if opening == true: #in the beggining theres no visible ratio
				anim.play("Cutscene")
				opening = false
			elif label.visible_ratio == 1:
				anim.play("Cutscene")
				if page == 7:
					able_to_input = false  #will block next input
		elif  Input.is_action_pressed("move_backward"):
			if page < dialogue.size()-1 and label.visible_ratio == 1:
				if $Return.visible:
					page -= 2 #used to be 3, be aware
					anim.seek(start_pos - 1.3, true)
func change_page():
#	if page < dialogue.size():
	label.visible = false
	print(page)
	page += 1
	label.set_text(dialogue[page])
	label.visible_ratio = 1
	label.size.y = (label.get_line_count() + 1) * 48
	label.visible_ratio = 0
	label.visible = true

	var tween = create_tween()
	$Writing.play()

	tween.tween_property(label, "visible_ratio", 1 , len(dialogue[page]) * CHAR_READ_RATE)
	await tween.finished
	$Writing.stop()

func pause_anim():
	anim.pause()
	start_pos = anim.current_animation_position


func _on_return_pressed():
	if page < dialogue.size()-1 and label.visible_ratio == 1:
		page -= 2 #used to be 3, be aware
		anim.seek(start_pos - 1.3, true)

func mouse_instruction():
	$Instructions/Mouse.play()
	able_to_input = true

func _on_skip_pressed():
	$Skip/PopUp/PopUpAnim.play("PopUp")
	
func next_level():
	Main.level += 1
	Loader.allowed_to_load = true
	Loader.load_scene_with_screen(self, "pre_history")

func _on_no_pressed():
	$Skip/PopUp/PopUpAnim.play_backwards("PopUp")
	
func _on_yes_pressed():
	Main.level += 1
	visible = false
	Loader.allowed_to_load = true
	Loader.load_scene_with_screen(self, "pre_history")

func create_trans():
	var tween = create_tween()
	tween.tween_property($Overlay.material, "shader_parameter/progress", 1 ,2)
	await tween.finished




func _on_yes_mouse_entered():
	mouseIsOverButton = true

func _on_yes_mouse_exited():
	mouseIsOverButton = false

func _on_no_mouse_entered():
	mouseIsOverButton = true

func _on_no_mouse_exited():
	mouseIsOverButton = false

func _on_skip_mouse_entered():
	mouseIsOverButton = true

func _on_skip_mouse_exited():
	mouseIsOverButton = false
