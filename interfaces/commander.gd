extends Node

class_name Commander, "res://interfaces/commander.gd"

export var debug : bool = false
export var warn : bool = false

var game : Game
var subordinate_commands = []
signal command_finished()

var id : int

func _ready():
	get_subordiante_commands()

func get_subordiante_commands() -> void:
	subordinate_commands = get_children()
	if subordinate_commands.size() == 0:
		WarningManager.warn(name, "has no subordiante commands", warn)
	DebugManager.debug(name, "command has " + str(subordinate_commands.size()) + " subordiantes", debug)
	
func run() -> void:
	if subordinate_commands.size() > 0:
		for c in subordinate_commands:
			run_command(c)
	
func run_command(c : Command) -> void:
	DebugManager.debug(name, "command initializing: " + c.name,debug)
	c.initialize(game, debug, warn)
	DebugManager.debug(name, "command executing: " + c.name,debug)
	if c.use_yield:
		c.run()
		yield(c, ConstManager.COMMAND_FINISHED_SIGNAL)	
	else:
		c.run()
	
	
	