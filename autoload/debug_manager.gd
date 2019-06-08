extends Node

var debug_info
var bullet_id : int = 0
var debug_id : int = 0
var unique_id : int = 0
var global_do_debug : bool = true
# warning-ignore:unused_class_variable
var weapons_do_debug : bool = false

signal debug_updated(node,text,id)
signal debug_delete(node)

func _ready():
	if not get_tree().get_root().has_node(ConstManager.GAME_NODE_NAME):
		return
	
	var main_node = get_tree().get_root().get_node(ConstManager.GAME_NODE_NAME)
			
	if not main_node:
		return		
			
	if main_node.has_node(ConstManager.DEBUG_NODE_NAME):
		debug_info = main_node.get_node(ConstManager.DEBUG_NODE_NAME)
		connect("debug_updated", DebugManager.debug_info, "_on_signal_updateLabel")
		connect("debug_delete", DebugManager.debug_info, "_on_signal_deleteLabel")
	else:
		global_do_debug = false
	

func debug(_node, _text, do_debug = true) -> void:
	if global_do_debug and do_debug:
		debug_id += 1
		emit_signal("debug_updated", _node, str(_text), debug_id)

func debug_remove(_node) -> void:
	if global_do_debug:
		emit_signal("debug_delete", _node)
		
func debug_states(_node, _states_stack, do_debug = true) ->void:
	if global_do_debug and do_debug:
		debug_id += 1
		var states_name = ""
		for s in _states_stack:
			states_name += s.name + " | "
		emit_signal("debug_updated", _node, states_name, debug_id)

func get_new_bullet_id() -> int:
	bullet_id += 1
	return bullet_id
	
func get_unique_id() -> int:
	unique_id += 1
	return unique_id