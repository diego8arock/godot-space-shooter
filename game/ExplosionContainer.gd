extends Node2D

onready var bullet_explosion : PackedScene = preload("res://particles/BulletExplosion.tscn")
onready var damage_explosion : PackedScene = preload("res://particles/DamageExplosion.tscn")
onready var shield_explosion : PackedScene = preload("res://particles/ShieldExplosion.tscn")
onready var bomb_explosion : PackedScene = preload("res://particles/BombExplosion.tscn")

func _ready():
	pass

func create_bullet_explosion(_pos : Vector2) -> void:
	create_explosion(bullet_explosion.instance(), _pos)
	
func create_bullet_on_shield_explosion(_pos : Vector2) -> void:
	create_explosion(shield_explosion.instance(), _pos)
	
func create_bomb_explosion(_pos: Vector2) -> void:
	create_explosion(bomb_explosion.instance(), _pos)
	
func create_damage_explosion(_pos : Vector2) -> void:
	create_explosion(damage_explosion.instance(), _pos)
	
func create_explosion(_explosion, _pos: Vector2) -> void:
	add_child(_explosion)
	_explosion.set_position(_pos)