extends Resource
class_name EnemyResource, "res://resources/enemies/enemy_resource.gd"

enum ENEMY_TYPE { TURRET }

export (ENEMY_TYPE) var type 
export var stats : Resource #NpcStartingStats
export var scene : PackedScene
