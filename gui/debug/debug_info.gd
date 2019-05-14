extends VBoxContainer
const TAG = "[DEBUG]:"
var labels = {}

func _process(delta):
	rect_global_position = Vector2(0,0)

func _on_signal_updateLabel(_node, _text) -> void:
	var new_text = TAG + _node + " - " + _text
	if labels.has(_node):
		labels[_node].text = new_text
	else:
		var label = Label.new()
		label.text = new_text
		add_child(label)
		labels[_node] = label

func _on_signal_deleteLabel(_node) ->void:
	if labels.has(_node):
		var label = labels[_node]
		remove_child(label)
		labels.erase(_node)
		
		
		
		
		
		
		