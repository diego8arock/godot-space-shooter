extends Node2D
class_name Game

#Debug
export var debug = false
export var debug_player : bool = false

#Nodes
onready var player_inital_position = $PlayerInitialPosition
onready var enemy_container = $EnemyContainer
onready var margin_gui = $PlayerGUI/Margin
onready var canvas_gui = $PlayerGUI
onready var level_start_timer = $LevelStartTimer
onready var respawn_timer = $PlayerRespawnTimer
onready var grid = $Grid
onready var paths = $Paths

#Screens
onready var screens = $Screens
onready var screen_countdown = $Screens/CountdownScreen
onready var screen_gameover = $Screens/GameOverScreen
onready var screen_levelcompleted = $Screens/LevelCompletedScreen
onready var screen_stats = $Screens/StatsScreen
onready var screen_ship_destroyed = $Screens/ShipDestroyedScreen

#Scenes
onready var player_scene : PackedScene = preload("res://player/Player.tscn")
onready var crosshair_scene : PackedScene = preload("res://crosshair/Crosshair.tscn")
onready var player_gui_scene : PackedScene = preload("res://gui/player/PlayerGUI.tscn")
onready var old_life_scene : PackedScene = preload("res://old_life/OldLife.tscn")
onready var turret_scene : PackedScene = preload("res://enemies/turret/Turret.tscn")

#Signals
signal player_died()
signal player_respawned(_position)
signal old_life_picked()
signal update_xp()
signal update_health()
signal countdown_finished()
signal enemies_destroyed()

var is_countdown_tween_completed : bool = false
var recovered_xp : int = 0

enum ACTION { START_GAME, LOAD_LEVEL, START_LEVEL,  PLAYER_DIED, PLAYER_RESPAWN, CONTINUE_LEVEL, CONTINUE_LEVEL_SKIP, OLD_LIFE_PICKED, ENEMIES_DESTROYED }

#Own Methods
func _init() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS

func _ready() -> void:
	GameManager.damage_container = $DamageContainer
	GameManager.explosion_container = $ExplosionContainer
	margin_gui.hide()
	LevelManager.load_levels()

func _process(delta: float) -> void:
	
	if level_start_timer.time_left > 0.0 and is_countdown_tween_completed:
		screen_countdown.update_text_as_timer(int(level_start_timer.time_left))
				
func _unhandled_key_input(event):	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

#New Methods
func play(_action) -> void:
	match _action:
		ACTION.START_GAME:
			start_game()
		ACTION.LOAD_LEVEL:
			load_level()
		ACTION.START_LEVEL:
			start_level()
		ACTION.PLAYER_DIED:
			player_died()
		ACTION.PLAYER_RESPAWN:
			player_respawn()
		ACTION.CONTINUE_LEVEL:
			continue_level(false)
		ACTION.CONTINUE_LEVEL_SKIP:
			continue_level(true)
		ACTION.OLD_LIFE_PICKED:
			old_life_picked()
		ACTION.ENEMIES_DESTROYED:
			enemies_destroyed()

func start_game() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = true
	init_gui()
	init_crosshair()
	init_player()
	play(ACTION.LOAD_LEVEL)

func load_level() -> void:
	get_tree().paused = true
	GameManager.crosshair.move_to_game_position($PlayerInitialPosition.global_position, $CrosshairGamePosition.global_position)
	init_enemies()
	create_old_life()
	countdown_to_start()

func start_level() -> void:	
	screens.change_screen(null)
	enemy_container.start_processing()
	get_tree().paused = false
	emit_signal("countdown_finished")

func continue_level(_skip : bool) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if GameManager.use_crosshair_as_pivot:
		GameManager.crosshair.global_position = player_inital_position.global_position
	if not _skip:
		GameManager.copy_temp_to_stats()
		GameManager.player.udpate_stats()	
		GameManager.player.update_health()
		GameManager.player_xp = GameManager.temp_player_xp
		GameManager.player_health = GameManager.temp_player_health
		emit_signal("update_xp")
		emit_signal("update_health")
	play(ACTION.LOAD_LEVEL)
	
func old_life_picked() -> void: 
	GameManager.player_lifes += 1
	GameManager.player_xp += recovered_xp
	DebugManager.debug(name + "-old_life_picked", recovered_xp, debug)
	emit_signal("old_life_picked")
	emit_signal("update_xp")

func player_died() -> void:
	enemy_container.stop_processing()
	GameManager.player_last_level = GameManager.level
	GameManager.player_lifes -= 1
	GameManager.is_player_alive = false
	DebugManager.debug(name + "-player_lifes", GameManager.player_lifes, debug)
	GameManager.level = 1
	GameManager.lost_player_xp = GameManager.player_xp
	emit_signal("update_xp")
	for c in enemy_container.get_children():
		c.call_deferred("free")
	if GameManager.player_lifes == 0:
		emit_signal("player_died")
		screen_ship_destroyed.set_subtitle("xp can be recovered")
		screens.change_screen(screen_ship_destroyed)
	if GameManager.player_lifes < 0:
		screen_ship_destroyed.set_subtitle("xp lost")
		screens.change_screen(screen_ship_destroyed)
	respawn_timer.start()

func player_respawn() -> void:
	get_tree().paused = true
	GameManager.is_player_alive = true
	emit_signal("player_respawned", player_inital_position.global_position)
	if not GameManager.use_crosshair_as_pivot:
		GameManager.player.global_position = player_inital_position.global_position
	else:
		GameManager.crosshair.global_position = player_inital_position.global_position
		GameManager.player_pivot.global_position = GameManager.crosshair.get_line_end_position().global_position
	play(ACTION.LOAD_LEVEL)

func enemies_destroyed() -> void:
	DebugManager.debug(name, "_on_EnemyContainer_all_destroyed", debug)
	emit_signal("enemies_destroyed")
	GameManager.crosshair.move_to_end_position(GameManager.player.exit_position.global_position)
	GameManager.level += 1
	if GameManager.level <= GameManager.max_level:
		screens.change_screen(screen_levelcompleted)
		yield(screen_levelcompleted.tween, "tween_completed")
		yield(get_tree().create_timer(1.0), "timeout")
		init_and_show_stats_gui()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func countdown_to_start() -> void:
	screen_countdown.update_text_as_timer(3)
	is_countdown_tween_completed = false
	screens.change_screen(screen_countdown)
	is_countdown_tween_completed = true
	yield(get_tree().create_timer(1.0), "timeout")
	level_start_timer.start()	
	
func init_gui() -> void:
	margin_gui.show()
	connect("player_died", canvas_gui, "on_Game_player_died")
	connect("old_life_picked", canvas_gui, "on_Game_old_life_picked")
	connect("update_xp", canvas_gui, "on_Game_update_xp")
	connect("update_health", canvas_gui, "on_Game_update_health")
	
func init_crosshair() -> void:
	var crosshair : Crosshair = crosshair_scene.instance()
	crosshair.debug = debug_player
	add_child(crosshair)
	crosshair.global_position = player_inital_position.global_position
	GameManager.crosshair = crosshair
	connect("player_died", crosshair, "on_Game_player_died")
	connect("player_respawned", crosshair, "on_Game_player_respawned")
	connect("countdown_finished", crosshair, "on_Game_countdown_finished")
	connect("enemies_destroyed", crosshair, "on_Game_enemies_destroyed")
	
func init_player() -> void:
	var player : Player = player_scene.instance()
	player.debug = debug_player
	add_child(player)
	player.udpate_stats()
	player.global_position = player_inital_position.global_position
	GameManager.player = player
	GameManager.enemy_aim_to = player.aim_to
	connect("player_died", player, "on_Game_player_died")
	connect("player_respawned", player, "on_Game_player_respawned")
	connect("countdown_finished", player, "on_Game_countdown_finished")
	connect("enemies_destroyed", player, "on_Game_enemies_destroyed")

func init_enemies() -> void:
	var enemies = LevelManager.load_level_enemies(GameManager.level)
	for e in enemies:
		var pos : Position2D = grid.get_node("R" + str(e.row)).get_node("P" + str(e.pos))
		var npc = e.npc
		enemy_container.add_child(npc)
		npc.adjust_stats_by_level()
		npc.add_stats_to_debug()
		npc.debug = false
		npc.global_position = pos.global_position

func create_old_life() -> void:
	if GameManager.level == GameManager.player_last_level:
		var old_life = old_life_scene.instance()
		paths.path_add_old_life(0, old_life)
		old_life.set_xp()
		old_life.set_level()
		old_life.connect("player_entered", self, "on_OldLife_player_entered")
		connect("old_life_picked", old_life, "on_Game_old_life_picked")
		old_life.start_at(Vector2(200,200))

func init_and_show_stats_gui() -> void:
	GameManager.copy_stats_to_temp()
	GameManager.stats_gui.set_level(GameManager.player_level)
	GameManager.stats_gui.set_xp(GameManager.player_xp)
	GameManager.temp_player_health = GameManager.player_health
	GameManager.stats_gui.calculate_req_xp_value()
	GameManager.stats_gui.validate_req_xp() 
	GameManager.stats_gui.set_stats_values()
	GameManager.stats_gui.set_skills_values()
	GameManager.stats_gui.set_health_value()
	screens.change_screen(screen_stats)

#Signals	
func _on_Screens_start_game() -> void:
	play(ACTION.START_GAME)
	
func _on_Screens_continue_game(_skip) -> void:
	play(ACTION.CONTINUE_LEVEL_SKIP if _skip else ACTION.CONTINUE_LEVEL)
		
func on_Player_player_died() -> void:
	play(ACTION.PLAYER_DIED)
	
func on_OldLife_player_entered(_xp) -> void:
	recovered_xp = _xp
	play(ACTION.OLD_LIFE_PICKED)

func _on_LevelStartTimer_timeout() -> void:
	play(ACTION.START_LEVEL)

func _on_PlayerRespawnTimer_timeout() -> void:
	play(ACTION.PLAYER_RESPAWN)

func _on_EnemyContainer_all_destroyed() -> void:
	play(ACTION.ENEMIES_DESTROYED)


