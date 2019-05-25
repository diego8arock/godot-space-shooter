extends NPC

signal player_entered()

func start_at(_position) -> void:
	global_position = _position

func _on_OldLife_body_entered(body: PhysicsBody2D) -> void:
	if body.name == ConstManager.BODY_SHIP_NAME and GameManager.is_player_alive: 
		emit_signal("player_entered")

func on_Game_old_life_picked() -> void:
	queue_free()	