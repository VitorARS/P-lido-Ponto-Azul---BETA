extends CharacterBody2D

@export var ACCELARATION = 300
@export var MAX_SPEED = 50
@export var WANDER_TARGET_RANGE = 1 #a distancia q ele deve estar do "alvo"
@export var FRICTION = 200

@onready var anim_tree = $AnimationTree
@onready var animationState = $AnimationTree.get("parameters/playback")
@onready var nav_agent := $Navigation/NavigationAgent2D as NavigationAgent2D
@export var wander_range= 60
@onready var start_position = global_position
@onready var target_position = global_position
@export var cast_direction = "front"

enum {
	IDLE,
	WANDER,
	RUNAWAY, 
	EATING
}

var player_body
var home_pos
var direction
var state = IDLE
var speed = Vector2.ZERO
@export var grass_eat = false # it's a export var because it is used in the key track of AnimationPlayer

func _ready():
	anim_tree.active = true
	$WanderTimer.start(randf_range(1, 6))
	home_pos = position
func _physics_process(delta):
	match state:
		IDLE:
			animationState.travel("Idle")
			speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
			if $WanderTimer.get_time_left() == 0:
#				print("idle")
				pick_random_state([EATING, IDLE, WANDER])
				
		WANDER:
			animationState.travel("Walk")
			accelerate_towards_point(target_position, delta)
			if nav_agent.is_navigation_finished():
				pick_random_state([EATING, IDLE])
		EATING:
			speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
			animationState.travel("Eating")
			if grass_eat == false:
				pick_random_state([IDLE, WANDER])
				
		RUNAWAY:
			animationState.travel("Run")
			wander_range = 120
			MAX_SPEED = 140
#			speed = speed.move_toward( direction * MAX_SPEED, ACCELARATION * delta)
			accelerate_towards_point(target_position, delta)
			if $PlayerUndetection.overlaps_body(player_body) and  nav_agent.is_navigation_finished():
				target_position = (global_position + Vector2( -150* direction.x, -150 * direction.y))
			if $PlayerUndetection.overlaps_body(player_body) == false and nav_agent.is_navigation_finished() :
				pick_random_state([IDLE])
				MAX_SPEED = 50
				wander_range = 60
#			anim_tree.set("parameters/walk/blend_position", resultante)

	direction = to_local(nav_agent.get_next_path_position()).normalized()
	anim_tree.set("parameters/Walk/blend_position", direction)
	anim_tree.set("parameters/Grass/blend_position", direction)
	anim_tree.set("parameters/Idle/blend_position", direction)
	anim_tree.set("parameters/Run/blend_position", direction)
	set_velocity(speed)
	move_and_slide()

	
func accelerate_towards_point(point, delta):
	nav_agent.target_position = point
	speed = speed.move_toward( direction * MAX_SPEED, ACCELARATION * delta)


#	if $RayCast2D.is_colliding():
#		set_cast("", true)
#
#func seek_player():
#		if $player_detection.can_see_player():
#			state = RUNAWAY
#
#func pick_new_state():
#		state = pick_random_state([IDLE, WANDER, EATING])
# #6

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

	

#func set_cast(direction: String, is_colliding):
#	match direction:
#		"back":
#			$RayCast2D.target_position.x = 0
#			$RayCast2D.target_position.y = -8
#		"front":
#a			$RayCast2D.target_position.x = 0
#			$RayCast2D.target_position.y = 8
#		"right":
#			$RayCast2D.target_position.x = 8
#			$RayCast2D.target_position.y = 0
#		"left":
#			$RayCast2D.target_position.x = -8
#			$RayCast2D.target_position.y = 0
#	if is_colliding == true:
#		state = IDLE
#		$RayCast2D.target_position.x * (-1)
#		$RayCast2D.target_position.y * (-1)


func create_target():
#	print("TargetCreated")
	var target_vector = Vector2(randf_range(-wander_range, wander_range), randf_range(-wander_range, wander_range))
	target_position = start_position + target_vector

func _on_wander_timer_timeout():
#	print("timeout")
	if state == IDLE:
		create_target()

func _on_player_detection_body_entered(body):
	#https://gamedevelopment.tutsplus.com/understanding-steering-behaviors-flee-and-arrival--gamedev-1303t
	if body.name == "Player":
		state = RUNAWAY
		var desired_velocity = ((self.position - body.position) * MAX_SPEED).normalized()
		direction = desired_velocity - velocity
		player_body = body
		target_position = (global_position + Vector2(245* direction.x,245 *direction.y))
		return body



#		var anti_vector: Vector2
#		if desired_velocity.x < 0:
#			anti_vector.x = -1
#		else:
#			anti_vector.x = 1
#		if desired_velocity.y < 0:
#			anti_vector.y = -1
#		else:
#			anti_vector.y = 1
