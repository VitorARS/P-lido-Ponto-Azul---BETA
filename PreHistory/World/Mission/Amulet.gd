extends Area2D



func _on_area_entered(area):
	PlayerInventory.add_item("Amuleto", 1)
	#Amuleto item is deleted after in anaje script
	queue_free()
