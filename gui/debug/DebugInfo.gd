extends Control

onready var font : Resource = preload("res://gui/debug/debug_dynamicfont.tres")
onready var container = $VBoxContainer
const TAG = "[DEBUG]:"
var labels = {}

# warning-ignore:unused_argument
func _process(delta : float) -> void:
	rect_global_position = Vector2(0,0)

func _on_signal_updateLabel(_node, _text, _id) -> void:
	var new_text = get_time_string() + TAG + get_id_string(_id)  + _node + " - " + _text
	Logger.debug(new_text,"debug")
	if labels.has(_node):
		labels[_node].text = new_text
	else:
		var label = Label.new()
		label.add_font_override("font", font)
		label.text = new_text
		container.add_child(label)
		labels[_node] = label

func _on_signal_deleteLabel(_node) ->void:
	if labels.has(_node):
		var label = labels[_node]
		container.remove_child(label)
		labels.erase(_node)
	
func get_time_string() -> String:
	var timeDict = OS.get_time();
	var hour = str(timeDict.hour)
	var minute = str(timeDict.minute)
	var seconds = str(timeDict.second)	
	return "[" + hour + ":" + minute + ":" + seconds + "]"
		
func get_id_string(id) -> String:
	return "[ID:" + str(id) + "]: "
		
		
		