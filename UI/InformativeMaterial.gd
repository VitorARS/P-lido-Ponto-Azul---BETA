extends Control


var title = ["Sapiens", "Paleolítico", "Neolítico", "Idade dos Metais" ]
var time = ["", "(2,500.000 - 10.000 a.C.)", "10.000 - 3.000 a.C."]
var body_text = ["Apesar de não serem os primeiros humanos, o Homo sapiens veio substituir todas as outras espécies humanas na Terra. 
Exitem alguns fatores cruciais que possibilitaram o seu triunfo evolutivo.

 * O fogo: Permitiu ao homem cozinhar alimentos, proteger-se
 de animais hostis e do frio. 

* Comunicação: Com a chamada Revolução Cognitiva, o homem adquiriu habilidades de pensamento e comunicação, que não só 
permitiram a invenção de formas mais complexas de ferramentas e técnicas de caça; como também conceber ideias mais abstratas como deuses, dinheiro, estado etc ",  

" O paleolitico inicia-se a cerca de 2,5 milhões de anos atrás, com a fabricação das primeiras ferramentas de pdra lascada, destacando o homem dos outros animais.
Nessa época os humanos eram nômades caçadores coletores, ou seja não possuiam moradia fixa e obtinham seu alimento direto da natureza. Existiram também outras espécies de homínideos vivendo simultaneamente na Terra. Mas a cerca de 40 mil anos os Neandertais entraram  em extinção, deixando os Sapiens como a última espécie do gênero Homo.",
" O Neolítico é marcado pela desenvolvimento da agricultura e a domesticação de animais. É nessa época que surgem as primeiras aldeias, que eram criadas próximas a rios. Essa mudança de estilo de vida acarretou em um enorme aumento populacional.  Esse novo modelo de sociedade mais complexo, abre espaço para a formação de um Estado que as administrasse. Surgia assim a figura do chefe do grupo, uma pessoa a quem os demais respeitavam e acatavam suas ordens."]

func set_info_material(index, dec_name):
	$Title.text = title[index]
	$Body.text = body_text[index]
	$Time.text = time[index]
	$Image.texture = load("res://UI/Sprites/Artefacts/InformativeMaterialDecoration/" + str(dec_name.capitalize()) + ".png")
	visible = true
	
	
