extends VBoxContainer

onready var font : Resource = preload("res://gui/debug/debug_dynamicfont.tres")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	rect_rotation = 0

func add_stat(_name : String, _value) -> void:
	var label = Label.new()
	label.add_font_override("font", font)
	label.text = _name + ": " + str(_value)
	add_child(label)