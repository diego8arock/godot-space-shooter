extends NPC

func _ready() -> void:
	._ready()
	states_map = {
		"idle" : $States/Idle,
		"send_drone" : $States/SendDrone
	}
	states_stack.push_back($States/Idle)
	current_state = states_stack[0]
	_change_state("idle")

func _on_DroneGenerator_area_entered(area: Area2D) -> void:
	process_area_entered(area)
