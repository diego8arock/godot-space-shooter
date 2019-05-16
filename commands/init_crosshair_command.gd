extends Command

onready var crosshair_scene : PackedScene = preload("res://crosshair/Crosshair.tscn")

func initialize() -> void:
	game.crosshair = crosshair_scene.instance()
	game.crosshair.debug = false
	game.crosshair.scale = Vector2(ConstManager.CROSSHAIR_SCALE_X, ConstManager.CROSSHAIR_SCALE_Y)
	game.add_child(game.crosshair)
	game.crosshair.global_position = game.player_init_position.global_position
	GameManager.crosshair = game.crosshair