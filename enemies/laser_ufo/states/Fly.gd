extends State

var path = ["R1-P0", "R1-P1", "R2-P10", "R9-P1", "R10-P10", "R5-P6"]
var tween : Tween
var initial_pos : Position2D
var final_pos : Position2D
var continue_moving : bool = false
var path_index : int = 0

func enter(_host: Node2D) -> void:
	.enter(_host)
	tween = _host.get_node("Tween")
	continue_moving = true
	path_index = 0

func exit(_host: Node2D) -> void:
	.exit(_host)

func update(_host: Node2D, _delta: float) -> String:	
	
	if continue_moving: 
	
		if path_index == path.size() - 1:
			return "attack"
			
		var init = path[path_index].split("-")
		var end = path[path_index + 1].split("-")
		initial_pos = GameManager.grid.get_grid_position(init[0], init[1])
		final_pos = GameManager.grid.get_grid_position(end[0], end[1])
		
		move_to_position(_host, initial_pos.global_position, final_pos.global_position)		
	
	return ConstManager.EMPTY_STRING
	
func move_to_position(_host: Node2D, inital: Vector2, final: Vector2) -> void:
	tween.interpolate_property(_host, "global_position", inital, final, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	continue_moving = false
	path_index += 1	

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	continue_moving = true
