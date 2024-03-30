extends Control


func _on_interactive_area_set_interaction(int_text):
	visible = true
	$Body.text = int_text

func _on_interactive_area_toggle_visibility(boolean):
	visible = boolean
