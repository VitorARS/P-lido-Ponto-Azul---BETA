extends CharacterBody2D

@onready var anim = $Anim
@onready var animationTree = $AnimationTree
@onready var animation_state = $AnimationTree.get("parameters/playback")
@onready var sound = $GeneralSounds
@onready var hurtbox = $Hurtbox
@onready var blink_anim = $BlinkAnim
@onready var hotbar = get_parent().get_node("UserInterface/PlayerUI/Hotbar")
@onready var nav_agent = $NavigationAgent2D
@export var MAX_SPEED = 100
@export var ACCELARATION = 350
@export var ATRITO = 400
@export var ROLL_SPEED = 125
@export var interaction :Array[String] = [ ]

enum {
	IDLE,
	RUN,
	ROLL,
	TAKE,
	EAT, 
	NAVIGATE,
	ATTACK
	}

signal player_death()
signal respawn
signal increase_stamina(quant:int)
signal update_stamina
signal stamina_returning
signal fight_ended #used to return process of the enemy, emitted in fight script
var take_anim
var direction = Vector2.DOWN
var speed = Vector2.ZERO
var current_state = IDLE
var able_to_input = true
var enter_state = true
var roll_vector = Vector2.DOWN
var take_type
var in_collect_area = false #for interactions using e like collecting honey and fruits
var item_interactions = [] #interactive itens player has interacted
var able_to_interact #for interactable, need to be in interact area
var point
var current_dialogue = 0
var acts = 0
var tile_maps = [ "AtlanticNav", "BeachNav", "MarshNav"]
#--Tutorial--#
var not_moved = true
signal first_move()
var not_rolled = true
signal first_roll()
var not_taked = true
signal first_take()
var not_eated = true
signal first_eat()

func _ready():
	if !Main.debug_version:
		position = Main.spawn_position
		set_physics_process(false)
	Main.set("player", self)
	animationTree.active = true
	$RollHitbox/CollisionShape2D.disabled = true
	$TakeHitbox/CollisionShape2D.disabled = true

func _physics_process(delta):
	match current_state:                  
		IDLE:
			idle_state(delta)
		RUN:
			run_state(delta)
		ROLL:
			roll_state(delta)
		TAKE:
			take_state(delta)
		EAT:
			eat_state(delta)
		NAVIGATE:
			navigate_state(point, delta)
		ATTACK:
			attack_state(delta)

func move():
	set_velocity(speed)
	move_and_slide()
	
func set_state(new_state):
	if new_state != current_state:
		enter_state = true
	current_state = new_state

func set_taking(type_take: String):
	in_collect_area = true
	take_anim = type_take

	
#---------STATE FUNCTIONS------------#
func idle_state(delta):
	animation_state.travel("Idle")
	$ShadowAnim.play("Idle")
	speed = speed.move_toward(Vector2.ZERO, ATRITO * delta)
	move()
	set_state(check_idleState())
	
func run_state(delta):
	roll_vector = direction
	animationTree.set("parameters/Run/blend_position", direction)
	animationTree.set("parameters/Idle/blend_position", direction)
	animationTree.set("parameters/Roll/blend_position", direction)
	animationTree.set("parameters/Collect/blend_position", direction)
	animationTree.set("parameters/TakeMid/blend_position", direction)
	animationTree.set("parameters/Eat/blend_position", direction)
	animationTree.set("parameters/TakeDown/blend_position", direction)
	animationTree.set("parameters/FireAttack/blend_position", direction)
	animation_state.travel("Run")
	$ShadowAnim.play("Run")
	speed = speed.move_toward(direction * MAX_SPEED, ACCELARATION * delta)
	emit_signal("update_stamina", -0.05)
	move()
	set_state(check_runState())

func roll_state(delta):
	speed = roll_vector * ROLL_SPEED
	animation_state.travel("Roll")
	
	emit_signal("update_stamina", -0.20)
	move()

func take_state(delta):
	if take_anim == "Collect":
		animation_state.travel("Collect")
	elif take_anim == "TakeMid":
		animation_state.travel("TakeMid")
	elif take_anim == "TakeDown":
		animation_state.travel("TakeDown")
	else:
		print("takeanim doesnt exist")

func eat_state(delta):
	animation_state.travel("Eat") 
	if enter_state:
		emit_signal("increase_stamina",  JsonData.item_data[hotbar.active_item_name]["Revigoration"] )
		PlayerStats.regenerate(JsonData.item_data[hotbar.active_item_name]["Regeneration"])
		enter_state = false
#	emit_signal("update_stamina")
	emit_signal("stamina_returning") #reset returning to true

func navigate_state(point, delta):
	accelerate_towards_point(point, delta)
	check_navigate_state()
	move()
	animation_state.travel("Run")
	$ShadowAnim.play("Run")
	animationTree.set("parameters/Run/blend_position", direction)
	animationTree.set("parameters/Idle/blend_position", direction)

func attack_state(delta):
	if hotbar.active_item_name == "Tocha":
		animation_state.travel("FireAttack")
		hotbar.recharge_slot()

#--------------CHECK FUNCTIONS----------------#

func check_idleState():
	var new_state = current_state
	direction.x = Input.get_action_strength('d') - Input.get_action_strength('a')
	direction.y = Input.get_action_strength('s') - Input.get_action_strength('w')
	direction = direction.normalized()
	if able_to_input:
		if direction!= Vector2.ZERO:
				new_state = RUN
				
				if not_moved and Main.tutorial_step == 0:
					emit_signal("first_move")
					not_moved = false
				
		elif Input.is_action_just_pressed("r"):
			new_state = ROLL
			
			if not_rolled and Main.tutorial_step == 1:
				emit_signal("first_roll")
				not_rolled = false
			
		elif Input.is_action_just_pressed("e") and in_collect_area == true: #also changed in bush script
			new_state = TAKE
			if not_taked and Main.tutorial_step == 2:
				emit_signal("first_take")
				not_taked = false
		elif Input.is_action_just_pressed("e") and able_to_interact:
			$InteractionArea/CollisionShape2D.set_deferred("disabled", false)
			var tween = create_tween()
			tween.tween_property($InteractionArea/CollisionShape2D, "disabled", true, 0.2)
		elif Input.is_action_just_pressed("Attack") and hotbar.active_item_type == "Ferramenta":
			if Main.allowed_to_attack == true:
				new_state = ATTACK
		elif Input.is_action_just_pressed("f"):
			if hotbar.verify_able_to_eat():
				new_state = EAT
				if not_eated and Main.tutorial_step == 3:
					emit_signal("first_eat")
					not_eated = false
	return new_state

func check_runState():
	var new_state = current_state
	direction.x = Input.get_action_strength('d') - Input.get_action_strength('a')
	direction.y = Input.get_action_strength('s') - Input.get_action_strength('w')
	direction = direction.normalized()
	if able_to_input:
		if direction == Vector2.ZERO:
			new_state = IDLE
		elif Input.is_action_just_pressed("r"):
				new_state = ROLL
				if not_rolled and Main.tutorial_step == 1:
					emit_signal("first_roll")
					not_rolled = false
		return new_state

func check_rollState():
	speed = speed * 0.8
	current_state = IDLE

func check_takeState():
	current_state = IDLE
	in_collect_area = false #test

func check_eatState():
	current_state = IDLE

func  check_navigate_state():
	if nav_agent.is_navigation_finished():
		if current_dialogue == 2:
			set_taking("TakeDown")
			current_state = TAKE
			Main.player.set_able_to_input(true)

func check_attackState():
	current_state = IDLE

func accelerate_towards_point(point, delta):
	nav_agent.target_position = point
	direction = to_local(nav_agent.get_next_path_position()).normalized()
	speed = speed.move_toward( direction * MAX_SPEED, ACCELARATION * delta)

func _on_interaction_area_area_entered(area):
	if area.interaction_type == "item":
		if item_interactions.has(area.name):
			return
		else:
			item_interactions.insert(0, area.name)

func set_able_to_input(boolean):
	able_to_input = boolean



func instance_smoke(pos: Vector2):
	var New_smoke = load("res://Player/Tools/TorchSmoke.tscn")
	var new_smokeInstance = New_smoke.instantiate()
	get_parent().call_deferred("add_child", new_smokeInstance) #The method call_deferred() calls the method on the object during idle time.	# Its first parameter is method name string and other parameters are methods parameters.
	new_smokeInstance.global_position = pos + global_position
	Main.allowed_to_attack = false


func stop_process():
	$Footsteps.stop()
	set_physics_process(true)
	

func return_process():
	set_physics_process(true)
	set_state(0)

func reset_after_dying():
	hotbar.reset_inventory()
	emit_signal("update_stamina", 1000)
	emit_signal("respawn") #to return soundtrack
	able_to_input = true
	hurtbox.set_collision_mask_value(8, true)
	PlayerStats.set_health(6)
	PlayerStats.set_max_health(6)
	current_state = IDLE

#---------HEALTH----------#
func _on_hurtbox_invincibility_started():
	blink_anim.play("Start")

func _on_hurtbox_area_entered(area):
	PlayerStats.health -= area.damage 
	sound.stream = load("res://SoundFx/PlayerDamage.wav")
	sound.play()
	if PlayerStats.health == 0:
		hurtbox.set_collision_mask_value(8, false)
		Main.death_cause = area.name
		emit_signal("player_death") #instance gameover_scene in user interface
	else:
		hurtbox._start_invincibility(0.6, false)

#-----------AUDIO---------------#

func footsteps_audio():
	for i in tile_maps.size():
		var tile = get_parent().get_node("YSort/" + tile_maps[i])
		var tile_position = tile.local_to_map(global_position)

		
		var verify_tile = tile.get_cell_source_id(0, tile_position, true) #-1 if null, 0 if exists
		if verify_tile == 0:
			$Footsteps.volume_db = randi_range(-12, -8)
			$Footsteps.pitch_scale = randf_range(0.95 ,1.05)
			$Footsteps.stream = load("res://SoundFx/" + tile_maps[i] + "Footsteps.wav" )
			$Footsteps.play()
			break


func take_fruit_audio():
	sound.stream = load("res://SoundFx/TakingFruits.wav")
	sound.play()

func eat_audio():
	sound.stream = load("res://SoundFx/Eating.wav")
	sound.play()

#---------------DIALOGUE--------------#
func act1():
	point = Vector2(1120, 840)
	current_state = NAVIGATE
#	Dialogue.set_visibility(false, false)
	get_parent().instance_indians()


func _on_coutdown_countdown_finished():
	set_physics_process(true)
