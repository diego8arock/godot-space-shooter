extends Node

class_name State, "res://interfaces/state.gd"

var execute_state : bool = true

func enter(_host) -> void:
	execute_state = true
	return
	
func exit(_host) -> void:
	execute_state = false
	return
	
func handle_input(_host, _event) -> void:
	return

func update(_host, _delta) -> String:
	return ConstManager.EMPTY_STRING
	
func fixed_update(_host, _delta) -> String:
	return ConstManager.EMPTY_STRING



	

