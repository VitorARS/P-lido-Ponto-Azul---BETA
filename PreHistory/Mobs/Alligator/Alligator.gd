extends CharacterBody2D

signal stop_soundtrack #change both, not cool
signal return_soundtrack
var player_entered = false

@export var ACCELARATION = 300
@export var MAX_SPEED = 50
@export var WANDER_TARGET_RANGE = 1  #a distancia q ele deve estar do "alvo"
@export var FRICTION = 200

@onready var anim_tree = $AnimationTree
@onready var animationState = $AnimationTree.get("parameters/playback")
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@export var wander_range= 250
@onready var start_position = global_position
@onready var target_position = global_position
@export var cast_direction = "front"


enum {
	IDLE,
	WANDER,
	}

var player_body
var home_pos
var direction
var state = IDLE
var speed = Vector2.ZERO

func _ready():
	anim_tree.active = true
	$WanderTimer.start(randf_range(5, 8))
	home_pos = position

func _physics_process(delta):
	match state:
		IDLE:
			animationState.travel("Idle")
			speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
			if $WanderTimer.get_time_left() == 0:
				state = WANDER
				$SafetyTimer.start()
				create_target()
				
		WANDER:
			animationState.travel("Walk")
			accelerate_towards_point(target_position, delta)
			if nav_agent.is_navigation_finished() or $SafetyTimer.get_time_left() == 0:
				state = IDLE
				$WanderTimer.start(randf_range(1, 6))
	
	direction = to_local(nav_agent.get_next_path_position()).normalized()
	anim_tree.set("parameters/Walk/blend_position", direction)
	anim_tree.set("parameters/Idle/blend_position", direction)
	set_velocity(speed)
	move_and_slide()

func accelerate_towards_point(point, delta):
	nav_agent.target_position = point
	speed = speed.move_toward( direction * MAX_SPEED, ACCELARATION * delta)


func _on_player_detection_body_entered(body):
	if body.name == "Player" and player_entered == false:
		Main.current_enemy = "jacare"
		var new_fight_scene = load("res://UI/FightScreen.tscn")
		var new_fight_scene_instance = new_fight_scene.instantiate()
		Main.user_interface.call_deferred("add_child", new_fight_scene_instance)
		Main.user_interface.set_process_unhandled_input(false)
		
		set_physics_process(false)
		player_entered = true
		body.connect("fight_ended", Callable(self, "return_process")) 
		emit_signal("stop_soundtrack")

func return_process():
	state = IDLE
	$WanderTimer.start(randf_range(5, 8))
	set_physics_process(true)
	print("returnsoundtrack")
	emit_signal("return_soundtrack") #not cool

func create_target():
	var target_vector = Vector2(randf_range(-wander_range, wander_range), randf_range(-wander_range, wander_range))
	target_position = start_position + target_vector
#
#func _on_wander_timer_timeout():
#	if state == IDLE:
#		create_target()
