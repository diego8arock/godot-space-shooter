extends Command

#Enemies scenes
onready var turret_scene : PackedScene = preload("res://enemies/turret/Turret.tscn")
onready var viewport_size = get_viewport().size

func initialize() -> void:
	var turret = turret_scene.instance()
	game.enemy_container.add_child(turret)
	turret.global_position = Vector2(viewport_size.x / 2, viewport_size.y / 2)
	turret.scale = Vector2(ConstManager.TURRET_SCALE_X, ConstManager.TURRET_SCALE_Y)