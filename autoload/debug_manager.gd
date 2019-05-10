extends Node

var debug_info
var bullet_id : int = 0

signal debug_updated(node,text)
signal debug_delete(node)

func _ready():
	debug_info = get_tree().get_root().get_node("Game").get_node("DebugInfo")
	connect("debug_updated", DebugManager.debug_info, "_on_signal_updateLabel")
	connect("debug_delete", DebugManager.debug_info, "_on_signal_deleteLabel")

func debug(_node, _text, do_debug = true) -> void:
	if do_debug:
		emit_signal("debug_updated", _node, str(_text))

func debug_remove(_node) -> void:
	emit_signal("debug_delete", _node)

func get_new_bullet_id() -> int:
	bullet_id += 1
	return bullet_id