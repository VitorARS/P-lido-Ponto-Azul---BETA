extends Panel

signal info_box(index)
signal toggle_off
var default_tex = preload("res://UI/PlayerUI/DefaultSlot.png")
var empty_tex = preload ("res://UI/PlayerUI/EmptySlot.png")
var selected_tex = preload("res://UI/PlayerUI/SelectedSlot.png"  )
var hold_pos_const = Vector2(30, 34)
var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null
var ItemClass = preload("res://UI/PlayerUI/Item.tscn")
var item = null
var slot_index

enum SlotType {
	HOTBAR = 0,
	INVENTORY
}

var slotType = null

func _ready():
	connect("mouse_entered", Callable(self, "set_info_box"))
	connect("mouse_exited", Callable(self, "toggle_off_box"))
	connect("info_box", Callable(get_parent().get_parent(), "on_info_box" ))
	connect("toggle_off", Callable(get_parent().get_parent(), "on_toggle_off" ))
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	selected_style.texture = selected_tex
	refresh_style()

func refresh_style():
	
	if slotType == SlotType.HOTBAR and PlayerInventory.active_item_slot == slot_index:
		set('theme_override_styles/panel', selected_style)
	elif item == null:
		set('theme_override_styles/panel', empty_style)
	else:
		set('theme_override_styles/panel', default_style)
		
#func pickFromSlot():
#	remove_child(item)
#	find_parent("UserInterface").add_child(item)
#	item = null
#	refresh_style()
#
#func putIntoSlot(new_item):
#	item = new_item
#	find_parent("UserInterface").remove_child(item)
#	add_child(item)
#	refresh_style()
	
func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instantiate()
		add_child(item)
		item.set_item(item_name, item_quantity)

	else:
		item.set_item(item_name, item_quantity)
	refresh_style()

func set_info_box():
	emit_signal("info_box", slot_index)

func toggle_off_box():
	emit_signal("toggle_off")
