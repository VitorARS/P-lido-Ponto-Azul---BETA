extends Control

@onready var textbox_label = $Textbox/Label
@onready var textbox = $Textbox

func _ready():
	position = Vector2(-100, 0)
	
func show_alert(art_name):
	visible = true
	$Texture.texture = load("res://UI/Sprites/Artefacts/" + str(art_name).capitalize() + "Alert.png")
	textbox.size.x = (len(art_name.to_lower()) * 5) + 50
	textbox_label.text = " " + art_name.capitalize() 
	$Background.position.x = (- $Textbox.size.x) - ((80 - $Textbox.size.x) *2) #crazy math to center background of the message
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(90, 0) , 0.75)
	await get_tree().create_timer(5).timeout
	var tween2 = create_tween()
	tween2.tween_property(self, "position", Vector2(-100, 0) , 0.75)
	await tween.finished
	visible = true

	
