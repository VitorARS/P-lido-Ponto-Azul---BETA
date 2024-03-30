extends Node2D

@onready var notifier := get_parent().get_parent().get_node("VisibilityControlers/Control"+name+"/VisibleOnScreenNotifier2D")


func _ready():
	notifier.connect("screen_entered", Callable(self, "show"))
	notifier.connect("screen_exited", Callable(self, "hide"))
	visible = false

