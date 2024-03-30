extends Node

@export var max_health = 6: set = set_max_health
var health = max_health: set = set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value) 

func _ready():
	self.health = max_health
	
func set_health( value):
	health = value
	emit_signal('health_changed', health)
#	if health <= 0:
#		emit_signal('no_health')

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal('max_health_changed', max_health )

func regenerate(value):
	if health < 6:
		health += value
		print(value, ":value")
		print(health, ":health")
		emit_signal('health_changed', health)
