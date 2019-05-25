extends Node2D
class_name Game

export var debug_player : bool = false

onready var player_inital_position = $PlayerInitialPosition
onready var enemy_container = $EnemyContainer

#Scenes
onready var player_scene : PackedScene = preload("res://player/Player.tscn")
onready var crosshair_scene : PackedScene = preload("res://crosshair/Crosshair.tscn")
onready var player_gui_scene : PackedScene = preload("res://gui/player/PlayerGUI.tscn")
onready var old_life_scene : PackedScene = preload("res://old_life/OldLife.tscn")
onready var turret_scene : PackedScene = preload("res://enemies/turret/Turret.tscn")

signal player_died()
signal player_respawned(_position)
signal old_life_picked()

var is_countdown_tween_completed : bool = false

func _init() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS

func _ready() -> void:
	$PlayerGUI/Margin.hide()
	$StatsGUI.hide()
	LevelManager.load_levels()

func _process(delta: float) -> void:
	
	if $LevelStartTimer.time_left > 0.0 and is_countdown_tween_completed:
		$Screens/Countdown.update_text_as_timer(int($LevelStartTimer.time_left))
		
func _unhandled_key_input(event):	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_Screens_start_game() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	init_guid()
	init_crosshair()
	init_player()
	init_enemies()
	get_tree().paused = true
	$Screens/Countdown.update_text_as_timer(3)
	$Screens/Countdown.appear()
	yield($Screens/Countdown.tween, "tween_completed")
	is_countdown_tween_completed = true
	yield(get_tree().create_timer(0.5), "timeout")
	$LevelStartTimer.start()	
	
func init_guid() -> void:
	$PlayerGUI/Margin.show()
	connect("player_died", $PlayerGUI, "on_Game_player_died")
	connect("old_life_picked", $PlayerGUI, "on_Game_old_life_picked")
	
func init_crosshair() -> void:
	var crosshair : Crosshair = crosshair_scene.instance()
	crosshair.debug = debug_player
	add_child(crosshair)
	crosshair.global_position = player_inital_position.global_position
	GameManager.crosshair = crosshair
	connect("player_died", crosshair, "on_Game_player_died")
	connect("player_respawned", crosshair, "on_Game_player_respawned")
	
func init_player() -> void:
	var player : Player = player_scene.instance()
	player.debug = debug_player
	add_child(player)
	GameManager.player = player
	GameManager.enemy_aim_to = player.aim_to
	connect("player_died", player, "on_Game_player_died")
	connect("player_respawned", player, "on_Game_player_respawned")

func init_enemies() -> void:
	var enemies = LevelManager.load_level_enemies(GameManager.level)
	for e in enemies:
		var pos : Position2D = $Grid.get_node("R" + str(e.row)).get_node("P" + str(e.pos))
		var npc = e.npc
		enemy_container.add_child(npc)
		npc.debug = false
		npc.global_position = pos.global_position
	
func create_old_life(_position) -> void:
	var old_life = old_life_scene.instance()
	add_child(old_life)
	old_life.connect("player_entered", self, "on_OldLife_player_entered")
	connect("old_life_picked", old_life, "on_Game_old_life_picked")
	old_life.start_at(_position)


#Signals recieved
func on_Player_player_died(_position) -> void:
	GameManager.player_lifes -= 1
	GameManager.is_player_alive = false
	DebugManager.debug(name + "-player_lifes", GameManager.player_lifes)
	if GameManager.player_lifes == 0:
		create_old_life(_position)
		emit_signal("player_died")
		$PlayerRespawnTimer.start()
	if GameManager.player_lifes < 0:
		DebugManager.debug(name, "GAME OVER - YOU LOST")
		get_tree().paused = true 
	
func on_OldLife_player_entered() -> void:
	GameManager.player_lifes += 1
	emit_signal("old_life_picked")

func _on_LevelStartTimer_timeout() -> void:
	$Screens/Countdown.disappear()
	yield($Screens/Countdown.tween, "tween_completed")
	enemy_container.start_processing()
	get_tree().paused = false

func _on_PlayerRespawnTimer_timeout() -> void:
	GameManager.is_player_alive = true
	emit_signal("player_respawned",player_inital_position.global_position)

func _on_EnemyContainer_all_destroyed() -> void:
	DebugManager.debug(name, "all_destroyed")
	GameManager.level += 1
	if GameManager.level <= GameManager.max_level:
		init_enemies()
	else:
		get_tree().paused = true 
		DebugManager.debug(name, "GAME OVER - YOU WON")

