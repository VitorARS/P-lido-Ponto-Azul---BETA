extends Node2D

@onready var soundtrack = $Soundtrack

func _ready(): 
	if !Main.debug_version:
		AutoloadSounds.stop()
	$VisibilityControlers.visible = true


func instance_indians(): #Im instance direct as a child of prehistory, as opposed to the reference in which its the ysort
	var anaje = load("res://PreHistory/Characters/Anajé/Anajé.tscn")
	var anajeInstance = anaje.instantiate()
	call_deferred("add_child", anajeInstance) 
	anajeInstance.global_position = Vector2(1500, 0)
	
	var anakin = load("res://PreHistory/Characters/Anakin/Anakin.tscn")
	var anakinInstance = anakin.instantiate()
	call_deferred("add_child", anakinInstance) 
	anakinInstance.global_position = Vector2(1550, 20)
	var calian = load("res://PreHistory/Characters/Calian/Calian.tscn")
	var calianInstance = calian.instantiate()
	call_deferred("add_child", calianInstance) 
	calianInstance.global_position = Vector2(1450, 15)

	anajeInstance.follow_me.connect(Callable(anakinInstance, "_on_anajé_follow_me"))
	anajeInstance.follow_me.connect(Callable(calianInstance, "_on_anajé_follow_me"))
