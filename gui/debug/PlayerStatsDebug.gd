extends VBoxContainer

func _ready():
	pass

func add_stat(_name : String, _value) -> void:
	var label = get_node(_name)
	if not label:
		label = Label.new()
		add_child(label)
	label.name = _name
	label.text = _name + ": " + str(_value)
	