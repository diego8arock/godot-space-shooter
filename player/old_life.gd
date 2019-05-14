extends Area2D

var experience : int

func start_at(_position) -> void:
	global_position = _position

func _on_OldLife_body_entered(body: PhysicsBody2D) -> void:
	pass # Replace with function body.
