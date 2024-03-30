extends CharacterBody2D

@export var interaction :Array[String] = [ ]
@export var MAX_SPEED = 100
@export var ACCELARATION = 350
@export var ATRITO = 400
@export var ROLL_SPEED = 125
enum {
	IDLE,
	RUN,
	ROLL,
	TAKE,
	EAT,
	NAVIGATE,
	WALK, 
	ATTACK
}
@onready var  nav_agent = $NavigationAgent2D as NavigationAgent2D
@onready var shadow_anim = $ShadowAnim
@onready var anim = $Anim
@onready var animationTree = $AnimationTree
@onready var hurtbox = $Hurtbox
@onready var blink_anim = $BlinkAnimationPlayer
@onready var collision = $Collision
@onready var animation_state = $AnimationTree.get("parameters/playback")
@onready var stamina_node = get_parent().get_parent().get_node("UserInterface/Stamina")
@onready var hotbar = get_parent().get_parent().get_node("UserInterface/Hotbar")
@onready var sound = $GeneralSound

var tile_maps = ["Marsh", "Atlantic", "BeachSand"]
var able_to_interact
var item_interactions = []
signal update_stamina
signal eat_instructions
signal died(cause)
signal stamina_returning
signal increase_stamina
signal fight_ended #used to return process of the enemy, emitted in fight script
var direction = Vector2.ZERO
var speed = Vector2.ZERO
var current_state = IDLE
var roll_vector = Vector2.LEFT
var enter_state = true
var able_taking = false
var not_moved = true
signal first_move()
var not_roll = true
signal first_roll()
var not_taked = true
signal first_take()
var not_eated = true
signal first_eat()
var acts = 0
var indians_instanced
var in_action_zone = false


var fruit_node
var take_anim
var able_to_input = true
var point
var path : Array
var current_dialogue = 0

func _ready():
	set_physics_process(false)
	Main.set("player", self)
	animationTree.active = true
	if Main.debug_version:
		MAX_SPEED = 250 #100 
		set_debug_step()
#	$Hurtbox/CollisionShape2D.disabled = true

func set_debug_step():
	if Main.start_step > 0:
		PlayerInventory.add_item("Amuleto", 1)
#		position = Vector2(1245,1120) 
#		position = Vector2(-1245,0) #falesia
		get_parent().instance_indians()
		acts = 1

func on_indians_instance_finished(): #connected by anaje
	if Main.start_step > 1:
		if Main.start_step == 2:
			Dialogue.set_visibility(true)
			Dialogue.add_dialogue(Main.anaje.interaction,4, "Anajé", "Happy",true, true)
		Main.anakin.stop_wander = true
		Main.calian.stop_wander = true
		Main.anaje.stop_wander = true
	if Main.start_step > 2:
		Main.anakin.stop_wander = false
		Main.anakin.target_position = Vector2(870, -200)
		Main.anakin.set_state(3)
		if Main.start_step == 3:
			acts = 5
			Main.player.position = Vector2(900,-615)
			Main.anaje.position = Vector2(900,-615)
			Main.anakin.position = Vector2(870,-580)
			Main.calian.position = Vector2(870,-615)
			Dialogue.set_visibility(true)
			Dialogue.add_dialogue(Main.anaje.interaction, 11, "Anajé", "",true, true)

	


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
		WALK:
			walk_state(delta)
		ATTACK:
			attack_state(delta)

func set_state(new_state):
	if new_state != current_state:
		enter_state = true
	current_state = new_state

func set_taking(type_take: String):
	able_taking = true
	take_anim = type_take

func idle_state(delta):
	animation_state.travel("idle")
	shadow_anim.play("idle")
	speed = speed.move_toward(Vector2.ZERO, ATRITO * delta)
	move()
	$Footsteps.stop()
	set_state(check_idleState())
	

func run_state(delta):
	roll_vector = direction
	animationTree.set("parameters/roll/blend_position", direction)
	animationTree.set("parameters/run/blend_position", direction)
	animationTree.set("parameters/idle/blend_position", direction)
	animationTree.set("parameters/take_fruit/blend_position", direction)
	animationTree.set("parameters/take_floor/blend_position", direction)
	animationTree.set("parameters/eat/blend_position", direction)
	animationTree.set("parameters/FireAttack/blend_position", direction)
	animationTree.set("parameters/take_mid/blend_position", direction)
	animation_state.travel("run")
	shadow_anim.play("run")
	speed = speed.move_toward(direction * MAX_SPEED, ACCELARATION * delta)
	emit_signal("update_stamina", -0.05)
	move()
	set_state(check_runState())
	
func roll_state(delta):
	Main.stamina -= 0.15
	emit_signal("update_stamina", -0.05)
	speed = roll_vector * ROLL_SPEED
	animation_state.travel("roll")
	move()
 
func take_state(delta):
	if take_anim == "fruit":
		animation_state.travel("take_fruit")
	elif take_anim == "floor":
		animation_state.travel("take_floor")
	elif take_anim == "mid":
		animation_state.travel("take_mid")

func eat_state(delta):
	animation_state.travel("eat") 
	if enter_state:
		var tween = create_tween()
		emit_signal("increase_stamina",  JsonData.item_data[hotbar.active_item_name]["Revigoration"] )
		PlayerStats.regenerate(JsonData.item_data[hotbar.active_item_name]["Regeneration"])
		enter_state = false
#	emit_signal("update_stamina")
	emit_signal("stamina_returning") #reset returning to true

func navigate_state(point, delta):
	accelerate_towards_point(point, delta)
	check_navigate_state()
	move()
	animation_state.travel("run")
	shadow_anim.play("run")
	animationTree.set("parameters/run/blend_position", direction)
	animationTree.set("parameters/idle/blend_position", direction)

func walk_state(delta):
	animation_state.travel("Walk")
	animationTree.set("parameters/Walk/blend_position", direction)
	shadow_anim.play("idle")
	speed = speed.move_toward(direction * MAX_SPEED * 0.6, ACCELARATION * delta)
	Main.stamina -= 0.025
	emit_signal("update_stamina", -0.05)
	move()
	set_state(check_walkState())

func attack_state(delta):
	if hotbar.active_item_name == "Tocha":
		animation_state.travel("FireAttack")
		hotbar.recharge_slot()
func move():
	set_velocity(speed)
	move_and_slide()



#CHECK FUNCTIONS!!
func check_idleState():
	var new_state = current_state
	direction.x = Input.get_action_strength('d') - Input.get_action_strength('a')
	direction.y = Input.get_action_strength('s') - Input.get_action_strength('w')
	direction = direction.normalized()
	if able_to_input:
		if direction!= Vector2.ZERO:
			if Input.is_action_pressed("shift"):
				new_state = WALK
			else:
				new_state = RUN
			if not_moved and Main.lesson_index == 0:
				emit_signal("first_move")
				not_moved = false
			
		elif Input.is_action_just_pressed("Attack") and hotbar.active_item_type == "Ferramenta":
			if Main.allowed_to_attack == true:
				new_state = ATTACK
		elif Input.is_action_just_pressed("r"):
			new_state = ROLL
			if not_roll and Main.lesson_index == 1:
				emit_signal("first_roll")
		elif Input.is_action_just_pressed("e") and able_taking == true:
			new_state = TAKE
			
			if not_taked and Main.lesson_index == 2:
				emit_signal("first_take")
				
				not_taked = false
		elif Input.is_action_just_pressed("e") and able_to_interact:
			$InteractionArea/CollisionShape2D.set_deferred("disabled", false)
			var tween = create_tween()
			tween.tween_property($InteractionArea/CollisionShape2D, "disabled", true, 0.2)
	
		elif Input.is_action_just_pressed("f") and !in_action_zone:
			if hotbar.verify_able_to_eat():
				new_state = EAT
				if not_eated and Main.lesson_index == 3:
					emit_signal("first_eat")
		elif Input.is_action_pressed("test_key"):
			hotbar.delete_item("Amuleto", 1)
	
					

		
		return new_state
		
func check_runState():
	var new_state = current_state
	direction.x = Input.get_action_strength('d') - Input.get_action_strength('a')
	direction.y = Input.get_action_strength('s') - Input.get_action_strength('w')
	direction = direction.normalized()

	if Input.is_action_pressed("shift"):
		new_state = WALK
	if direction == Vector2.ZERO:
		new_state = IDLE
	elif Input. is_action_just_pressed("r"):
		new_state = ROLL
		if not_roll and Main.lesson_index == 1:
			emit_signal("first_roll")
	elif Input.is_action_just_pressed("Attack") and hotbar.active_item_type == "Ferramenta":
		if Main.allowed_to_attack == true:
			new_state = ATTACK
			
	return new_state
	
func check_rollState():
	speed = speed * 0.8
	current_state = IDLE

func check_takeState():
	current_state = IDLE

func check_eatState():
	current_state = IDLE

func check_attackState():
	current_state = IDLE

func  check_navigate_state():
	if nav_agent.is_navigation_finished():
		if current_dialogue == 2:
			set_taking("floor")
			current_state = TAKE
			able_to_input = true

func check_walkState():
	var new_state = current_state
	direction.x = Input.get_action_strength('d') - Input.get_action_strength('a')
	direction.y = Input.get_action_strength('s') - Input.get_action_strength('w')
	direction = direction.normalized()
	
	if !Input.is_action_pressed("shift"):
		new_state = RUN
	if direction == Vector2.ZERO:
		new_state = IDLE
	elif Input. is_action_just_pressed("r"):
		new_state = ROLL
	return new_state
	
func _on_Hurtbox_area_entered(area):
	PlayerStats.health -=area.damage
	sound.stream = load("res://SoundFx/PlayerDamage.wav")
	sound.play()
	if PlayerStats.health <= 0:
		hurtbox.set_collision_mask_value(10, false)
		GameOver(area.name)
	else:
		hurtbox._start_invincibility(0.6, false)

func _on_Hurtbox_invincibility_started():
	blink_anim.play("start")
func _on_Hurtbox_invincibility_ended():
	blink_anim.play("stop")


func GameOver(cause):
	able_to_input = false
	emit_signal("died", cause)

func reset_after_dying():
	hotbar.reset_inventory()
	emit_signal("update_stamina", 1000)
	able_to_input = true
	hurtbox.set_collision_mask_value(10, true)
	PlayerStats.set_health(6)
	PlayerStats.set_max_health(6)
	current_state = IDLE

func instance_smoke(pos: Vector2):
	var New_smoke = load("res://caracters/main/sprites/Externals/torch_smoke.tscn")
	var new_smokeInstance = New_smoke.instantiate()
	get_parent().call_deferred("add_child", new_smokeInstance) #The method call_deferred() calls the method on the object during idle time.	# Its first parameter is method name string and other parameters are methods parameters.
	new_smokeInstance.global_position = pos + global_position
	Main.allowed_to_attack = false

#------------------Audio-----------------------

func footsteps_audio():
	for i in tile_maps.size():
		var tile = get_parent().get_parent().get_node(tile_maps[i])
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
	


#------------------DIALOGUE-----------------------

func set_able_to_input(boolean):
	able_to_input = boolean
func act1():
	point = Vector2(1350, 1346)
	current_state = NAVIGATE
	Dialogue.set_visibility(false)
	get_parent().instance_indians()

func _on_fogueira_body_entered(body): #---1 & 2-----
	if body.name == "Player": 
		current_state = IDLE
		able_to_input = false
		Dialogue.set_visibility(true)
		Dialogue.add_dialogue(interaction, 0, "Seigan", "",true, false)
		Dialogue.add_dialogue(interaction, 1, "Seigan", "", false, true)


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

func stop_process():
	$Footsteps.stop()
	set_physics_process(true)
	

func return_process():
	set_physics_process(true)
	set_state(0)
