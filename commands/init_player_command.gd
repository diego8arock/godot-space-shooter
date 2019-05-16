extends Command

onready var player_scene : PackedScene = preload("res://player/Player.tscn")

func initialize() -> void:
	game.player = player_scene.instance()
	game.player.scale = Vector2(ConstManager.PLAYER_SCALE_X, ConstManager.PLAYER_SCALE_Y)
	game.player.debug = false
	game.add_child(game.player)
	GameManager.enemy_aim_to = game.player.aim_to