extends Node2D

export var debug = false
var do_process_enemies : bool = false

signal all_destroyed()

func _ready():
	pass

func _process(delta: float) -> void:
	
	DebugManager.debug(name, get_child_count(), debug)
	if do_process_enemies and get_child_count() == 0:	
		do_process_enemies = false
		emit_signal("all_destroyed")
	
func start_processing() -> void:
	do_process_enemies = true

func stop_processing() -> void:
	do_process_enemies = false