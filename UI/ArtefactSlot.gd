extends TextureButton

@export var artefact: String
@export var locked: bool
@export var obtained = false
@export var is_available = false #Mudar quando passar de level
@onready var item_texture = $TextureRect
@onready var label = $Label

signal connect_slot(slot_index, slot_name)

var index

func _ready():
	connect("pressed", Callable(self, "connect_slot_pressed")) #did this way because i need to send the index argument
	connect("connect_slot", Callable(get_parent().get_parent().get_parent(), "on_connect_slot" ))
	index = name.substr(4)
	disabled = true

func connect_slot_pressed():
	emit_signal("connect_slot", int(index), artefact)


