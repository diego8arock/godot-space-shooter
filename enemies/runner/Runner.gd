extends NPC

func _ready() -> void:
	._ready()
	states_map = {
		"aim" : $States/Aim,
		"run" : $States/Run,
		"adjust" : $States/Adjust
	}
	$Sprite/Line2D/Position2D.position = $Sprite/Line2D.points[1]
	$Saber.initialize(stats.attack, self, WeaponManager.GROUP_WEAPON_ENEMY)
	
	states_stack.push_back($States/Adjust)
	current_state = states_stack[0]
	_change_state("adjust")
	
func _on_Runner_area_entered(area: Area2D) -> void:
	process_area_entered(area)
