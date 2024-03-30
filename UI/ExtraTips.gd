extends Control

var before_text = "                          [center]"
var after_text = "[/center]"
var tips = {
	"Interactables": ["Seja curioso", "Você encontrará objetos espalhados pelo mapa. Pressione <E> para interagir com eles e ganhar [color=CORNFLOWERBLUE]conhecimento[/color]"],
	"Artefact": ["Artefatos perdidos", " Ora ora, parece que temos um explorador por aqui! pressione <E> para coletar esse artefato."],
	"KnowledgeTree": ["Árvore do conhecimento", "Muito bem, agora clique no ícone azul a direita ou pressione <T> para saber mais sobre o artefato encontrado. "]
			}

func _ready():
	visible = false

func set_interactables():
	$AnimationPlayer.play("Interactables")
	$TextBoxContent/Title.text = tips["Interactables"][0]
	$TextBoxContent/Body.text = before_text + tips["Interactables"][1] + after_text
	$TextBoxContent/Key/Key1/Label.text = "E"
	modulate = Color(0,0,0)
	visible = true
	$Sound.stream = load("res://SoundFx/FirstArtefact.wav")
	$Sound.pitch_scale = 1
	$Sound.play()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1), 0.5)

func set_artefact():
	$AnimationPlayer.play("Artefact")
	$TextBoxContent/Title.text = tips["Artefact"][0]
	$TextBoxContent/Body.text = before_text + tips["Artefact"][1] + after_text
	$TextBoxContent/Key/Key1/Label.text = "E"
	modulate = Color(0,0,0)
	visible = true
	$Sound.stream = load("res://SoundFx/FirstInteractable.wav")
	$Sound.pitch_scale = 1
	$Sound.play()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1), 0.5)

func set_knowledge_tree():
	$AnimationPlayer.play("KnowledgeTree")
	$TextBoxContent/Title.text = tips["KnowledgeTree"][0]
	$TextBoxContent/Body.text = before_text + tips["KnowledgeTree"][1] + after_text
	$TextBoxContent/Key/Key1/Label.text = "T"
	modulate = Color(0,0,0)
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1), 0.5)

func on_interactables_completed():
	visible = false

func on_knowledge_tree_completed():
	visible = false

func _on_quit_pressed():
	visible = false
