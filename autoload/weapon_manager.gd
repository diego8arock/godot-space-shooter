extends Node

var bullet_container

func _ready():
	bullet_container = get_tree().get_root().get_node("Game").get_node("BulletContainer")

func add_weapon(_weapon, _scale_x, _scale_y) -> void:
	_weapon.scale = Vector2(_scale_x, _scale_y)
	bullet_container.add_child(_weapon)
