extends Control

const SlotClass = preload("res://UI/PlayerUI/Slot.gd")
@onready var hotbar_slots = $GridContainer
@onready var active_item_label = $ActiveItemLabel
@onready var slots = hotbar_slots.get_children()


var able_to_eat 
var not_navigate = true
var active_item_name
var active_item_type
signal first_navigate()
var first_update = true

func _ready():
	$Description.visible = false
	$Description/Stamina.visible = false
	$Description/Heart.visible = false
	$Description/Sword.visible = false
	PlayerInventory.connect("active_item_updated", Callable(self, "update_active_item_label"))
	for i in range(slots.size()):
		PlayerInventory.connect("active_item_updated", Callable(slots[i], "refresh_style"))
#		slots[i].connect("gui_input", Callable(self, "slot_gui_input").bind(slots[i]))
		slots[i].slotType = SlotClass.SlotType.HOTBAR
		slots[i].slot_index = i
	initialize_hotbar()
	update_active_item_label()


func update_active_item_label():
	if slots[PlayerInventory.active_item_slot].item != null:
		if !first_update:
			$Sound.pitch_scale = 1
			$Sound.play()
			
		else:
			first_update = false
		active_item_name = slots[PlayerInventory.active_item_slot].item.item_name
		active_item_type = slots[PlayerInventory.active_item_slot].item.item_type
		active_item_label.text = slots[PlayerInventory.active_item_slot].item.item_name
	else:
		$Sound.pitch_scale = 0.8
		$Sound.play()
		active_item_label.text = ""
	if not_navigate and Main.tutorial_step == 4:
		emit_signal("first_navigate")
		not_navigate = false

func initialize_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i):
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])


func recharge_slot():
#	slots[PlayerInventory.active_item_slot]
	var newRechargeSlot = load("res://UI/RechargingSlot.tscn")
	var newRechargeSlotInstance = newRechargeSlot.instantiate()
	slots[PlayerInventory.active_item_slot].call_deferred("add_child", newRechargeSlotInstance)
#	new_beehiveInstance.position = Vector2(26, -65)


func  verify_able_to_eat():
	if slots[PlayerInventory.active_item_slot].item != null:
		var item_type = JsonData.item_data[slots[PlayerInventory.active_item_slot].item.item_name] ["ItemCategory"]
		if item_type == "Consumivel":
			active_item_name = slots[PlayerInventory.active_item_slot].item.item_name
			slots[PlayerInventory.active_item_slot].item.decrease_item_quantity(1)
			if slots[PlayerInventory.active_item_slot].item.item_quantity <= 0:
				PlayerInventory.remove_item( slots[PlayerInventory.active_item_slot])
				slots[PlayerInventory.active_item_slot].remove_child(slots[PlayerInventory.active_item_slot].item)
				slots[PlayerInventory.active_item_slot].item = null
				PlayerInventory.connect("active_item_updated", Callable(slots[PlayerInventory.active_item_slot], "refresh_style"))
				active_item_label.text = "" #update_active_item_label()# made it dont play sound
			return true
	else:
		return false


func reset_inventory():
	for i in range(slots.size()):
#		if slots[i].get_child_count() > 0:
		if slots[i].item != null:
			var item_type = JsonData.item_data[slots[i].item.item_name]["ItemCategory"]
			print(item_type)
			if item_type != "Informacional" and item_type != "Ferramenta":
				slots[i].item.decrease_item_quantity(slots[i].item.item_quantity)
				PlayerInventory.remove_item( slots[i])
				slots[i].remove_child(slots[i].item)
				slots[i].item = null
				initialize_hotbar()
				slots[i].refresh_style()
				active_item_label.text = ""
				active_item_type = ""
				active_item_name = ""

func on_info_box(slot_index):
	if slots[slot_index].item != null:
		var box_x_pos = -72
		$Description/ItemName.text = slots[slot_index].item.item_name
		$Description/Body.text = JsonData.item_data[slots[slot_index].item.item_name]["Description"]
		$Description.position.x = (35 * (slot_index )) + box_x_pos  # maneiro né?!/ its supposed to be 36 but god only knows
		if JsonData.item_data[slots[slot_index].item.item_name]["ItemCategory"] == "Consumivel":
			$Description/Heart.visible = true
			$Description/Stamina.visible = true
			$Description/Stamina/Label.text = "+" + str(JsonData.item_data[slots[slot_index].item.item_name]["Revigoration"] / 10) + "% de Estamina"
			$Description/Heart/Label.text = "+" +  str(JsonData.item_data[slots[slot_index].item.item_name]["Regeneration"] ) + " de Saúde"
		
		elif JsonData.item_data[slots[slot_index].item.item_name]["ItemCategory"] == "Arma":
			$Description/Sword.visible = true
			$Description/Sword/Label.text = "+" + str(JsonData.item_data[slots[slot_index].item.item_name]["Damage"] ) + " de Dano"
		$Description.visible = true
	

func on_toggle_off():
	$Description.visible = false
	$Description/Stamina.visible = false
	$Description/Heart.visible = false
	$Description/Sword.visible = false

func delete_item(item_name, item_qnt): #pra eliminar um item é necessario por sua qnt total
	if PlayerInventory.hotbar.find_key([item_name, 1]) != null:
		var item_key = PlayerInventory.hotbar.find_key([item_name, item_qnt])
		PlayerInventory.remove_item(slots[item_key])
		slots[item_key].remove_child(slots[item_key].item)
		slots[item_key].item = null
		slots[item_key].refresh_style()
		active_item_label.text = "" ##update_active_item_label( ) ##Made so it doest play the sound
		
#	PlayerInventory.connect("active_item_updated", Callable(slots[PlayerInventory.active_item_slot], "refresh_style"))
