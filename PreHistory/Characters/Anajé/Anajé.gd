extends CharacterBody2D

@export var interaction :Array[String] 
@export var ACCELARATION = 300
@export var MAX_SPEED = 50
@export var WANDER_TARGET_RANGE = 2 #a distancia q ele deve estar do "alvo"
@export var FRICTION = 200

@onready var anim_tree = $AnimationTree
@onready var wander_timer = $WanderTimer
@onready var animationState = $AnimationTree.get("parameters/playback")
@onready var nav_agent := $Navigation/NavigationAgent2D as NavigationAgent2D
@onready var mission_collision = $MissionDetection/CollisionShape2D
@export var wander_range= 220
@onready var start_position = global_position
@onready var target_position = global_position
@export var cast_direction = "front"

signal follow_me(pos)
signal indians_instance_finished
signal emit_warning(text_index)
signal free_warning
signal indian_contact
signal bee_mission
enum {
	IDLE,
	WANDER
}

var is_colliding = false
var home_pos
var direction
var state = IDLE
var speed = Vector2.ZERO
var stop_wander = false
var first_enter_in_warning = true #had to create to avoid a "body entered" signal when initialized
var mission_ended = false
func _ready():
	Main.set("anaje", self)
	connect("emit_warning", Callable(Main.user_interface, "on_emit_warning"))
	connect("emit_warning", Callable(Main.user_interface, "on_emit_warning"))
	mission_collision.disabled = true
#	if Main.debug_version:
#		connect("indians_instance_finished", Callable(Main.player, "on_indians_instance_finished"))
#		emit_signal("indians_instance_finished")
#		if Main.start_step > 0:
#			$PlayerDetection/CollisionShape2D.set_deferred("disabled", true)
	anim_tree.active = true
	wander_timer.start(randf_range(1, 6))
	home_pos = position

func _physics_process(delta):
	match state:
		IDLE:
			animationState.travel("Idle")
			speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
			if wander_timer.get_time_left() == 0:
				pick_random_state([IDLE, WANDER])

		WANDER:
			if nav_agent.is_navigation_finished() or stop_wander:
				pick_random_state([IDLE])
			elif position.distance_to(target_position) <= 100:
				animationState.travel("Walk")
				$ShadowAnim.play("Idle")
				MAX_SPEED = 50
				$ShadowAnim.speed_scale = 0.75
			else:
				animationState.travel("Run")
				MAX_SPEED = 90
				$ShadowAnim.play("Running")
				$ShadowAnim.speed_scale = 1
			accelerate_towards_point(target_position, delta)
	anim_tree.set("parameters/Run/blend_position", direction)
	anim_tree.set("parameters/Idle/blend_position", direction)
	anim_tree.set("parameters/Walk/blend_position", direction)
	if !is_colliding:
		nav_agent.set_velocity(speed)
		move_and_slide()
	

func pick_random_state(state_list):
	state_list.shuffle()
	var new_state = state_list.pop_front()
	if new_state == IDLE:
		wander_timer.start(randf_range(1, 6))
	if new_state == WANDER:
		if !stop_wander:
			create_target()
		$SafetyTimer.start()
	state = new_state

func create_target():
	var target_vector = Vector2(randf_range(-wander_range, wander_range), randf_range(-wander_range, wander_range))
	target_position = start_position + target_vector
	emit_signal("follow_me", target_position )

func accelerate_towards_point(point, delta):
	nav_agent.target_position = point
	direction = to_local(nav_agent.get_next_path_position()).normalized()
	speed = speed.move_toward( direction * MAX_SPEED, ACCELARATION * delta)


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
#safe velocity aparentely is a velocity used in order to avoid collision with other agents
	if state == IDLE:
		velocity = speed
	else:
		velocity = safe_velocity


func _on_safety_timer_timeout():
	if state == WANDER:
		state = IDLE


func _on_area_2d_body_exited(body): #prevent from dragging
	is_colliding = false

func _on_area_2d_body_entered(body): #prevent from dragging
	if state == IDLE:
		is_colliding = true

#---------------------DIALOGUE---------------------
func _on_player_detection_body_entered(body): #detecting player to continue mission
	if body.name == "Player": 
		$PlayerDetection/CollisionShape2D.set_deferred("disabled", true)
		Main.anakin.stop_wander = true
		Main.calian.stop_wander = true
		stop_wander = true
		$PlayerDetection/CollisionShape2D.set_deferred("disabled", true) 
		Main.player.current_state = IDLE
		Main.player.set_able_to_input(false)
		Dialogue.set_visibility(true)#, true
		if get_parent().has_node("Soundtrack"):
			connect("indian_contact",Callable(get_parent().soundtrack, "on_indian_contact"))
			emit_signal("indian_contact")
		Dialogue.add_dialogue(Main.player.interaction, 2, "Seigan","", true, false)
		Main.player.hotbar.delete_item("Amuleto", 1)
		Dialogue.add_dialogue(interaction,0, "Anajé", "Arching",false, false)
		Dialogue.add_dialogue(interaction,1, "Anajé", "Arching",false, false)
		Dialogue.add_dialogue(Main.player.interaction, 3, "Seigan","Fear", false, false)
		Dialogue.add_dialogue(interaction,2, "Anajé", "Happy",false, false)
		Dialogue.add_dialogue(interaction,3, "Anajé", "Happy",false, false)
		Dialogue.add_dialogue(Main.player.interaction, 4, "Seigan","", false, false)
		Dialogue.add_dialogue(interaction,4, "Anajé", "Happy",false, true)




func _on_mission_detection_body_exited(body):
	if !mission_ended:
		if body.name == "Player":
			emit_signal("emit_warning", 0)
	else:
		emit_signal("emit_warning", 2)



func _on_mission_detection_body_entered(body):
	if body.name == "Player":
		if first_enter_in_warning:
			first_enter_in_warning = false
		else:
			connect("free_warning", Callable(Main.user_interface, "on_free_warning"))
			emit_signal("free_warning")
