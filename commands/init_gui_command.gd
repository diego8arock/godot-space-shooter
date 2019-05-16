extends Command

onready var player_gui_scene : PackedScene = preload("res://gui/player/PlayerGUI.tscn")

func initialize() -> void:
	game.player_gui = player_gui_scene.instance()
	game.add_child(game.player_gui)

