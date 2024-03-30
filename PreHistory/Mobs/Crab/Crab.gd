extends CharacterBody2D

@onready var anim = $Texture
@onready var soft_collision = $SoftCollision
@onready var detection =  $PlayerDetection
@onready var wander_ctrl = $WanderController
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@export var ACCELARATION = 300
@export var MAX_SPEED = 50
@export var WANDER_TARGET_RANGE = 4
#@export var FRICTION = 1200

enum {
	IDLE,
	WANDER,
	CHASE,
	ENTERING}

var state = IDLE
var speed = Vector2.ZERO
var den_position
var closest_den = 100000
var closest_den_position

func playing():
	anim.playing = true
	set_physics_process(true)
	
func _physics_process(delta): 
	match state:
		IDLE:
			anim.play("Idle")
			speed = (Vector2.ZERO)
			seek_player()
			
			if wander_ctrl.get_time_left() == 0:
				update_wander()
				
		WANDER:
			anim.play("Move")
			seek_player()
			accelerate_towards_point(wander_ctrl.target_position, delta)
			
			if nav_agent.is_navigation_finished():
				update_wander()
			
			
		CHASE:
			anim.play("Move")
			accelerate_towards_point(den_position , delta)
			MAX_SPEED = 140
		ENTERING:
			anim.play("Entering")
			
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
	set_velocity(speed)
	move_and_slide()

	
func accelerate_towards_point(point, delta):
	nav_agent.target_position = point
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	anim.flip_h = speed.x < 0 
	speed = speed.move_toward( direction * MAX_SPEED, ACCELARATION * delta)

	
func seek_player():
		if detection.can_see_player():
			state = CHASE

func update_wander():
		state = pick_random_state([IDLE, WANDER])
		wander_ctrl.start_wander_timer(randf_range(0.5, 1.5))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func state_entering(): 
	state = ENTERING

func find_closest_den(): 
	var den_array = get_parent().get_parent().get_node("Dens").positions
	for i in range(den_array.size()):
		var distance = position.distance_to(den_array[i])
		if distance < closest_den:
			closest_den = distance
			closest_den_position = Vector2(den_array[i])
			den_position = closest_den_position
	return den_position



func _on_texture_animation_finished(): #Entering anim
	visible = false
	set_physics_process(false)
