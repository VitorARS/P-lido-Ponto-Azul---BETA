extends TextureProgressBar

@onready var anim = $Anim
signal update_stamina
var returning = true

func _ready():
#	Main.player.connect("increase_stamina", Callable(self, "on_increase_stamina"))
	position = Vector2(16, 8) #for some reason if i do not set it on sript it returns to 0,0
	tint_over = Color(0,0,0,0)
	tint_progress = Color(0.25 ,1, 0.38, 1)
	$Info.visible = false
	_on_player_update_stamina(0)

func _on_player_update_stamina(quant):
	Main.stamina = clamp(Main.stamina + quant, 0, 1000) #normaly the quant will be a negative value
	value = Main.stamina 
	if Main.stamina > 999:
		tint_progress = Color(0.25,1,0.25,1)
		anim.play("Full")
	elif Main.stamina > 666 and Main.stamina <= 999:
		tint_progress = Color(0.25,1,0.25,1)
	elif Main.stamina <= 666 and Main.stamina > 333:
		tint_progress = Color(1,1,0.38,1)
	elif Main.stamina <= 333 and Main.stamina > 0:
		tint_progress = Color(1,0,0,1)
	elif Main.stamina == 0 and returning: #returning var makes it run single time and not overflow
		$Damage.start()
		returning = false


func _on_damage_timeout():
	PlayerStats.set_health(PlayerStats.health - 0.5)
	Main.player.damage_sound.play()
	Main.player.hurtbox._start_invincibility(0.6, false)
	if Main.stamina == 0:
		returning = true
	else:
		returning = false
	
	if PlayerStats.health == 0 and Main.stamina <= 0:
		print("playerDies")
#		Main.player.GameOver("Starvation")
#		Main.player.hurtbox.set_collision_mask_value(10, false)

func _on_player_stamina_returning():
	returning = true
#	emit_signal("update_stamina", -0.05) # see what this does


func on_increase_stamina(quant):
	var tween = create_tween()
	Main.stamina = clamp(Main.stamina + quant, 0, 1000)
	tween.tween_property(self, "value", Main.stamina, 1)
	await tween.finished
	print("value: ", value, " stamina: ", Main.stamina)



func _on_mouse_entered():
	$Info.visible = true
	$Info/RichTextLabel.text = "[center]Essa é a sua [color=#3fff42]Stamina.[/color][/center] Seu atual valor é: " + str(value) + ". Coma para aumentar esse valor, nunca deixe-o chegar em 0!"

func _on_mouse_exited():
	$Info.visible = false

