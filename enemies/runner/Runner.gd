extends NPC

onready var ghost = preload("res://enemies/runner/RunnerGhost.tscn")

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

func _on_GhostTimer_timeout() -> void:
	var new_ghost = ghost.instance()
	GameManager.enemy_container.add_child(new_ghost)
	new_ghost.global_position = global_position
	new_ghost.global_rotation = $Sprite.global_rotation
