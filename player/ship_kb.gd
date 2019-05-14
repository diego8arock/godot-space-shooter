extends KinematicBody2D

signal take_damage(value)

func take_damage(_value) -> void:
	emit_signal("take_damage", _value)
