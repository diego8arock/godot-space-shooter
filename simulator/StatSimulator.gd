extends Control

signal stat_changed(_name, _value)

func _ready():
	pass

func _on_Value_text_changed() -> void:
	emit_signal("stat_changed", $HBoxContainer/Label.text, $HBoxContainer/Value.text)
