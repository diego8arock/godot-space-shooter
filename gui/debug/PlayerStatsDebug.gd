extends VBoxContainer

onready var font : Resource = preload("res://gui/debug/debug_dynamicfont.tres")

func _ready():
	pass

func add_stat(_name : String, _value) -> void:
	var label = Label.new() if not has_node(_name) else get_node(_name)
	label.add_font_override("font", font)
	if not has_node(_name):
		add_child(label)
	label.name = _name
	label.text = _name + ": " + str(_value)
	