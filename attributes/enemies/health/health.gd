extends Node

var health : float = ConstManager.MAX_HEALTH

onready var gui = $EnemyGui

func take_damage(_value : float, _defense : float) -> void:
	health -= _value
	health = clamp(health, ConstManager.MIN_HEALTH, ConstManager.MAX_HEALTH)
	gui.update_healthbar(health)