extends Node2D

onready var damage : PackedScene = preload("res://damage/Damage.tscn")

func create_damage(_pos : Vector2, _scale : float) -> void:
	var d = damage.instance()
	add_child(d)
	d.create_damage(_pos, _scale)
	
	