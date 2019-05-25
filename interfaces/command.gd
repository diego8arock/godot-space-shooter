extends Node

class_name Command, "res://interfaces/command.gd"

export var debug : bool = false
export var warn : bool = false
export var use_yield : bool = false

var game : Game
signal command_finished()

var is_active : bool = true
var id : int

func initialize(_game, _debug = false, _warn = false) -> void:
	game = _game
	debug = _debug
	warn = _warn	
	id = DebugManager.get_unique_id()
	
func run() -> void:
	WarningManager.warn(name + str(DebugManager.get_unique_id()), "run method was not overriden", warn)
	if use_yield:
		emit_signal(ConstManager.COMMAND_FINISHED_SIGNAL)
