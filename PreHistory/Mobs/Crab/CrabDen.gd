extends Node2D

var crab 
enum {
	IDLE,
	WANDER
}

func _on_area_2d_area_entered(area):
	if area.get_parent().get_parent().name == "Crabs": 
		crab = area.get_parent()
		crab.speed = Vector2(0,0)
		crab.state_entering() #he becomes invisible by animation finished in his code
		$CheckTimer.start()

func _on_check_timer_timeout():
	if crab.detection.player == null:
		crab.visible = true
		crab.set_physics_process(true)
		crab.MAX_SPEED = 50
		crab.state = crab.pick_random_state( [IDLE, WANDER])
		$CheckTimer.stop()


