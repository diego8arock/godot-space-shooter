extends VBoxContainer

func _ready() -> void:
	pass

func add_stat(_name : String, _value) -> void:
	var label = Label.new()
	label.text = _name + ": " + str(_value)
	add_child(label)