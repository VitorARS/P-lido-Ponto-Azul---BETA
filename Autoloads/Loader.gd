extends Node

const GAME_SCENES = {
	"cutscene": "res://MainScenes/Cutscene.tscn",
	"pre_history": "res://MainScenes/PreHistory.tscn",
	"fire_minigame": "res://PreHistory/World/Mission/fire_mission.tscn"
}
var loading_screen = preload("res://GeneralPrefabs/Loading/LoadingScreen.tscn")
var loading_icon = preload("res://GeneralPrefabs/Loading/LoadingIcon.tscn")
var loading_screen_instance
var loading_icon_instance
var load_path: String
var allowed_to_load = false
var load_type #1 = scene 2= icon
var current
var parent
func load_scene_with_screen(current_scene, next_scene):
	loading_screen_instance = loading_screen.instantiate()
	get_tree().get_root().call_deferred("add_child", loading_screen_instance)
	load_type = 1
	await  loading_screen_instance.safe_to_load
	set_physics_process(true)
	current_scene.queue_free()
	await current_scene.tree_exited

	if GAME_SCENES.has(next_scene):
		load_path = GAME_SCENES[next_scene]
	else:
		load_path = next_scene
		print("dunno exactly what this causes")
	var loader_next_scene
	if ResourceLoader.exists(load_path):
		loader_next_scene = ResourceLoader.load_threaded_request(load_path)
	else:
		print("Error: try loading non existing file")
		return
	if loader_next_scene == null:
		print("Error: non existing file")
		return

func load_scene_without_screen(current_scene, next_scene):
	loading_icon_instance = loading_icon.instantiate()
	get_tree().get_root().call_deferred("add_child", loading_icon_instance)
	current = current_scene
	set_physics_process(true)
	load_type = 2
	if GAME_SCENES.has(next_scene):
		load_path = GAME_SCENES[next_scene]
	else:
		load_path = next_scene
		print("dunno exactly what this causes")
	var loader_next_scene
	if ResourceLoader.exists(load_path):
		loader_next_scene = ResourceLoader.load_threaded_request(load_path)
	else:
		print("Error: try loading non existing file")
		return
	if loader_next_scene == null:
		print("Error: non existing file")
		return

func instance_scene_above(parent_scene, instance):
	loading_icon_instance = loading_icon.instantiate()
	get_tree().get_root().call_deferred("add_child", loading_icon_instance)
	parent = parent_scene
	set_physics_process(true)
	load_type = 3
	if GAME_SCENES.has(instance):
		load_path = GAME_SCENES[instance]
	else:
		load_path = instance
		print("dunno exactly what this causes")
	var loader_next_scene
	if ResourceLoader.exists(load_path):
		loader_next_scene = ResourceLoader.load_threaded_request(load_path)
	else:
		print("Error: try loading non existing file")
		return
	if loader_next_scene == null:
		print("Error")

func _physics_process(delta):
	if allowed_to_load:
		var load_progress = []
		var load_status = ResourceLoader.load_threaded_get_status(load_path, load_progress)
		match load_status:
			0: #Invalid resource
				print("Error: invalid stuff")
				return
			2: #Loading Failed
				print("Some crazy shit has happened")
				return
			3:
				var next_scene_instance = ResourceLoader.load_threaded_get(load_path).instantiate()
				if load_type == 1:
					get_tree().get_root().call_deferred("add_child", next_scene_instance)
					loading_screen_instance.queue_free()
				elif load_type == 2:
					get_tree().get_root().call_deferred("add_child", next_scene_instance)
					loading_icon_instance.queue_free()
					current.queue_free()
				else:
					parent.call_deferred("add_child", next_scene_instance)
					loading_icon_instance.queue_free()
				set_physics_process(false)
				allowed_to_load = false
	else:
		set_physics_process(false)
#
##
#
