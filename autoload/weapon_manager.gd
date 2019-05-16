extends Node

var weapon_container = null

const GROUP_WEAPON_PLAYER = "player"
const GROUP_WEAPON_ENEMY = "enemy"

const PLAYER_BULLET_DAMAGE_BASE : float = 5.0
const PLAYER_SUPER_BULLET_DAMAGE_BASE : float = 8.0

const ENEMY_BULLETS_DAMAGE_BASE : float = 20.0
const ENEMY_MISSILE_DAMAGE_BASE : float = 50.0

func _ready():
	if get_tree().get_root().has_node(ConstManager.GAME_NODE_NAME):
		weapon_container = get_tree().get_root().get_node(ConstManager.GAME_NODE_NAME).get_node(ConstManager.WEPONS_NODE_NAME)

func add_weapon(_weapon, _scale_x=1, _scale_y=1) -> void:
	if weapon_container:
		_weapon.scale = Vector2(_scale_x, _scale_y)
		weapon_container.add_child(_weapon)
