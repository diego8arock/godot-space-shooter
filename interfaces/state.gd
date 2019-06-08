extends Node

class_name State, "res://interfaces/state.gd"

var execute_state : bool = true

func enter(_host: Node2D) -> void:
	execute_state = true
	return
	
func exit(_host: Node2D) -> void:
	execute_state = false
	return
	
func handle_input(_host: Node2D, _event) -> void:
	return

func update(_host: Node2D, _delta: float) -> String:
	return ConstManager.EMPTY_STRING
	
func fixed_update(_host: Node2D, _delta: float) -> String:
	return ConstManager.EMPTY_STRING



	

