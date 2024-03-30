extends Control

var hearts = 6: set = set_hearts
var max_hearts = 6: set = set_max_hearts

@onready var heartUIFull = $HeartFull
@onready var heartUIEmpty = $HeartEmpty

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	$Info.visible = false
	PlayerStats.connect("health_changed", Callable(self, 'set_hearts'))
	PlayerStats.connect('max_health_changed', Callable(self, 'set_max_hearts'))

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.size.x = hearts * 16

func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.size.x = hearts * 16

func _on_regenertate_timeout(): #make it so that when regenerating more tham 0.5 hearts it has an animation
	if hearts < 6 and hearts > 0:
		if Main.stamina >= 666:
			hearts = clamp(hearts + 0.5, 0, max_hearts)
			PlayerStats.health += 0.5
#			Stats.max_health
			if heartUIFull != null:
				heartUIFull.size.x = hearts * 16


func _on_mouse_entered():
	$Info.visible = true


func _on_mouse_exited():
	$Info.visible = false
