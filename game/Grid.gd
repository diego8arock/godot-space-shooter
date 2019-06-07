extends Node2D

var occupied_positions = []

func reset_positions() -> void:
	occupied_positions = []

func save_position(pos : String) -> void:
	occupied_positions.push_back(occupied_positions)
	
func is_position_occupied(pos : String) -> bool:
	return occupied_positions.has(pos)
	
func get_random_free_position() -> Position2D:
	randomize()
	var row = "R" + str(randi() % 10 + 1)
	var column = "P" + str(randi() % 10 + 1)
	print(row + "-" + column)
	if not is_position_occupied(row + column):
		return get_grid_position(row, column)
	return null
	
func get_grid_position(row : String, column : String) -> Position2D:
	return get_node(row).get_node(column) as Position2D 
