extends Node

class_name Commander, "res://interfaces/commander.gd"

export var debug : bool = false
export var warn : bool = false

var game : Game
#Commander can have subordiante commanders
var subordinate_commands = []
# warning-ignore:unused_signal
signal command_finished()

var id : int

func _ready():
	add_to_group(ConstManager.COMMAND_GROUP)
	get_subordiante_commands()

func get_subordiante_commands() -> void:
	subordinate_commands = get_children()
	if subordinate_commands.size() == 0:
		WarningManager.warn(name, "has no subordiante commands", warn)
	DebugManager.debug(name, "command has " + str(subordinate_commands.size()) + " subordiantes", debug)
	
func execute() -> void:
	if subordinate_commands.size() > 0:
		for c in subordinate_commands:
			#Workaround no elegant solution done to prevent Parser Error: using own name in class file is not allowed (creates a cylcic reference), possible Godot bug
			if c is Command:
				execute_command(c)
			else:
				execute_chain_command(c)
#			match c:
#				Commander:
#					execute_chain_command(c)
#				Command:
#					execute_command(c)
#				_:
#					WarningManager.warn(name, c.name + " is not a defined command", warn)
	emit_signal(ConstManager.COMMAND_FINISHED_SIGNAL)

func execute_chain_command(c : Commander)  -> void:
	set_command_properties(c)
	c.execute()
	yield(c, ConstManager.COMMAND_FINISHED_SIGNAL)
		
func execute_command(c : Command) -> void:
	set_command_properties(c)
	DebugManager.debug(name, "command initializing: " + c.name,debug)
	c.initialize()
	DebugManager.debug(name, "command executing: " + c.name,debug)
	c.execute()
	yield(c, ConstManager.COMMAND_FINISHED_SIGNAL)
	DebugManager.debug(name, "command finalizing: " + c.name,debug)
	c.finalize() 

func set_command_properties(c) -> void:
	c.game = game
	c.debug = debug
	c.warn = warn
	c.id = DebugManager.get_unique_id()
	
	
	
	
	