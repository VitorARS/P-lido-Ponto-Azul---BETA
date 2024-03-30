extends Control

var item_name
var item_type
var item_quantity

func set_item(nm, qt): 
	position = Vector2(0,2)
	size = Vector2(32,32)
	item_name = nm
	item_quantity = qt
	item_type = (JsonData.item_data[item_name]["ItemCategory"])
	$TextureRect.texture = load("res://UI/ItemIcons/" + item_name + ".png")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = str(item_quantity)
		
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = str(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = str(item_quantity)
