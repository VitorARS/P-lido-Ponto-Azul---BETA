extends CharacterBody2D

@onready var start_position = global_position
@onready var target_position = global_position
@onready var ysort = get_parent()
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

@export var has_feather: bool
@export var ACCELARATION = 300
@export var wander_range= 32
@export var MAX_SPEED = 25
@export var FRICTION = 200
@export var grass_eat = false

enum {
	IDLE,
	WANDER,
	EATING,
	FLIGHT}

var direction
#var children_list = []
var WANDER_TARGET_RANGE = 2
var state = IDLE
var speed = Vector2.ZERO
var escape_point = Vector2(200,-140)
var facing_left = false

func _ready():
	$WanderTimer.start(randf_range(1, 6))
func _physics_process(delta): 
	match state:
		IDLE:
			$AnimationPlayer.play("Idle")
			speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
			if $WanderTimer.get_time_left() == 0:
				pick_random_state([EATING, IDLE, WANDER])
		WANDER:
			$AnimationPlayer.play("Walk")
			accelerate_towards_point(target_position, delta)
			if nav_agent.is_navigation_finished():
				pick_random_state([EATING, IDLE])
		EATING:
			speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
			$AnimationPlayer.play("Eating")
			if grass_eat == false:
				pick_random_state([IDLE, WANDER])
		FLIGHT:
			$CollisionShape2D.disabled = true
			MAX_SPEED = 325
			$AnimationPlayer.play("Flight")
			
			var dir
			if facing_left:
				dir = -1
			else:
				dir = 1
			escape(position + Vector2((escape_point.x * dir), escape_point.y) , delta)
	direction = to_local(nav_agent.get_next_path_position()).normalized()
	set_velocity(speed)
	move_and_slide()
func pick_random_state(state_list):
	state_list.shuffle()
	var new_state = state_list.pop_front()
	if new_state == IDLE:
		$WanderTimer.start(randf_range(1, 6))
	if new_state == WANDER:
		create_target()
	if new_state == EATING:
		grass_eat = true
	state = new_state
	
	
func _on_timer_timeout():
	if state == IDLE:
		create_target()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		state = FLIGHT
		$Flight.play()
		if has_feather:
			var New_feather = load("res://UI/Sprites/Artefacts/Pena.tscn")
			var new_featherInstance = New_feather.instantiate()
			ysort.call_deferred("add_child", new_featherInstance)
			new_featherInstance.global_position = global_position

func accelerate_towards_point(point, delta):
	nav_agent.target_position = point
	speed = speed.move_toward( direction * MAX_SPEED, ACCELARATION * delta)
	
func escape(point, delta):
	var direction = global_position.direction_to(point)
	speed = speed.move_toward( direction * MAX_SPEED, ACCELARATION * delta)
	facing_left = speed.x < 0 
	$Sprite2D.flip_h = speed.x < 0 

func create_target():
	var target_vector = Vector2(randf_range(-wander_range, wander_range), randf_range(-wander_range, wander_range))
	target_position = start_position + target_vector

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
