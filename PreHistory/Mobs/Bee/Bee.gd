extends CharacterBody2D

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D 
@onready var beehive = get_parent().get_parent()
@onready var animationState = $AnimationTree.get("parameters/playback")
@onready var hitbox = $Bee.get_node("Collision")
@export var ACCELARATION = 300
@export var MAX_SPEED = 50
@export var WANDER_TARGET_RANGE = 8
@export var FRICTION = 200

var player = null

signal bee_entered(bee_name)


var flowers_position = {
	0: Vector2(892, -278),
	1: Vector2(1030, -494),
	2: Vector2(1069, -292),
	3: Vector2(763, -389),
	4: Vector2(962, -394) #home
	
}

enum {
	IDLE,
	WANDER,
	CHASE
}
var state 
var speed = Vector2.ZERO
var flower_index
var direction


func _ready():
	connect("bee_entered", Callable(beehive, "on_bee_entered"))
	$AnimationTree.active = true
	flower_index = randi_range(0,4)
	$WanderTimer.start(randf_range(4, 6))
	state = WANDER


func _physics_process(delta): 
	match state:
		IDLE:
			MAX_SPEED = 50
			speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
			animationState.travel("Fly")
			if $WanderTimer.get_time_left() == 0:
				pick_random_state([IDLE, WANDER])

		WANDER:
			MAX_SPEED = 75
			animationState.travel("Fly")
			if $WanderTimer.get_time_left() == 0:
				pick_random_state([IDLE, WANDER])
			accelerate_towards_point( flowers_position[flower_index], delta)
			if nav_agent.is_navigation_finished():
				if flower_index == 4:
					emit_signal("bee_entered", name)
					queue_free()
				else:
					pick_random_state([IDLE, WANDER])
		CHASE:
			MAX_SPEED = 75
			animationState.travel("Fly")
			if player != null:
				accelerate_towards_point(player.global_position, delta)
				
			else: 
				state = IDLE

	if $SoftCollision.is_colliding():
		speed += $SoftCollision.get_push_vector() * delta * 400
	
	$AnimationTree.set("parameters/Fly/blend_position", direction)
	set_velocity(speed)
	move_and_slide()

func accelerate_towards_point(point, delta):
	nav_agent.target_position = point
	direction = to_local(nav_agent.get_next_path_position()).normalized()
	speed = speed.move_toward( direction * MAX_SPEED,ACCELARATION * delta)



func pick_random_state(state_list):
	state_list.shuffle()
	var new_state = state_list.pop_front()
	if new_state == IDLE:
		$WanderTimer.start(randf_range(1, 2))
	if new_state == WANDER:
		var previus_index = flower_index
		if beehive.allowed_to_return:
			flower_index = randi_range(0,4)
		else:
			flower_index = randi_range(0,3)
		if previus_index == flower_index and beehive.allowed_to_return:  
			flower_index = 4
		else:
			$WanderTimer.start(randf_range(4, 6))
	state = new_state



func _on_player_detection_body_entered(body):
	if body.name == "Player":
		player = body
		state = CHASE


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		player = null

func play_default_Sound():
	$AudioStreamPlayer.stream = load("res://SoundFx/BeeDefaultSound.wav")
	$AudioStreamPlayer.play()
	
