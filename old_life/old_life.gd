extends Area2D

func start_at(_position) -> void:
	global_position = _position

func _on_OldLife_body_entered(body: PhysicsBody2D) -> void:
	if body.name == ConstManager.BODY_SHIP_NAME: 
		DebugManager.debug(name,"ship entered old life")