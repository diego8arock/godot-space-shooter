extends HBoxContainer

onready var label_value = $StatValue
export var stat_name : String = ""
var value : int = 0
var new_value

func _ready():
	if not stat_name.empty():
		$StatName.text = stat_name
	new_value = value

func _on_AddStat_pressed() -> void:
	new_value += 1
	set_value()

func _on_SubStat_pressed() -> void:
	new_value -= 1
	set_value()

func set_value() -> void:
	new_value = clamp(new_value, 0, 99)
	if new_value < 10:
		label_value.text = "0" + str(new_value)
	else:
		label_value.text = str(new_value)