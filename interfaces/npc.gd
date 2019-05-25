extends Area2D
class_name NPC, "res://interfaces/npc.gd"

export var health : float = ConstManager.MAX_HEALTH
onready var stats = $Stats
onready var gui = $EnemyGui
signal update_health(_value)
signal died(_xp)

func _init() -> void:
	pause_mode = Node.PAUSE_MODE_STOP
	
func _ready() -> void:
	
	connect("update_health", gui, "update_healthbar")
	connect("update_health", GameManager.player, "on_NPC_got_hit")
	connect("died", GameManager.player, "on_NPC_died")

func take_damage(_value) -> void:	

	health -= _value
	health = clamp(health, ConstManager.MIN_HEALTH, ConstManager.MAX_HEALTH)
	emit_signal("update_health", health)

func evaluate_health() -> void:
	
	if health <= ConstManager.MIN_HEALTH:
		emit_signal("died", stats.xp)
		call_deferred("free")