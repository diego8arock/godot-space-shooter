extends Node

var warning_info
var global_do_warning : bool = true

signal warning_updated(node,text)
signal warning_delete(node)

func _ready():
	var main_node = get_tree().get_root().get_node(ConstManager.GAME_NODE_NAME)
	
	if main_node.has_node(ConstManager.WARNING_NODE_NAME):
		warning_info = main_node.get_node(ConstManager.WARNING_NODE_NAME)
# warning-ignore:return_value_discarded
		connect("warning_updated", WarningManager.warning_info, "_on_signal_updateLabel")
# warning-ignore:return_value_discarded
		connect("warning_delete", WarningManager.warning_info, "_on_signal_deleteLabel")
	else:
		global_do_warning = false	

func warn(_node, _text, do_warning = true) -> void:
	if global_do_warning and do_warning:
		emit_signal("warning_updated", _node, str(_text))

func warn_remove(_node) -> void:
	if global_do_warning:
		emit_signal("warning_delete", _node)
