extends CanvasLayer


signal safe_to_load

var prehistory_text = ["Curiosidade: O fóssil humano  mais antigo do Brasil, batizado de Luzia, data de cerca de 13.000 anos atrás.", 
"Homens e dinossauros nunca conviveram! Na verdade ele foram extintos 65 milhões de anos antes do surgimento da espécie humana ", 
"A linguagem humana evoluiu como uma forma de fofoca… Era muito útil saber quem em seu bando odeia quem, quem é honesto e quem é trapaceiro etc.",
"Nos primeiros milhões de anos de evolução humana, os humanos viveram apenas na África. Há cerca de 1,8 milhões de anos, começaram a espalhar-se por outras partes do mundo.",
"Os primeiros caçadores realizavam caçadas persistentes, correndo atrás de um animal durante horas até que ele se superaquecesse.",
"Um dos usos mais comuns das primeiras ferramentas de pedra foi abrir ossos para chegar até o tutano."

]
var ancient_text = []
var text_index = 0
var previus_index

func _ready():
	Main.level = 1
	display_text()
	


func display_text():
	match Main.level:
		1:
			$Footer/Curiosity.text = prehistory_text[text_index]
		2: 
			$Footer/Curiosity.text = ancient_text[text_index]
	$Timer.start(15)
	
func _on_timer_timeout():
	if prehistory_text.size() - 1 <= text_index:
		text_index = 0
	else:
		text_index += 1
	display_text()
