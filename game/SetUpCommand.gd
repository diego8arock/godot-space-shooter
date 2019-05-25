extends Command

onready var stats_gui : Control 
onready var player_gui : Control

func initialize(_game, _debug = false, _warn = false) -> void:
	.initialize(_game, _debug, _warn)
	stats_gui = game.get_node("StatsGUI")
	player_gui = game.get_node("PlayerGUI/Margin")

func run() -> void:
	player_gui.hide()
	stats_gui.hide()
	LevelManager.load_levels()
	emit_signal("command_finished")