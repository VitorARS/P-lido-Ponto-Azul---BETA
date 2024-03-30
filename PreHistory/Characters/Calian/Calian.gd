extends CharacterBody2D

@export var interaction :Array[String] 
@export var ACCELARATION = 300
@export var MAX_SPEED = 50

@export var FRICTION = 200

@onready var anim_tree = $AnimationTree
@onready var animationState = $AnimationTree.get("parameters/playback")
@onready var nav_agent := $Navigation/NavigationAgent2D as NavigationAgent2D
@onready var start_position = global_position
@onready var target_position = global_position
 

enum {
	IDLE,
	WANDER,
	FOLLOW
}

var is_colliding = false
var home_pos
var direction
var state = IDLE
var speed = Vector2.ZERO
var diference = 45
var stop_wander = false

func _ready():
	Main.set("calian", self)
	anim_tree.active = true
	home_pos = position

func _physics_process(delta):
	match state:
		IDLE:
			animationState.travel("Idle")
			$ShadowAnim.play("Idle")
			speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
		FOLLOW:
			if nav_agent.is_navigation_finished() or stop_wander:
				state = IDLE
			elif position.distance_to(target_position) <= 100:
				animationState.travel("Walk")
				$ShadowAnim.play("Running")
				MAX_SPEED = 50
			else:
				animationState.travel("Run")
				$ShadowAnim.play("Running")
				$ShadowAnim.speed_scale = 1
				MAX_SPEED = 90
			accelerate_towards_point(target_position, delta)

	anim_tree.set("parameters/Run/blend_position", direction)
	anim_tree.set("parameters/Idle/blend_position", direction)
	anim_tree.set("parameters/Walk/blend_position", direction)
	if !is_colliding:
		set_velocity(speed)
		move_and_slide()


func accelerate_towards_point(point, delta):
	nav_agent.target_position = point
	direction = to_local(nav_agent.get_next_path_position()).normalized()
	speed = speed.move_toward( direction * MAX_SPEED, ACCELARATION * delta)


func _on_anajé_follow_me(pos):
	target_position = pos + Vector2(randf_range(-diference, diference), randf_range(-diference, diference))
	state = FOLLOW
		


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if state == IDLE:
		velocity = speed
	else:
		velocity = safe_velocity


func _on_area_2d_body_entered(body):
	if state == IDLE:
		is_colliding = true

func _on_area_2d_body_exited(body):
	is_colliding = false

