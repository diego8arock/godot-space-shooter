extends Node

#Game nodes
var game 
var player_init_position 
var enemy_container
var level = 1
var max_level

#Player objects
var player
var crosshair
var player_gui

#Player variables
var player_lifes : int = 1
var player_last_position : Vector2
var is_player_alive : bool = true

#Enemies variables
onready var enemy_aim_to

#Signals
signal player_died

func _ready() -> void:
	var root = get_tree().get_root()
	if root.has_node(ConstManager.GAME_NODE_NAME):
		game = root.get_node(ConstManager.GAME_NODE_NAME)
		
	if game:
		player_init_position = game.get_node(ConstManager.PLAYER_INITIAL_POSITION)
		enemy_container = game.get_node(ConstManager.ENEMIES_NODE_NAME)

func is_enemy_to_attack() -> bool:
	return enemy_container and is_player_alive
	
