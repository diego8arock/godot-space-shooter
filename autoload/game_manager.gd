extends Node

#Configuration
var use_crosshair_as_pivot = true
 
#Game nodes
var game 
var grid
var player_init_position 
var enemy_container
var stats_gui
var damage_container
var explosion_container

#Level
var level : int = 1
var max_level

#Player objects
var player
var player_pivot
var crosshair
var player_gui
var stats = { "Armor" : 0, "Speed" : 0, "Attack" : 0, "Power" : 0, "Combo" : 0  }
var skills = {}
var stats_temp = { "Armor" : 0, "Speed" : 0, "Attack" : 0, "Power" : 0, "Combo" : 0  }

#Player variables
var player_lifes : int = 1
var player_last_position : Vector2
var player_last_level : int
var is_player_alive : bool = true
var player_xp : int = 0
var temp_player_xp : int = 0
var player_level : int = 1
var lost_player_xp : int = 0
var player_health : float = 0.0
var temp_player_health : float = 0.0

#Gameplay variables
const boss_every_level : int = 5

#Enemies variables
onready var enemy_aim_to

func _ready() -> void:
	var root = get_tree().get_root()
	if root.has_node(ConstManager.GAME_NODE_NAME):
		game = root.get_node(ConstManager.GAME_NODE_NAME)
		
	if game:
		player_init_position = game.get_node(ConstManager.PLAYER_INITIAL_POSITION)
		enemy_container = game.get_node(ConstManager.ENEMIES_NODE_NAME)

func is_enemy_to_attack() -> bool:
	return enemy_container and is_player_alive
	
func copy_stats_to_temp() -> void:
	stats_temp["Armor"] = stats["Armor"]
	stats_temp["Speed"] = stats["Speed"]
	stats_temp["Attack"] = stats["Attack"]
	stats_temp["Power"] = stats["Power"]
	stats_temp["Combo"] = stats["Combo"]
	
func copy_temp_to_stats() -> void:
	stats["Armor"] = stats_temp["Armor"]
	stats["Speed"] = stats_temp["Speed"]
	stats["Attack"] = stats_temp["Attack"]
	stats["Power"] = stats_temp["Power"]
	stats["Combo"] = stats_temp["Combo"]

func create_bullet_explosion(_pos : Vector2) -> void:
	explosion_container.create_bullet_explosion(_pos)

func create_damage(_pos : Vector2, _scale : float = 1.0) -> void:
	explosion_container.create_damage_explosion(_pos)
	yield(get_tree().create_timer(0.5), "timeout")
	damage_container.create_damage(_pos, _scale)