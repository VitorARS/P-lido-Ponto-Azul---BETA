extends Area2D
#Hurtbox Player

#const HitEffect  = preload ("res://arqdojogo/Effects/HitEffect.tscn")

var invincible = false: set = set_invincible

@onready var timer = $Timer
@onready var collisionShape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal ('invincibility_started' )
	else:
		emit_signal ( "invincibility_ended")
		
func _start_invincibility(duration, dead):
	timer.start(duration)
	self.invincible = true


#func create_hit_effect():
#	var effect = HitEffect.instance()
#	var main = get_tree().current_scene
#	main.add_child(effect)
#	effect.global_position = global_position 

func _on_timer_timeout():
	self.invincible = false
	
func _on_invincibility_ended():
	collisionShape.set_deferred('disabled', false)


func _on_invincibility_started():
	collisionShape.set_deferred('disabled', true)



