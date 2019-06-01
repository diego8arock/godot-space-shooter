extends HBoxContainer
class_name StatContainer

onready var label_value = $StatValue
export var stat_name : String = ""
var value : int = 0
var new_value
onready var parent = get_parent().get_parent().get_parent().get_parent()

signal addstat(_name)
signal substat(_name)

func _ready():
	if not stat_name.empty():
		$StatName.text = stat_name
	new_value = value
	connect("addstat", parent, "on_StatContianer_add_stat", [name])
	connect("substat", parent, "on_StatContianer_sub_stat", [name])

func _on_AddStat_pressed() -> void:
	if int(label_value.text) == 99:
		return
	new_value += 1
	update_value()
	emit_signal("addstat")

func _on_SubStat_pressed() -> void:
	if int(label_value.text) == 0:
		return
	if new_value - 1 < GameManager.stats[name]:
		return
	new_value -= 1
	update_value()
	emit_signal("substat")

func set_value(_value) -> void:
	if _value < 10:
		label_value.text = "0" + str(_value)
	else:
		label_value.text = str(_value)

func update_value() -> void:
	new_value = clamp(new_value, 0, 99)
	GameManager.stats_temp[name] = new_value
	set_value(new_value)
