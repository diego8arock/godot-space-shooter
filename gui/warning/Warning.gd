extends Control

onready var container = $VBoxContainer
var labels = {}
const TAG = "[WARN]:"
onready var width = get_viewport().size.x / 2

# warning-ignore:unused_argument
func _process(delta : float) -> void:
	rect_global_position = Vector2(width, 0)

func _on_signal_updateLabel(_node, _text) -> void:
	var new_text = TAG + _node + " - " + _text
	Logger.warn(new_text,"warn")
	if labels.has(_node):
		labels[_node].text = new_text
	else:
		var label = Label.new()
		label.rect_global_position = Vector2(width, 0)
		label.text = new_text
		container.add_child(label)
		labels[_node] = label

func _on_signal_deleteLabel(_node) ->void:
	if labels.has(_node):
		var label = labels[_node]
		container.remove_child(label)
		labels.erase(_node)
		
		
		
		
		
		
		