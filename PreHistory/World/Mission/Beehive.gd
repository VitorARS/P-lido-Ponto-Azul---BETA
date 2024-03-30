extends Node2D

var not_inputing = true
var just_entered = true
var first_take = false

func _ready():
	$TextureProgressBar.value = 0

func _input(event):
	if Input.is_action_pressed("CollectHoney") and Main.player.in_collect_area == true:
		if just_entered:
			Main.player.take_anim = "TakeMid"
			Main.player.set_state(3)
			just_entered = false
		
		$TextureProgressBar.value += 1
		not_inputing = false
		
		if $TextureProgressBar.value == $TextureProgressBar.max_value:
			$TextureProgressBar.value = 0
			Main.player.set_state(0)
			PlayerInventory.add_item("Mel", 1) #is adding more than 1
			if !first_take and Main.mission_step == 2:
				first_take = true
				Main.user_interface.mission.mission_completed()
				Main.anaje.mission_ended = true
				Main.anaje.mission_collision.disabled = true
				get_parent().emit_signal("honey_collected")
		
	if Input.is_action_just_released("CollectHoney"):
		Main.player.set_state(0)
		not_inputing = true
		just_entered = true
#		Main.player.in_collect_area = true



func _physics_process(delta):
	if $TextureProgressBar.value > 0 and not_inputing:
		$TextureProgressBar.value -=  .5


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		set_process_input(true)
		Main.player.in_collect_area = true



func _on_area_2d_body_exited(body):
	if body.name == "Player":
		set_process_input(false)
		Main.player.in_collect_area = false


