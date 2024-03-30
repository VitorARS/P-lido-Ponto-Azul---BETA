extends CharacterBody2D

@onready var texture = $Texture
@onready var player_det = $PlayerDetection
@onready var soft_collision = $SoftCollision
@onready var wander_ctrl = $WanderController
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@export var ACCELARATION = 300
@export var MAX_SPEED = 50
@export var WANDER_TARGET_RANGE = 4
@export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}
var state = IDLE
var speed = Vector2.ZERO

func playing():
	$texture.playing = true
	set_physics_process(true)
	
func _physics_process(delta): 
	match state:
		IDLE:
			texture.play("Idle")
			speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			if wander_ctrl.get_time_left() == 0:
				update_wander()
				
		WANDER:
			texture.play("Move")
			seek_player()
			if wander_ctrl.get_time_left() == 0:
				update_wander()
				
			accelerate_towards_point(wander_ctrl.target_position, delta)
			
			
			if global_position.distance_to( wander_ctrl.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			
		CHASE:
			texture.play("Move")
			var player = player_det.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
				
			else: 
				state = IDLE
			texture.flip_h = speed.x < 0 
	if soft_collision.is_colliding():
		speed += soft_collision.get_push_vector() * delta * 400
	set_velocity(speed)
	move_and_slide()
	
func accelerate_towards_point(point, delta):
	nav_agent.target_position = point
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	speed = speed.move_toward( direction * MAX_SPEED,ACCELARATION * delta)
	texture.flip_h = speed.x < 0 
	
	
func seek_player():
		if player_det.can_see_player():
			state = CHASE

func update_wander():
		state = pick_random_state([IDLE, WANDER])
		wander_ctrl.start_wander_timer(randf_range(0.5, 1.5))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

