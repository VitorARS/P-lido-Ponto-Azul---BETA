extends Node

var user_interface
var debug_version = false
var spawn_position = Vector2(1024, -56)
var level = 0
var mission_step = 0
var player
var stamina = 1000
var current_enemy
var anaje
var anakin
var calian
var tutorial_step = 0
var on_tutorial = true
var got_first_artefact = false
var got_first_interaction = false
signal xp(value)
var allowed_to_attack = true #apparently its for knoback reasons, but i have to investigate that and its on main
var death_cause: String

var master_value = 0
var music_value = -12
var ambience_value = 0
var fullscreen = true
var vsync = true

