extends Node

#Game nodes
onready var game = get_tree().get_root().get_node(ConstManager.GAME_NODE_NAME)
onready var player_init_position = game.get_node(ConstManager.PLAYER_INITIAL_POSITION)
onready var enemy_container = game.get_node(ConstManager.ENEMIES_NODE_NAME)

#Player scenes
onready var old_life_scene : PackedScene = preload("res://player/OldLife.tscn")
onready var player_scene : PackedScene = preload("res://player/Player.tscn")
onready var crosshair_scene : PackedScene = preload("res://crosshair/Crosshair.tscn")
onready var player_gui_scene : PackedScene = preload("res://gui/player/PlayerGUI.tscn")

#Player objects
var player
var crosshair
var player_gui

#Player variables
var player_lifes : int = 1
var player_last_position : Vector2

#Enemies scenes
onready var turret_scene : PackedScene = preload("res://enemies/turret/Turret.tscn")

#Enemies variables
onready var enemy_aim_to

func _unhandled_key_input(event):
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

var index = 0
func start_game() -> void:
	DebugManager.debug("GameManager" + str(index), "start_game")
	index += 1
	intialize_player()
	intialize_enemies()

func intialize_player() -> void:
	player_gui = player_gui_scene.instance()
	game.add_child(player_gui)
	crosshair = crosshair_scene.instance()
	crosshair.debug = false
	crosshair.scale = Vector2(ConstManager.CROSSHAIR_SCALE_X, ConstManager.CROSSHAIR_SCALE_Y)
	game.add_child(crosshair)
	crosshair.global_position = player_init_position.global_position
	player = player_scene.instance()
	player.scale = Vector2(ConstManager.PLAYER_SCALE_X, ConstManager.PLAYER_SCALE_Y)
	game.add_child(player)

func intialize_enemies():
	var turret = turret_scene.instance()
	enemy_container.add_child(turret)
	turret.global_position = Vector2(512,300)
	turret.scale = Vector2(ConstManager.TURRET_SCALE_X, ConstManager.TURRET_SCALE_Y)

func process_player_death() -> void:	
	player_last_position = enemy_aim_to.global_position
	enemy_aim_to = null
	player = null
	player_lifes -= 1
	if player_lifes == 0:
		create_old_life()
		
func create_old_life() -> void:
	var new_old_life = old_life_scene.instance()
	game.add_child(new_old_life)
	new_old_life.start_at(player_last_position)
	
