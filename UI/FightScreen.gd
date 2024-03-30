extends Control


const CHAR_READ_RATE = 0.015
signal fight_entered
signal fight_exited
var page
var max_pages
var characters_list = ["jacare"]
var current_enemy
var in_options = false # when true implies that we are in  a chioce page, thus we dont want to read _input()
var in_quiz = false
var next_index # 5th index from ANSWERES
var time
var button_index = 0
var correct_answer
var text_visible = false
var got_correct_answer
var total_xp = 0

func _ready():
	connect("fight_entered", Callable(Main.player, "return_process"))
	connect("fight_exited", Callable(Main.player, "stop_process"))
	for button in $Buttons.get_children():
		button_index += 1
		button.pressed.connect(on_pressed.bind(button_index))
	
	$Music.play()
	page = 1
	current_enemy = Main.current_enemy
	$Buttons.visible = false
	$Buttons/Button1.visible = false
	
	$Buttons/Button2.visible = false
	$Buttons/Button3.visible = false
	$Buttons/Button4.visible = false
	$Body.visible = false
	$Quiz.visible = false
	
	if characters_list.has(current_enemy):
		$Body.visible_ratio = 0
		max_pages = FightDialogue[current_enemy].size()


	else:
		print("ops, wrong name informed")
	
	$BoxAnim.play("Entering")

func _input(event):
	if Input.is_action_pressed("move_forward") and text_visible:
		if page <= max_pages and !in_options:
			page += 1
			jacare_interation()
			text_visible = false

func write_text(text):
	$Body.visible_ratio = 0
	$Body.visible = true
#	$Body.set_text(text)
	$Body.bbcode_text = text
	var tween = create_tween()
	tween.tween_property($Body, "visible_ratio", 1 , len(text) * CHAR_READ_RATE)
	await tween.finished 
	text_visible = true

func set_options(options: Array):
	in_options = true
	var num_options = options.size()
	for i in range(1, num_options + 1):
		var button = get_node("Buttons/Button" + str(i))
		button.visible = true
		button.text = FightDialogue[current_enemy][page][i - 1]
		
	$Buttons.visible = true
	$Buttons/Button1.grab_focus()
	

func start_writing():
	match current_enemy:
		"jacare":
			jacare_interation()
			$EnemyAnim.play("jacare")

func set_quiz_question(question, answer, sec):
	in_quiz = true
	correct_answer = answer
	var tween = create_tween()
	tween.tween_property($Character, "modulate", Color(0,0,0,0), 1)
	await tween.finished
	$Quiz.visible = true
	$Quiz/Body.visible_ratio = 0
	$Quiz/Body.visible = true
	$Quiz/Body.set_text(question)
	time = sec
	$Quiz/TimerLabel.text = str(sec)
	var tween2 = create_tween()
	tween2.tween_property($Quiz/Body, "visible_ratio", 1 , len(question) * CHAR_READ_RATE)
	await tween2.finished 
	text_visible = true
	page += 1
	jacare_interation()
	$Quiz/Timer.start(1)

	
func jacare_interation():  #aqui  serão feitas as multiplas escolhas
	match page:
		1:
			write_text(FightDialogue[current_enemy][page][0])
		2:
			$Body.visible = false
			set_options(FightDialogue[current_enemy][page])
		3:
			$Buttons/Button1.visible = false
			$Buttons/Button2.visible = false
			in_options = false
			write_text(FightDialogue[current_enemy][page][next_index])
		4:
			write_text(FightDialogue[current_enemy][page][next_index])
		5:
			$Body.visible = false
			set_quiz_question(FightDialogue[current_enemy][page][0], FightDialogue[current_enemy][page][1], FightDialogue[current_enemy][page][2])
		6:
			set_options(FightDialogue[current_enemy][page])
		7:
			clear_quiz()
			var tween = create_tween()
			tween.tween_property($Character, "modulate", Color(1,1,1,1), 1)
			await tween.finished
			
			if got_correct_answer:
				total_xp += (FightDialogue[current_enemy][page][5]) 
				write_text(FightDialogue[current_enemy][page][next_index])
			else:
				write_text(FightDialogue[current_enemy][page][next_index] + " O seu [color=CORNFLOWER_BLUE]conhecimento[/color] foi aumentado em" + str(total_xp)+ " (dos 45 disponíveis).")
			
		8:
			if got_correct_answer: #New questoin
				$Body.visible = false
				set_quiz_question(FightDialogue[current_enemy][page][0], FightDialogue[current_enemy][page][1], FightDialogue[current_enemy][page][2])
			else: #
				Main.user_interface.set_process_unhandled_input(true)
				Main.player.set_physics_process(true)
				queue_free()
				emit_signal("fight_exited")
				Main.player.emit_signal("fight_ended")
		9: 
			set_options(FightDialogue[current_enemy][page])
			got_correct_answer = false
		10:
			clear_quiz()
			var tween = create_tween()
			tween.tween_property($Character, "modulate", Color(1,1,1,1), 1)
			await tween.finished
			if got_correct_answer:
				total_xp += (FightDialogue[current_enemy][page][5]) 
				write_text(FightDialogue[current_enemy][page][next_index])
			else:
				write_text(FightDialogue[current_enemy][page][next_index] + " O seu [color=CORNFLOWER_BLUE]conhecimento[/color] foi aumentado em " + str(total_xp)+ " ( dos 45 disponíveis).")
		11:
			if got_correct_answer:
				$Body.visible = false
				set_quiz_question(FightDialogue[current_enemy][page][0], FightDialogue[current_enemy][page][1], FightDialogue[current_enemy][page][2])
			else:
				Main.user_interface.set_process_unhandled_input(true)
				Main.player.set_physics_process(true)
				Main.emit_signal("xp", total_xp)
				queue_free()
				emit_signal("fight_exited")
				Main.player.emit_signal("fight_ended")
		12: 
			set_options(FightDialogue[current_enemy][page])
			got_correct_answer = false
		13:
			clear_quiz()
			if got_correct_answer:
				total_xp += (FightDialogue[current_enemy][page][5]) 
				write_text(FightDialogue[current_enemy][page][next_index]  + " O seu [color=CORNFLOWER_BLUE]conhecimento[/color] foi aumentado em " + str(total_xp)+ " ( dos 45 disponíveis). Impressionante!")
			else:
				write_text(FightDialogue[current_enemy][page][next_index] + " O seu [color=CORNFLOWER_BLUE]conhecimento[/color] foi aumentado em " + str(total_xp)+ " ( dos 45 disponíveis).")
		14:
			emit_signal("fight_exited")
			Main.player.emit_signal("fight_ended")
			Main.user_interface.set_process_unhandled_input(true)
			Main.player.set_physics_process(true)
			Main.emit_signal("xp", total_xp)
			queue_free()

func on_pressed(button_index):
	if in_quiz:
		if button_index - 1 == correct_answer: # - 1 because array indexes starts with 0
			got_correct_answer = true
			in_quiz = false
			get_node("Buttons/Button" + str(button_index)).modulate = Color(0.25,1,0.25,1)
#			make_other_buttons_red(button_index)
		else: #wrong answer: everyone gets red
			for i in range(1, 5):
				if i != correct_answer + 1:
					get_node("Buttons/Button" + str(i)).modulate = Color(1,0,0,1)
				else:
					get_node("Buttons/Button" + str(i)).modulate = Color(0.25,1,0.25,1)
	
		next_index = button_index - 1
		page += 1
		await get_tree().create_timer(1.5).timeout
		jacare_interation()
		
	else:
		next_index = button_index - 1
		page += 1
		jacare_interation()
	
func _on_timer_timeout():
	if time > 0:
		$Quiz/ClockSound.stream = load("res://SoundFx/ClockClick.wav")
		$Quiz/ClockSound.play()
		time -= 1
		if time > 9:
			$Quiz/TimerLabel.text = str(time)
		elif time < 9:
			$Quiz/TimerLabel.text = "0" + str(time)
	else:
		$Quiz/Timer.stop()
		$Quiz/ClockSound.stream = load("res://SoundFx/ClockFinished.wav")
		$Quiz/ClockSound.play()
		next_index = 4
		page += 1
		jacare_interation()

func clear_quiz():
	$Buttons/Button1.visible = false
	$Buttons/Button2.visible = false
	$Buttons/Button3.visible = false
	$Buttons/Button4.visible = false
	in_options = false
	$Quiz/Timer.stop()
	$Quiz.visible = false
	var tween = create_tween()
	tween.tween_property($Character, "modulate", Color(1,1,1,1), 1)
	await tween.finished
	await get_tree().create_timer(2).timeout
	for i in range(1,5):
		get_node("Buttons/Button" + str(i)).modulate = Color(1,1,1,1)

########### Dialogues  /// Mudar essa  budega

# the dictionary includes others dictionarys with the enemies spechees, each page may have more than one option so its a array, i may like to specify the type too being: normal speech, choices and quiz
 
var FightDialogue = {
	"jacare": {1: ["- O que você está fazendo aqui? Não vê que está perturbando meu descanso", "Rappppaaaiz"],
			   2: ["* Pedir desculpas" ,"* Provocar"],
			   3: [" Você diz: 'Sinto muito por estar te atrapalhando. Na verdade,  estou aqui tentanto aprender um pouco sobre o planeta e a época de vocês.'", " Você diz: 'Olha só, achei o dono da floresta! Me deixe em paz.' "], 
			   4: ["- Certo, certo... Mesmo assim, não vou deixar você sair dessa assim tão fácil! Vamos ver se você aprendeu alguma coisa então.", " - [shake rate=20.0 level=3 connected=1]Então você quer as coisas do jeito difícel é? [/shake] Sabe... Eu poderia acabar com você agora mesmo. Mas serei generoso, se você conseguir responder essas perguntas estará livre."], 
			   5: ["Qual desses animais [color=red]não [/color]é nativo do Brasil?", 1, 20],
			   6: ["* Jacaré", "* Castor", "* Ariranha", "* Anta"],
			   7: [" Como você se atreve a dizer isso? minha espécie está nessas terras a milhares de anos!!", " Muito bem, está correto, mas ainda não é o suficiente. Agora prometo que será mais difícil.", "Hahaha, desconfiei que você não era mesmo capaz. Essa resposta está errada.", " Hahaha, desconfiei que você não era mesmo capaz. Essa resposta está errada.", "Seu tempo se esgotou rapaz. A resposta era: Castor", 10], #5th index in xp value
			   8: ["Qual foi o primeiro animal domesticado pelo ser-humano?", 0, 15, "Pelo visto você ainda tem muito para aprender, agora pare de encher minha paciência e dê o fora!"],
			   9: ["* Cachorro", "* Cavalo", "* Galinha", "* Gato"],
			  10: ["Olha só, parece que você aprendeu mesmo alguma coisa... Agora vamos pra [color=red]pergunta final![/color]", "Hahaha ainda tem muito o que aprender garoto!", "Mas que [color=blue]pena![/color], está errado.", "Hahaha ainda tem muito o que aprender garoto!", "Seu tempo se esgotou rapaz. A resposta era: Cachorro.", 15],
			  11: ["Quais dessa espécies não foi extinta durante a pré-história brasileira?", 3, 10, "É... Talvez tenha sido um pouco demais pra você. A resposta era: Lobo-Guará."],
			  12: ["* Tigre-dente-de-sabre", "* Mamute", "* Preguiça-gigante", "* Lobo-Guará"],
			  13: [" Hahaha chegou até a última pergunta pra errar feio desse jeito?", " Está errado. É, acho que as duas primeira foram sorte de principiante.", " Você errou. Agora ve se deixa de [color=blue]preguiça[/color] e vá aprender um pouco mais.", "Parabéns garoto, você passou no teste!", "Seu tempo se esgotou rapaz. A respota era: Lobo-Guará.", 20]
			 
			}
}










