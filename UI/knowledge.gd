extends Control

var xp = 0: set = set_xp #called xp for pratical reasons
var max_xp = 1000

func _ready():
	position = Vector2(100,10)
	Main.connect("xp", Callable(self, "set_xp"))
	$BookText.frame = 0
	$Info.visible = false

func set_xp(value):
	xp += value
	xp = clamp(xp, 0, max_xp)
	if xp < 10:
		$Number.text = "000" + str(xp)
	elif xp < 100:
		$Number.text = "00" + str(xp)
	elif xp < 1000:
		$Number.text = "0" + str(xp)
	else: 
		$Number.text = str(xp)

	$BookText.frame = int(xp/33.3) #1000/30 = 33.3333 só thats the progress value

func on_know_tree_enter():
	mouse_filter = MOUSE_FILTER_IGNORE

func on_know_tree_exited():
	mouse_filter = MOUSE_FILTER_PASS

func _on_texture_rect_mouse_entered():
	$Info.visible = true

func _on_texture_rect_mouse_exited():
	$Info.visible = false
