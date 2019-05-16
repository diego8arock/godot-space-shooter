extends Area2D

class_name Weapon, "res://interfaces/weapon.gd"

var weapon_damage : float = 0.0
var parent = null

func initialize(_weapon_damage : float, _parent : Node, _group_name : String ) -> void:
	weapon_damage = _weapon_damage
	parent= _parent
	add_to_group(_group_name)

