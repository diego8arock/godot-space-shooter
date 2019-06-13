extends NPC

func _ready() -> void:
	._ready()
	states_map = {
		"idle" : $States/Idle,
		"shoot_bullets" : $States/ShootBullet,
		"shoot_missile" : $States/ShootMissile
	}
	states_stack.push_back($States/Idle)
	current_state = states_stack[0]
	_change_state("idle")
	
func _process(delta: float) -> void:
	
	aim_at_player(delta)
	
	._process(delta)
		
func _on_Turret_area_entered(area: Area2D) -> void:
	process_area_entered(area)

func aim_at_player(_delta : float) -> void:		
	if  GameManager.is_enemy_to_attack():
		var target_dir = (GameManager.enemy_aim_to.global_position - global_position).normalized()
		var current_dir = Vector2(1, 0).rotated($Pivot.global_rotation)
		$Pivot.global_rotation = current_dir.linear_interpolate(target_dir, stats.speed * _delta).angle()	
