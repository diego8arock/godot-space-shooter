extends Node2D

onready var number : PackedScene = preload("res://utils/NumberAttack.tscn")

func create_number(_position: Vector2, _rotation: Vector2, _number: String) -> void:
	var new_number = number.instance()
	add_child(new_number)
	new_number.set_number(_number)
	new_number.set_start_position(_position, _rotation)
	new_number.show_number()
