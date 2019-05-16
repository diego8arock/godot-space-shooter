extends Node

class_name Command, "res://interfaces/command.gd"

# warning-ignore:unused_class_variable
export var debug : bool = false
export var warn : bool = false

# warning-ignore:unused_class_variable
var game : Game
# warning-ignore:unused_signal
signal command_finished()

# warning-ignore:unused_class_variable
var is_active : bool = true
var id : int

func _ready() -> void:
	add_to_group(ConstManager.COMMAND_GROUP)
	
func initialize() -> void:
	WarningManager.warn(name + str(DebugManager.get_unique_id()), "initialize method was not overriden", warn)
	
func execute() -> void:
	WarningManager.warn(name + str(DebugManager.get_unique_id()), "execute method was not overriden", warn)
	yield(get_tree().create_timer(0.0001),"timeout")
	emit_signal(ConstManager.COMMAND_FINISHED_SIGNAL)

func finalize() -> void:
	WarningManager.warn(name + str(DebugManager.get_unique_id()), "finalize method was not overriden", warn)

#extends Command
#
#func initialize() -> void:
#	return
#
#func execute() -> void:
#	emit_signal(ConstManager.COMMAND_FINISHED_SIGNAL)
#
#func finalize() -> void:
#	return
