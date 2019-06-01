extends Area2D

var xp = 0
var level = 0

signal player_entered()

func set_level():
	level = 0
	level += GameManager.level

func set_xp():
	xp = 0
	xp += GameManager.player_xp

func start_at(_position) -> void:
	global_position = _position

func _on_OldLife_body_entered(body: PhysicsBody2D) -> void:
	if body.name == ConstManager.BODY_SHIP_NAME and GameManager.is_player_alive: 
		emit_signal("player_entered")

func on_Game_old_life_picked(_value) -> void:
	queue_free()	
	
func enable_collision() -> void:
	$CollisionShape2D.disabled = false