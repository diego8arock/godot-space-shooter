extends VBoxContainer

func _ready():
	pass

func add_stat(_name : String, _value) -> void:
	var label = Label.new() if not has_node(_name) else get_node(_name)
	if not has_node(_name):
		add_child(label)
	label.name = _name
	label.text = _name + ": " + str(_value)
	