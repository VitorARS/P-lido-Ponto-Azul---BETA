extends Node2D


var is_inside_indicator = false
var fire_step = 0
var allowed = false
var number = 3
signal fire_mission

func _ready():
	Dialogue.connect("queue_self", Callable(self, "on_queue_self"))
#	$Blur.visible = true
	$Countdown.text = "Prepare-se"
	$AnimationPlayer.speed_scale = 0.5
	$DialogueBox/Label.text = "Pressione <E> no momento certo para produzir fogo"

func _input(event):
	if Input.is_action_just_pressed("e") and allowed:
		$Pointer.play("Point")
		
		allowed = false
		if is_inside_indicator:
			fire_step += 1
			match fire_step:
				1:
					$Fire.play("First")
				2:
					$Fire.play("Second")
				3:
					$Reactions.play("Smoke")
					$Fire.play("Third")
				4:
					$Fire.play("Fourth")
#					await $Fire.animation_finished
					$Reactions.play("LitlleFire")
					$Sound.stream = load("res://SoundFx/FireSound.wav")
					$Sound.play()
					$DialogueBox/Label.text = "Você conseguiu!"
					$AnimationPlayer.speed_scale = 1
					allowed = false
					$AnimationPlayer.play("Done")
					await $AnimationPlayer.animation_finished
					Dialogue.set_visibility(true)# , false
					Dialogue.add_dialogue( Main.anaje.interaction, 7, "Anajé", "Happy",true, true)
					queue_free()



func entered_indicator():        #! all functions are called in animation player
	is_inside_indicator = true

func exited_indicator():
	is_inside_indicator = false
	
func reset_chance():
	allowed = true

func _on_timer_timeout():
	if number < 1:
		$Blur.visible = false
		allowed = true
		$Timer.stop()
		$Countdown.visible = false
		$AnimationPlayer.play("Rolling")
	else:
		$Countdown.text = str(number)
		number -= 1
		$Timer.start(1)
