extends Node2D

onready var bullet_explosion : PackedScene = preload("res://particles/BulletExplosion.tscn")
onready var damage_explosion : PackedScene = preload("res://particles/DamageExplosion.tscn")

func _ready():
	pass

func create_bullet_explosion(_pos : Vector2) -> void:
	var e = bullet_explosion.instance()
	add_child(e)
	e.set_position(_pos)
	
func create_damage_explosion(_pos : Vector2) -> void:
	var e = damage_explosion.instance()
	add_child(e)
	e.set_position(_pos)