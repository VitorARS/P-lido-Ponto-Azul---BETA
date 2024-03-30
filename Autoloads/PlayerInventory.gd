extends Node

signal active_item_updated
@onready var item_node = find_child("res://prefabs/Item.tscn")
const SlotClass = preload("res://UI/PlayerUI/Slot.gd")
const ItemClass = preload("res://UI/PlayerUI/Item.gd")
#const HotbarClass = preload("res://scripts/HotbarSlot.gd")
const NUM_HOTBAR_SLOTS = 8

var active_item_slot = 0

var hotbar = {
	0: ["Amoras Silvestres", 3],



}

func _ready():
	if Main.debug_version == false:
		hotbar.clear()

func add_item(item_name, item_quantity):
	if able_to_put_hotbar(item_name) ==  true:
		put_in_hotbar_slots(item_name, item_quantity)

func update_slot_visual(slot_index, item_name, new_quantity):
	var slot = get_tree().root.get_node("/root/Prehistory/UserInterface/PlayerUI/Hotbar/GridContainer/HotbarSlot"+ str(slot_index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, new_quantity)
		
	else:
		slot.initialize_item(item_name, new_quantity)
		


func remove_item(slot: SlotClass):
	hotbar.erase(slot.slot_index)


func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	hotbar[slot.slot_index] = [item.item_name, item.item_quantity]

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	hotbar[slot.slot_index][1] += quantity_to_add
	#emit_signal("active_item_updated")

###
### Hotbar Related Functions
func active_item_scroll_up() -> void:
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	emit_signal("active_item_updated")

func active_item_scroll_down() -> void:
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated")
	
func put_in_hotbar_slots(item_name, item_quantity):
	var indices
	if hotbar.size() == 0:
		indices = 0
	else:
		var slot_indices: Array = hotbar.keys()
		slot_indices.sort()
		indices = slot_indices
		

	for item in indices:
		if hotbar[item][0] == item_name: #verifica se o item já existe
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - hotbar[item][1]
			if able_to_add >= item_quantity:
				hotbar[item][1] += item_quantity
				update_slot_visual(item, hotbar[item][0], hotbar[item][1])
				return
				
			else:
				
				hotbar[item][1] += able_to_add
				update_slot_visual(item, hotbar[item][0], hotbar[item][1])
				item_quantity = item_quantity - able_to_add
	# item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(NUM_HOTBAR_SLOTS):
		if hotbar.has(i) == false:
			hotbar[i] = [item_name, item_quantity]
			update_slot_visual(i, hotbar[i][0], hotbar[i][1])
			if active_item_slot == i:
				emit_signal("active_item_updated")
			return

func able_to_put_hotbar(item_name):
	var is_able
	for i in range(NUM_HOTBAR_SLOTS):
		if hotbar.has(i) == true and hotbar[i][0] != item_name:#verifica se ja existe E se nao tem vazios
			is_able = false
		else:
#			if hotbar[i][0] != item_name: #is going to play sound only if new item is added
#				emit_signal("active_item_updated")
			is_able = true
	return is_able

