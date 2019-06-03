extends Area2D
class_name NPC, "res://interfaces/npc.gd"

export var health : float = ConstManager.MAX_HEALTH
export var base_stats : Resource

onready var stats = $Stats
onready var gui = $EnemyGui
onready var stats_debug = $EnemyStatsDebug

var id : int
var level : int
var is_initialized : bool = false

signal update_health(_value)
signal died(_xp)

func _init() -> void:
	
	pause_mode = Node.PAUSE_MODE_STOP
	
func _ready() -> void:	
	
	if is_initialized == true: return
	is_initialized = true
	stats.initialize(base_stats)
	connect("update_health", gui, "update_healthbar")
	var err = connect("update_health", GameManager.player, "on_NPC_got_hit")
	if err != 0:
		WarningManager.warn(name + "-" + str(id), "could not connect on_NPC_got_hit with player err_id: " + str(err))
	err = connect("died", GameManager.player, "on_NPC_died")
	if err != 0:
		WarningManager.warn(name + "-" + str(id), "could not connect on_NPC_died with player err_id: " + str(err))

func adjust_stats_by_level() -> void:
	stats.adjust_by_level(level)

func take_damage(_value) -> void:	

	health -= _value
	health = clamp(health, ConstManager.MIN_HEALTH, ConstManager.MAX_HEALTH)
	emit_signal("update_health", health)

func evaluate_health() -> void:
	
	if health <= ConstManager.MIN_HEALTH:
		emit_signal("died", stats.xp)
		call_deferred("free")
		
func add_stats_to_debug() -> void:
	
	stats_debug.add_stat("level", level)
	stats_debug.add_stat("xp", stats.xp)
	stats_debug.add_stat("speed", stats.speed)
	stats_debug.add_stat("attack", stats.attack)
	stats_debug.add_stat("defense", stats.defense)
	
	
	